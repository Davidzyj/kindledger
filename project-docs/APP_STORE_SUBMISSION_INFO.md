# App Store Submission Information

This document is the copy-ready submission sheet for KindLedger / 善意簿.

## Basic App Record

| Field | Value |
|---|---|
| Platform | iOS |
| App name, English | KindLedger |
| App name, Simplified Chinese | 善意簿 |
| Primary language suggestion | English (U.S.) |
| Bundle ID | `com.zhouyajie.kindledger` |
| SKU | `kindledger-ios-100` |
| User access | Full access, no login required |

## Version Information

| Field | Value |
|---|---|
| Version | `1.0.0` |
| Copyright | `© 2026 Zhou Yajie` |
| Category, primary | Lifestyle |
| Category, secondary | Productivity |
| Price | Free |
| Distribution | All countries/regions, unless the account owner wants to limit availability |

## English Metadata

| Field | Value |
|---|---|
| Name | KindLedger |
| Subtitle | Remember everyday kindness |
| Promotional Text | Keep a private, offline record of the people who helped you and the kindness you do not want to forget. |
| Description | KindLedger is a quiet, private place to remember the people who helped you. Record who showed up for you, what happened, where it happened, and whether you have thanked them yet.\n\nThe app is designed for personal reflection, not social networking. Your records stay on your iPhone. There is no account, no cloud sync, no analytics, and no automatic network request in version 1.0.0.\n\nFeatures:\n- Record moments of help, care, encouragement, teaching, protection, opportunity, and companionship.\n- Browse recent kindness records.\n- View people summaries and unthanked moments.\n- Search by person, place, tags, and notes.\n- Mark a record as thanked.\n- Use the app in English or Simplified Chinese. |
| Keywords | gratitude,journal,kindness,people,thanks,memory,offline,private,reflection,notes |
| Support URL | `https://davidzyj.github.io/kindledger/en/support.html` |
| Marketing URL | `https://davidzyj.github.io/kindledger/` |
| Privacy Policy URL | `https://davidzyj.github.io/kindledger/en/privacy.html` |

## Simplified Chinese Metadata

| Field | Value |
|---|---|
| Name | 善意簿 |
| Subtitle | 记住别人给过你的好 |
| Promotional Text | 把别人曾经给予你的帮助、陪伴、鼓励和温暖，安静地记录在本机。 |
| Description | 善意簿是一个私人的善意记忆处。你可以记录谁帮助过你、发生了什么、在哪里发生，以及你是否已经表达感谢。\n\n它不是社交软件，也不是通讯录，而是一个帮助你记住别人善意的本地记录工具。1.0.0 版本没有账号、没有云同步、没有分析 SDK，也不会自动发起网络请求。\n\n主要功能：\n- 记录帮助、关心、鼓励、指点、保护、机会和陪伴。\n- 查看最近的善意记录。\n- 按人物归档，查看待感谢记录。\n- 按人物、地点、标签和备注搜索。\n- 标记是否已经感谢对方。\n- 支持简体中文和英文。 |
| Keywords | 感恩,日记,善意,感谢,人物,记忆,本地,隐私,记录,反思 |
| Support URL | `https://davidzyj.github.io/kindledger/zh/support.html` |
| Marketing URL | `https://davidzyj.github.io/kindledger/` |
| Privacy Policy URL | `https://davidzyj.github.io/kindledger/zh/privacy.html` |

## Screenshots

Upload only the 6.5-inch iPhone screenshots requested for this first submission.

English:

- `store-assets/screenshots/en/home.png`
- `store-assets/screenshots/en/add.png`
- `store-assets/screenshots/en/detail.png`
- `store-assets/screenshots/en/people.png`
- `store-assets/screenshots/en/settings.png`

Simplified Chinese:

- `store-assets/screenshots/zh-Hans/home.png`
- `store-assets/screenshots/zh-Hans/add.png`
- `store-assets/screenshots/zh-Hans/detail.png`
- `store-assets/screenshots/zh-Hans/people.png`
- `store-assets/screenshots/zh-Hans/settings.png`

All files are 1242 x 2688 PNG.

## App Icon

| Field | Value |
|---|---|
| App Store icon | `KindLedger/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png` |
| Size | 1024 x 1024 |
| Alpha channel | No alpha |

## App Privacy

Recommended answers for version 1.0.0:

| Question | Answer |
|---|---|
| Does this app collect data? | No, we do not collect data from this app. |
| Tracking | No |
| User Privacy Choices URL | Leave blank |

Reasoning:

- Records are stored locally on the user's device.
- No account system.
- No analytics SDK.
- No advertising SDK.
- No third-party tracking.
- No cloud sync.
- Privacy/support links open only after the user taps them.

## Age Rating

Recommended answers:

| Item | Answer |
|---|---|
| Cartoon or Fantasy Violence | None |
| Realistic Violence | None |
| Sexual Content or Nudity | None |
| Profanity or Crude Humor | None |
| Alcohol, Tobacco, Drug Use or References | None |
| Medical or Treatment Information | None |
| Horror/Fear Themes | None |
| Gambling | None |
| Contests | No |
| Unrestricted Web Access | No |
| User-Generated Content | No public user-generated content |

Expected rating: 4+.

## App Review Information

| Field | Value |
|---|---|
| Sign-in required | No |
| Contact first name | Yajie |
| Contact last name | Zhou |
| Contact phone | Account owner should fill real phone number |
| Contact email | `jay212315@gmail.com` |

Review notes:

```text
KindLedger is a local-only personal reflection app. It does not require login and does not collect user data. Users can create, edit, delete, search, and mark local kindness records. All records are stored on the user's device. The privacy policy, support page, and email links open only when the user taps them.
```

Chinese review notes, if needed:

```text
善意簿是一款本地优先的私人记录应用，不需要登录，也不收集用户数据。用户可以在本机创建、编辑、删除、搜索善意记录，并标记是否已经感谢对方。所有记录保存在用户设备本地。隐私政策、支持页面和邮件链接只会在用户主动点击时打开。
```

## Build Upload

Use Xcode to set the real Apple Developer Team, then archive and upload.

Local verification command:

```bash
xcodebuild -project KindLedger.xcodeproj -scheme KindLedger -destination 'generic/platform=iOS Simulator' build CODE_SIGNING_ALLOWED=NO
```

## Remaining Manual Fields

These depend on the Apple Developer account owner and cannot be filled by code:

- Apple Developer Team.
- App Store Connect app record ownership details.
- Real contact phone number.
- Export compliance questionnaire confirmation.
- Content rights confirmation.
- Pricing and availability final country/region choices.
- Any business/tax/banking agreements required by the account.
