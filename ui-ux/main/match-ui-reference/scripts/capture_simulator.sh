#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: capture_simulator.sh --output PATH [--device NAME_OR_UDID] [--wait SECONDS]

Capture the visible screen from one booted iOS Simulator. When --device is
omitted, exactly one iPhone simulator must be booted.
EOF
}

device_selector=''
output_path=''
wait_seconds='0.5'

while [ "$#" -gt 0 ]; do
  case "$1" in
    --device)
      [ "$#" -ge 2 ] || { echo '--device requires a value' >&2; exit 2; }
      device_selector="$2"
      shift 2
      ;;
    --output)
      [ "$#" -ge 2 ] || { echo '--output requires a value' >&2; exit 2; }
      output_path="$2"
      shift 2
      ;;
    --wait)
      [ "$#" -ge 2 ] || { echo '--wait requires a value' >&2; exit 2; }
      wait_seconds="$2"
      shift 2
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

[ -n "$output_path" ] || { echo '--output is required' >&2; usage >&2; exit 2; }
if ! [[ "$wait_seconds" =~ ^([0-9]+([.][0-9]*)?|[.][0-9]+)$ ]]; then
  echo '--wait must be a non-negative number' >&2
  exit 2
fi

booted_devices() {
  xcrun simctl list devices booted \
    | sed -nE 's/^[[:space:]]+(.+) \(([0-9A-Fa-f-]{36})\) \(Booted\)[[:space:]]*$/\1\t\2/p' \
    | awk -F '\t' 'tolower($1) ~ /iphone/ { print }'
}

if [ -n "$device_selector" ]; then
  matches="$(booted_devices | awk -F '\t' -v selector="$device_selector" '$1 == selector || $2 == selector')"
else
  matches="$(booted_devices)"
fi

match_count="$(printf '%s\n' "$matches" | sed '/^$/d' | wc -l | tr -d ' ')"
if [ "$match_count" -eq 0 ]; then
  if [ -n "$device_selector" ]; then
    echo "No booted iPhone simulator matches: $device_selector" >&2
  else
    echo 'No booted iPhone simulator found.' >&2
  fi
  xcrun simctl list devices booted >&2
  exit 1
fi

if [ "$match_count" -ne 1 ]; then
  echo 'More than one booted iPhone matches. Pass --device with an exact name or UDID:' >&2
  printf '%s\n' "$matches" >&2
  exit 1
fi

device_name="$(printf '%s\n' "$matches" | awk -F '\t' 'NR == 1 { print $1 }')"
device_udid="$(printf '%s\n' "$matches" | awk -F '\t' 'NR == 1 { print $2 }')"

mkdir -p "$(dirname "$output_path")"
if [ "$wait_seconds" != '0' ] && [ "$wait_seconds" != '0.0' ]; then
  sleep "$wait_seconds"
fi

xcrun simctl io "$device_udid" screenshot "$output_path"
printf 'Captured %s (%s) -> %s\n' "$device_name" "$device_udid" "$output_path"
