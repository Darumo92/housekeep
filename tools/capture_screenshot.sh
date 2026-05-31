#!/usr/bin/env bash
# Capture a Play Store screenshot from the connected Android device/emulator
# with a clean demo status bar (09:41, full battery, full wifi, no clutter).
#
# Usage:  tools/capture_screenshot.sh <name> [lang]
#   name : output filename without extension, e.g. 01_home
#   lang : es | en  (default: en) — picks the output subfolder
#
# Navigate the app to the screen you want, then run this. See docs/SCREENSHOT_PLAN.md.
set -euo pipefail

ADB="${ANDROID_HOME:-/usr/local/share/android-commandlinetools}/platform-tools/adb"
NAME="${1:?usage: capture_screenshot.sh <name> [lang]}"
LANG_DIR="${2:-en}"
OUT="store/screenshots/android_phone/${LANG_DIR}"
mkdir -p "$OUT"

demo() { "$ADB" shell am broadcast -a com.android.systemui.demo -e command "$@" >/dev/null; }

"$ADB" shell settings put global sysui_demo_allowed 1 >/dev/null
demo enter
demo clock -e hhmm 0941
demo battery -e level 100 -e plugged false
demo network -e wifi show -e level 4
demo network -e mobile show -e level 4 -e datatype none
demo notifications -e visible false

"$ADB" exec-out screencap -p > "$OUT/${NAME}.png"
echo "saved $OUT/${NAME}.png ($(stat -f%z "$OUT/${NAME}.png" 2>/dev/null || stat -c%s "$OUT/${NAME}.png") bytes)"

# To restore the real status bar afterwards:
#   $ADB shell am broadcast -a com.android.systemui.demo -e command exit
