# KindLedger Product Notes

## Concept

KindLedger is a private gratitude memory app. It helps users record the people who helped them, what happened, how it changed the day, and whether they want to thank that person later.

It is intentionally not a social network, CRM, or contacts manager. The emotional promise is simple: when life gets noisy, the user can reopen proof that they have been helped, seen, and carried by others.

## Positioning

- Category: Lifestyle / Productivity
- First version: local-only personal archive
- Tone: warm, reflective, calm, not clinical
- Core audience:
  - people who want to remember kindness
  - people who keep gratitude journals but want records connected to people
  - people who want to become better at acknowledging help

## Names

- English app name: KindLedger
- Chinese app name: 善意簿
- Bundle identifier: `com.zhouyajie.kindledger`
- Version: `1.0.0`

## First Version Scope

Must have:

- Add a kindness record.
- Store records locally on device.
- Browse all records.
- View and edit details.
- Search by person, title, place, notes, and tags.
- See people summary: total records per person and unthanked count.
- Mark whether the user has thanked the person.
- Open privacy policy and support pages from Settings.
- English and Simplified Chinese UI.
- `CFBundleDisplayName` localized as `KindLedger` and `善意簿`.

Should have:

- Mood / impact selector.
- Kindness category selector.
- Local sample records for first launch.
- Simple App Store screenshot-friendly UI.

Out of scope for v1:

- Account system.
- Cloud sync.
- Push notifications.
- Contacts integration.
- AI suggestions.
- Analytics.
- Any automatic network request.

## Data Model

`KindnessRecord`

- `id`: UUID
- `personName`: String
- `title`: String
- `story`: String
- `date`: Date
- `place`: String
- `category`: enum
- `impact`: enum
- `tags`: [String]
- `isThanked`: Bool
- `thankNote`: String
- `createdAt`: Date
- `updatedAt`: Date

Data is persisted as JSON in the app documents directory.

## Privacy

The app stores personal notes locally on the user's device. No account, analytics, cloud service, or background upload is included in v1.

External web pages:

- Privacy policy
- Support

The app opens those only when the user taps a link.
