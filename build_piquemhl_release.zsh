#!/bin/zsh
set -euo pipefail

TOOLSDIR=$(cd "$(dirname "$0")" && pwd)
BUILDSDIR="$TOOLSDIR/build"
CONFIGURATION="${CONFIGURATION:-Release}"
SCHEME="${SCHEME:-Pique}"
LOCAL_SIGNING_XCCONFIG="$TOOLSDIR/Config/Signing.local.xcconfig"
XCODE_ARGS=()

if [[ -f "$LOCAL_SIGNING_XCCONFIG" ]]; then
  XCODE_ARGS+=(-xcconfig "$LOCAL_SIGNING_XCCONFIG")
fi

if [[ -z "${DEVELOPMENT_TEAM:-}" ]]; then
  echo "Set DEVELOPMENT_TEAM before running this script." >&2
  exit 1
fi

if [[ -z "${CODE_SIGN_IDENTITY:-}" ]]; then
  echo "Set CODE_SIGN_IDENTITY before running this script." >&2
  exit 1
fi

echo "Building PiqueMHL ($CONFIGURATION)..."
xcodebuild \
  -project "$TOOLSDIR/Pique.xcodeproj" \
  -scheme "$SCHEME" \
  -configuration "$CONFIGURATION" \
  -derivedDataPath "$BUILDSDIR/DerivedData" \
  "${XCODE_ARGS[@]}" \
  CODE_SIGN_STYLE=Automatic \
  DEVELOPMENT_TEAM="$DEVELOPMENT_TEAM" \
  CODE_SIGN_IDENTITY="$CODE_SIGN_IDENTITY" \
  build

echo
echo "Built app:"
echo "$BUILDSDIR/DerivedData/Build/Products/$CONFIGURATION/PiqueMHL.app"
echo
echo "Example:"
echo "DEVELOPMENT_TEAM=YOURTEAMID CODE_SIGN_IDENTITY=\"Developer ID Application\" ./build_piquemhl_release.zsh"
