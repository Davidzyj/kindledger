#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT="$ROOT_DIR/KindLedger.xcodeproj"
SCHEME="KindLedger"
BUNDLE_ID="com.zhouyajie.kindledger"
DEVICE_NAME="KindLedger 6.5 Screenshot"
DEVICE_TYPE="com.apple.CoreSimulator.SimDeviceType.iPhone-11-Pro-Max"
RUNTIME="com.apple.CoreSimulator.SimRuntime.iOS-18-6"
DERIVED_DATA="$ROOT_DIR/tmp/DerivedDataScreenshots"
APP_PATH="$DERIVED_DATA/Build/Products/Debug-iphonesimulator/KindLedger.app"
LOG_DIR="$ROOT_DIR/tmp/screenshot-logs"

mkdir -p "$LOG_DIR" "$ROOT_DIR/store-assets/screenshots/en" "$ROOT_DIR/store-assets/screenshots/zh-Hans"

log() {
  printf '[screenshots] %s\n' "$*"
}

if ! xcrun simctl list runtimes | grep -q "$RUNTIME"; then
  RUNTIME="$(xcrun simctl list runtimes | awk -F '[()]' '/iOS/ && /Available/ {print $2; exit}')"
fi

DEVICE_ID="$(xcrun simctl list devices available | awk -v name="$DEVICE_NAME" -F '[()]' '$0 ~ name {print $2; exit}')"
if [[ -z "${DEVICE_ID:-}" ]]; then
  DEVICE_ID="$(xcrun simctl create "$DEVICE_NAME" "$DEVICE_TYPE" "$RUNTIME")"
fi

log "Building app"
xcodebuild \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -destination "id=$DEVICE_ID" \
  -derivedDataPath "$DERIVED_DATA" \
  build CODE_SIGNING_ALLOWED=NO > "$LOG_DIR/build.log"

log "Resetting simulator $DEVICE_ID"
xcrun simctl shutdown "$DEVICE_ID" >/dev/null 2>&1 || true
xcrun simctl erase "$DEVICE_ID" >/dev/null
xcrun simctl boot "$DEVICE_ID" >/dev/null 2>&1 || true
timeout 45 xcrun simctl bootstatus "$DEVICE_ID" -b >/dev/null 2>&1 || true
log "Installing app"
timeout 90 xcrun simctl install "$DEVICE_ID" "$APP_PATH"

capture() {
  local lang="$1"
  local locale="$2"
  local outdir="$ROOT_DIR/store-assets/screenshots/$lang"
  local screens=(home add detail people settings)

  rm -f "$outdir"/*.png
  for screen in "${screens[@]}"; do
    log "Capturing $lang/$screen"
    xcrun simctl terminate "$DEVICE_ID" "$BUNDLE_ID" >/dev/null 2>&1 || true
    xcrun simctl status_bar "$DEVICE_ID" override --time "9:41" --batteryState charged --batteryLevel 100 --wifiBars 3 --cellularBars 4
    (
      xcrun simctl launch "$DEVICE_ID" "$BUNDLE_ID" \
        -kindledgerLocale "$locale" \
        -kindledgerScreenshot "$screen" > "$LOG_DIR/launch-$lang-$screen.log" 2>&1
    ) &
    local launch_pid=$!
    for _ in {1..80}; do
      if ! kill -0 "$launch_pid" >/dev/null 2>&1; then
        break
      fi
      sleep 0.1
    done
    if kill -0 "$launch_pid" >/dev/null 2>&1; then
      kill "$launch_pid" >/dev/null 2>&1 || true
      wait "$launch_pid" >/dev/null 2>&1 || true
      sleep 0.5
    else
      wait "$launch_pid" >/dev/null 2>&1 || true
    fi
    sleep 4.5
    xcrun simctl status_bar "$DEVICE_ID" override --time "9:41" --batteryState charged --batteryLevel 100 --wifiBars 3 --cellularBars 4
    sleep 0.3
    xcrun simctl io "$DEVICE_ID" screenshot "$outdir/${screen}.png" >/dev/null
  done
}

capture "en" "en"
capture "zh-Hans" "zh-Hans"

xcrun simctl status_bar "$DEVICE_ID" clear >/dev/null 2>&1 || true

{
  echo "Generated screenshots:"
  find "$ROOT_DIR/store-assets/screenshots" -name '*.png' -maxdepth 3 -print | sort | while read -r file; do
    dims="$(sips -g pixelWidth -g pixelHeight "$file" 2>/dev/null | awk '/pixelWidth|pixelHeight/ {print $2}' | paste -sd x -)"
    echo "$dims  $file"
  done
} | tee "$LOG_DIR/summary.txt"
