#!/bin/zsh
set -euo pipefail

APP_PATH="${APP_PATH:-/Applications/PiqueMHL.app}"
PLUGIN_PATH="$APP_PATH/Contents/PlugIns/PiqueMHLPreview.appex"
BUNDLE_ID="${BUNDLE_ID:-io.macvfx.piquemhl.preview}"

if [[ ! -d "$APP_PATH" ]]; then
  echo "App not found: $APP_PATH" >&2
  exit 1
fi

if [[ ! -d "$PLUGIN_PATH" ]]; then
  echo "Quick Look plugin not found: $PLUGIN_PATH" >&2
  exit 1
fi

echo "Re-registering Quick Look plugin..."
/usr/bin/pluginkit -r "$PLUGIN_PATH" || true
/usr/bin/pluginkit -a "$PLUGIN_PATH"
/usr/bin/pluginkit -e use -i "$BUNDLE_ID"

echo "Restarting Finder..."
/usr/bin/killall Finder || true

echo
echo "Active plugin:"
/usr/bin/pluginkit -m -A -D -v -p com.apple.quicklook.preview | /usr/bin/grep "$BUNDLE_ID" || true
