#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  cat <<'EOF'
Usage: compare_simulator.sh --reference PATH --output-dir DIR [options]

Simulator options:
  --device NAME_OR_UDID       Exact booted iPhone name or UDID
  --wait SECONDS              Delay before capture (default: 0.5)

Comparison options:
  --reference-crop X,Y,W,H    Crop reference from top-left
  --actual-crop X,Y,W,H       Crop simulator capture from top-left
  --ignore X,Y,W,H            Ignore rectangle; may be repeated
  --mask PATH                 White/opaque pixels compare; black/transparent ignore
  --acceptance MODE           rgb (default) or feature-geometry
  --reference-feature-color R,G,B
                              Feature color in the scoped reference
  --actual-feature-color R,G,B
                              Feature color in the scoped capture
  --feature-color-tolerance N Maximum per-channel feature-color delta (default: 24)
  --minimum-feature-pixels N  Drop connected components smaller than N (default: 4)
  --geometry-tolerance N      Maximum feature-bound delta in pixels (default: 1)
  --minimum-feature-iou RATE  Required binary silhouette overlap, 0...1 (default: 0.8)
  --exact-feature-match       Require zero bound delta and feature IoU >95%
  --channel-tolerance N       Maximum channel delta for a passing pixel (default: 8)
  --minimum-pass-rate RATE    Required compared-pixel pass rate, 0...1 (default: 0.99)
  --resize-actual             Resize scoped actual image to scoped reference dimensions
EOF
}

reference_path=''
output_dir=''
device_selector=''
wait_seconds='0.5'
compare_args=()
compare_arg_count=0

while [ "$#" -gt 0 ]; do
  case "$1" in
    --reference)
      [ "$#" -ge 2 ] || { echo '--reference requires a value' >&2; exit 2; }
      reference_path="$2"
      shift 2
      ;;
    --output-dir)
      [ "$#" -ge 2 ] || { echo '--output-dir requires a value' >&2; exit 2; }
      output_dir="$2"
      shift 2
      ;;
    --device)
      [ "$#" -ge 2 ] || { echo '--device requires a value' >&2; exit 2; }
      device_selector="$2"
      shift 2
      ;;
    --wait)
      [ "$#" -ge 2 ] || { echo '--wait requires a value' >&2; exit 2; }
      wait_seconds="$2"
      shift 2
      ;;
    --reference-crop|--actual-crop|--ignore|--mask|--acceptance|--reference-feature-color|--actual-feature-color|--feature-color-tolerance|--minimum-feature-pixels|--geometry-tolerance|--minimum-feature-iou|--channel-tolerance|--minimum-pass-rate)
      [ "$#" -ge 2 ] || { echo "$1 requires a value" >&2; exit 2; }
      compare_args+=("$1" "$2")
      compare_arg_count=$((compare_arg_count + 2))
      shift 2
      ;;
    --resize-actual|--exact-feature-match)
      compare_args+=("$1")
      compare_arg_count=$((compare_arg_count + 1))
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

[ -n "$reference_path" ] || { echo '--reference is required' >&2; usage >&2; exit 2; }
[ -n "$output_dir" ] || { echo '--output-dir is required' >&2; usage >&2; exit 2; }

mkdir -p "$output_dir"
actual_path="$output_dir/simulator.png"
capture_args=(--output "$actual_path" --wait "$wait_seconds")
if [ -n "$device_selector" ]; then
  capture_args+=(--device "$device_selector")
fi

"$script_dir/capture_simulator.sh" "${capture_args[@]}"
if [ "$compare_arg_count" -eq 0 ]; then
  exec "$script_dir/compare_ui.swift" \
    --reference "$reference_path" \
    --actual "$actual_path" \
    --output-dir "$output_dir"
fi

exec "$script_dir/compare_ui.swift" \
  --reference "$reference_path" \
  --actual "$actual_path" \
  --output-dir "$output_dir" \
  "${compare_args[@]}"
