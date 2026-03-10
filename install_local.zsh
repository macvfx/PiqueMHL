#!/bin/zsh
set -euo pipefail

TOOLSDIR=$(cd "$(dirname "$0")" && pwd)
DERIVED_DATA="${DERIVED_DATA:-/tmp/PiqueDerivedDataLocal}"
CONFIGURATION="${CONFIGURATION:-Debug}"
APP_SOURCE="$DERIVED_DATA/Build/Products/$CONFIGURATION/PiqueMHL.app"
APP_DEST="$HOME/Applications/PiqueMHL.app"
LOCAL_SIGNING_XCCONFIG="$TOOLSDIR/Config/Signing.local.xcconfig"
XCODE_ARGS=()
SIGNING_ARGS=(CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO)

if [[ -f "$LOCAL_SIGNING_XCCONFIG" ]]; then
  XCODE_ARGS+=(-xcconfig "$LOCAL_SIGNING_XCCONFIG")
  SIGNING_ARGS=()
fi

if [[ -f "$LOCAL_SIGNING_XCCONFIG" ]]; then
  echo "Building Pique ($CONFIGURATION) with local signing settings..."
else
  echo "Building Pique ($CONFIGURATION) with local unsigned settings..."
fi
xcodebuild \
  -project "$TOOLSDIR/Pique.xcodeproj" \
  -scheme "Pique" \
  -configuration "$CONFIGURATION" \
  -derivedDataPath "$DERIVED_DATA" \
  "${XCODE_ARGS[@]}" \
  "${SIGNING_ARGS[@]}" \
  build

if [[ ! -d "$APP_SOURCE" ]]; then
  echo "Built app not found at $APP_SOURCE" >&2
  exit 1
fi

mkdir -p "$HOME/Applications"
rm -rf "$APP_DEST"
cp -R "$APP_SOURCE" "$APP_DEST"

echo "Registering Quick Look extension..."
/usr/bin/pluginkit -a "$APP_DEST/Contents/PlugIns/PiqueMHLPreview.appex" || true

echo
echo "Installed: $APP_DEST"
echo "Next steps:"
echo "1. Launch PiqueMHL once."
echo "2. Enable the Quick Look extension in System Settings if macOS prompts."
echo "3. Select an .mhl file in Finder and press Space to test."
