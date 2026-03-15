# PiqueMHL

<img src="Pique/Assets.xcassets/AppIcon.appiconset/icon_128x128@2x.png" alt="Pique icon" width="128" height="128" />

### This project is now superceded by my MHL Media Tools, see https://github.com/macvfx/MHL/

A experimental macOS Quick Look extension for `.mhl` Media Hash List previews.

Select an `.mhl` file in Finder, press Space, and get a readable verification preview with creator metadata, source metadata, file counts, sizes, hashes, and the raw XML source.

## Supported File Types

| Format | Extensions |
|---|---|
| Media Hash List | `.mhl` |

Media Hash List files are rendered as verification manifests with creator metadata, source metadata, file counts, total size, per-file hashes, and the raw XML source.

This project is aimed at XML-based Media Hash List files used in camera card verification and offload workflows.

## Requirements

macOS 15.6 or later.

## Installation

You can build from source with Xcode:

```sh
xcodebuild -project Pique.xcodeproj -scheme Pique -config Release
```

For local signing, copy `Config/Signing.local.example.xcconfig` to `Config/Signing.local.xcconfig`, set your team and signing identity there, and keep that local file out of Git.

Or use the pkg installer available in [Releases](../../releases).

## Local Development

1. Copy `Config/Signing.local.example.xcconfig` to `Config/Signing.local.xcconfig`.
2. Set your own `DEVELOPMENT_TEAM` and `CODE_SIGN_IDENTITY` in that local file.
3. Run:

```sh
./install_local.zsh
```

4. Launch `PiqueMHL.app` once if needed.
5. Enable **Pique MHL** in **System Settings > Login Items & Extensions > Quick Look Extensions**.
6. Select an `.mhl` file in Finder and press Space to test the preview.

## Enabling the Extension

On macOS 15.6 and later, Quick Look extensions may need to be explicitly allowed. When you first launch PiqueMHL, you may see a notification:

<img src="images/quicklook-extension-enable.png" alt="Quick Look Previewer Extension Added notification" width="350" />

Go to **System Settings > Login Items & Extensions > Quick Look Extensions** and enable **Pique MHL**.

## Troubleshooting

If `.mhl` files stop previewing in Quick Look after building in Xcode, the usual cause is a stale extension registration from Xcode `DerivedData` or `ArchiveIntermediates`.

Check the registered Quick Look entries:

```sh
pluginkit -m -A -D -v -p com.apple.quicklook.preview | rg piquemhl
```

The active installed extension should point to:

```text
/Applications/PiqueMHL.app/Contents/PlugIns/PiqueMHLPreview.appex
```

If you see additional `PiqueMHL` entries from `~/Library/Developer/Xcode/DerivedData/...`, remove the stale registrations and re-register the installed app:

```sh
pluginkit -r /Applications/PiqueMHL.app/Contents/PlugIns/PiqueMHLPreview.appex
pluginkit -a /Applications/PiqueMHL.app/Contents/PlugIns/PiqueMHLPreview.appex
pluginkit -e use -i io.macvfx.piquemhl.preview
killall Finder
```

Or use:

```sh
./refresh_quicklook.zsh
```

If needed, remove stale Xcode build products from `~/Library/Developer/Xcode/DerivedData/` and repeat the commands above.

Recommended workflow:

1. Build/sign locally.
2. Copy the finished app to `/Applications/PiqueMHL.app`.
3. Re-register the installed extension with `pluginkit`.
4. Avoid relying on `DerivedData` build products as your active installed copy.

## License

Copyright 2026 Declarative IT GmbH

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

> <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
