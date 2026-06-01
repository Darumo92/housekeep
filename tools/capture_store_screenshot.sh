#!/usr/bin/env bash
# Capture a Play Store screenshot from the connected Android device/emulator.
#
# Usage: tools/capture_store_screenshot.sh <output-dir> <name>
set -euo pipefail

ADB="${ANDROID_HOME:-/home/darumo/Android/Sdk}/platform-tools/adb"
OUT_DIR="${1:?usage: capture_store_screenshot.sh <output-dir> <name>}"
NAME="${2:?usage: capture_store_screenshot.sh <output-dir> <name>}"

mkdir -p "$OUT_DIR"

demo() { "$ADB" shell am broadcast -a com.android.systemui.demo -e command "$@" >/dev/null; }

"$ADB" shell settings put global sysui_demo_allowed 1 >/dev/null
demo enter
demo clock -e hhmm 0941
demo battery -e level 100 -e plugged false
demo network -e wifi show -e level 4
demo network -e mobile show -e level 4 -e datatype none
demo notifications -e visible false

"$ADB" exec-out screencap -p > "$OUT_DIR/${NAME}.png"
echo "saved $OUT_DIR/${NAME}.png"
