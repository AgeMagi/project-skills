#!/usr/bin/env bash

# Locks the comparator's ordinary and exact feature-geometry boundaries.

set -euo pipefail

if [ "$(uname -s)" != 'Darwin' ] || ! command -v swiftc >/dev/null 2>&1; then
  echo 'test_compare_ui.sh requires macOS and the Xcode Swift toolchain.' >&2
  exit 2
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
temporary_dir="$(mktemp -d)"
trap 'rm -rf "$temporary_dir"' EXIT

comparator="$temporary_dir/compare-ui"
swiftc "$script_dir/compare_ui.swift" -o "$comparator"

write_ppm() {
  local path="$1"
  local width="$2"
  local height="$3"
  local feature_x="$4"
  local feature_width="$5"
  local hole_x="$6"
  local hole_y="$7"

  {
    printf 'P3\n%s %s\n255\n' "$width" "$height"
    local y=0
    while [ "$y" -lt "$height" ]; do
      local x=0
      while [ "$x" -lt "$width" ]; do
        if [ "$x" -ge "$feature_x" ] \
          && [ "$x" -lt "$((feature_x + feature_width))" ] \
          && { [ "$x" -ne "$hole_x" ] || [ "$y" -ne "$hole_y" ]; }; then
          printf '255 255 255\n'
        else
          printf '0 0 0\n'
        fi
        x=$((x + 1))
      done
      y=$((y + 1))
    done
  } >"$path"
}

run_expect() {
  local expected_status="$1"
  local name="$2"
  shift 2

  set +e
  "$comparator" "$@" >"$temporary_dir/$name.log" 2>&1
  local actual_status="$?"
  set -e

  if [ "$actual_status" -ne "$expected_status" ]; then
    echo "$name returned $actual_status; expected $expected_status." >&2
    sed -n '1,120p' "$temporary_dir/$name.log" >&2
    exit 1
  fi
}

assert_contains() {
  local expected="$1"
  local path="$2"

  if ! grep -Fq "$expected" "$path"; then
    echo "Missing expected text in $path: $expected" >&2
    sed -n '1,120p' "$path" >&2
    exit 1
  fi
}

reference_95="$temporary_dir/reference-95.ppm"
actual_95="$temporary_dir/actual-95.ppm"
reference_96="$temporary_dir/reference-96.ppm"
actual_96="$temporary_dir/actual-96.ppm"
reference_shifted="$temporary_dir/reference-shifted.ppm"
actual_shifted="$temporary_dir/actual-shifted.ppm"

write_ppm "$reference_95" 4 5 0 4 -1 -1
write_ppm "$actual_95" 4 5 0 4 1 1
write_ppm "$reference_96" 5 5 0 5 -1 -1
write_ppm "$actual_96" 5 5 0 5 2 2
write_ppm "$reference_shifted" 54 50 1 50 -1 -1
write_ppm "$actual_shifted" 54 50 2 50 -1 -1

feature_arguments=(
  --reference-feature-color 255,255,255
  --actual-feature-color 255,255,255
  --feature-color-tolerance 0
  --minimum-feature-pixels 1
)

run_expect 0 rgb-identical \
  --reference "$reference_96" \
  --actual "$reference_96" \
  --output-dir "$temporary_dir/rgb-identical"

run_expect 0 ordinary-95 \
  --reference "$reference_95" \
  --actual "$actual_95" \
  --output-dir "$temporary_dir/ordinary-95" \
  --acceptance feature-geometry \
  --geometry-tolerance 0 \
  --minimum-feature-iou 0.95 \
  "${feature_arguments[@]}"

run_expect 1 exact-95 \
  --reference "$reference_95" \
  --actual "$actual_95" \
  --output-dir "$temporary_dir/exact-95" \
  --exact-feature-match \
  "${feature_arguments[@]}"

run_expect 0 exact-96 \
  --reference "$reference_96" \
  --actual "$actual_96" \
  --output-dir "$temporary_dir/exact-96" \
  --exact-feature-match \
  "${feature_arguments[@]}"

run_expect 1 exact-shifted \
  --reference "$reference_shifted" \
  --actual "$actual_shifted" \
  --output-dir "$temporary_dir/exact-shifted" \
  --exact-feature-match \
  "${feature_arguments[@]}"

run_expect 2 exact-missing-colors \
  --reference "$reference_96" \
  --actual "$actual_96" \
  --output-dir "$temporary_dir/exact-missing-colors" \
  --exact-feature-match

assert_contains 'Feature silhouette IoU: 95.0000% (required >= 95.0000%)' \
  "$temporary_dir/ordinary-95.log"
assert_contains 'Feature silhouette IoU: 95.0000% (required > 95.0000%)' \
  "$temporary_dir/exact-95.log"
assert_contains 'Feature silhouette IoU: 96.0000% (required > 95.0000%)' \
  "$temporary_dir/exact-96.log"
assert_contains 'Feature geometry FAIL: x 1, y 0, width 0, height 0 (maximum 0)' \
  "$temporary_dir/exact-shifted.log"

report="$temporary_dir/exact-96/comparison-report.json"
assert_contains '"acceptance" : "feature-geometry"' "$report"
assert_contains '"exact_feature_match" : true' "$report"
assert_contains '"geometry_tolerance" : 0' "$report"
assert_contains '"intersection_over_union_operator" : ">"' "$report"

echo 'compare_ui boundary tests passed.'
