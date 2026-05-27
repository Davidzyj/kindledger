# KindLedger

KindLedger is an iPhone-only, offline-first SwiftUI app for remembering the help, warmth, and generosity people have shown you.

## Product

- Chinese name: 善意簿
- English name: KindLedger
- Repository: https://github.com/Davidzyj/kindledger
- Website: https://davidzyj.github.io/kindledger/
- Bundle identifier: `com.zhouyajie.kindledger`
- Version: `1.0.0`
- Platform: iPhone only
- Network: no in-app network requests, except user-initiated links to support and privacy pages
- Support email: `jay212315@gmail.com`

## Repository Structure

- `KindLedger/` - iOS app source, assets, and localizations
- `docs/` - GitHub Pages privacy policy and support website
- `project-docs/` - product decisions, implementation notes, and progress logs
- `store-assets/` - App Store screenshot output folders
- `scripts/` - helper scripts for assets and screenshots

## Handoff

Start with:

1. `project-docs/PRODUCT.md`
2. `project-docs/PROGRESS.md`
3. `project-docs/APP_STORE.md`

All meaningful implementation decisions should be recorded in `project-docs/PROGRESS.md` before handing work to another agent.

## Build

```bash
xcodebuild -project KindLedger.xcodeproj -scheme KindLedger -destination 'generic/platform=iOS Simulator' build CODE_SIGNING_ALLOWED=NO
```

## Screenshots

```bash
scripts/capture_screenshots.sh
scripts/make_contact_sheet.sh
```

The screenshot script generates 6.5-inch iPhone screenshots at `store-assets/screenshots/en/` and `store-assets/screenshots/zh-Hans/`.
