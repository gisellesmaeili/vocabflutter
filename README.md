# Glossify

Glossify is a Flutter app for deep, IELTS-focused English vocabulary learning. Instead of flashcard-only rote memorization, it teaches words through themed daily lessons, rich growing flashcards, spaced repetition, and contextual practice — so learners use vocabulary, not just recognize it.

## Why Glossify

Most vocabulary apps stop at "word → definition." Glossify goes further:

- **Themed daily lessons** — 5–15 words per lesson, grouped by IELTS category, taught through a full learn-practice-reflect flow (not just a quiz)
- **Rich flashcards** — each card grows over time with examples, collocations, word family, synonyms/antonyms, memory hooks, and personal notes
- **Spaced repetition** — review intervals (1 → 3 → 7 → 14 → 30 days) weighted by how well you actually know each word
- **IELTS-specific structure** — every word is tagged by category (Environment, Technology, Health, etc.) and by task relevance (Writing Task 2, Speaking Part 3, etc.)
- **100% offline-capable** — all content is pre-authored and bundled with the app; no runtime AI calls, no dependency on a live connection to learn

## Tech Stack

| Layer | Choice |
|---|---|
| Framework | Flutter (Dart) |
| State management | Riverpod (manual `Notifier`/`NotifierProvider`, no codegen) |
| Routing | go_router (`StatefulShellRoute.indexedStack` for tab navigation) |
| Local storage | Hive (offline-first, all user data) |
| Cloud (optional) | Firebase — Auth + Firestore (Storage intentionally not used) |
| Notifications | flutter_local_notifications |
| Architecture | Clean Architecture, feature-first (`domain` / `data` / `presentation` per feature) |

## Platforms

iOS, Android, and macOS. (Web was evaluated and dropped for now.)

## Project Structure

```
lib/
├── core/               # theme, constants, router, shared widgets/utils
├── features/
│   ├── onboarding/     # welcome, native language picker, placement test
│   ├── words/          # word content model + repository
│   ├── lessons/         # daily lesson flow (intro → ... → summary)
│   ├── flashcards/      # flashcard system
│   ├── srs/              # spaced repetition engine
│   ├── notifications/
│   ├── statistics/
│   └── settings/
└── shell/               # persistent bottom-nav app shell

assets/
├── content/
│   ├── words/           # one JSON file per IELTS category
│   └── lessons/         # one JSON file per lesson
├── fonts/                # Poppins & Inter, bundled locally
└── flags/                # circular flag icons (native language picker)
```

Every feature follows the same internal split:

- **`domain/`** — plain Dart entities and business logic, no Flutter or storage dependencies
- **`data/`** — repositories that load/parse JSON content or read/write Hive
- **`presentation/`** — screens, widgets, and Riverpod providers

## Core Architectural Decisions

- **Content vs. user data are strictly separated.** Word and lesson content is read-only JSON bundled as assets. Per-user data (SRS schedule, familiarity ratings, personal notes) lives separately in Hive, linked back to content by stable string IDs. This means content updates never risk corrupting a user's progress.
- **Offline-first, no exceptions.** Every dependency that could require network access — including fonts — has been replaced with a bundled local alternative. The app must be fully usable with no internet connection.
- **No paid services.** Every third-party dependency is free with no billing requirement (Firebase Storage was removed from the architecture entirely for this reason — see below).
- **All content is hand-authored.** No generative AI calls at runtime. Words, passages, activities, and other content are written externally and shipped as JSON.

## Content Authoring Format

Content is organized as plain JSON, one file per unit:

- `assets/content/words/<category>.json` — one file per IELTS category, containing an array of word entries (definition, examples, collocations, word family, synonyms/antonyms, memory hook, tags)
- `assets/content/lessons/<lesson_id>.json` — one file per lesson, referencing word IDs from the files above, plus a reading passage, comprehension questions, practice activities, and agree/disagree statements

This format is designed to be authored entirely outside the codebase (e.g. with free AI tools) and dropped straight into the asset folders — adding new content never requires touching app code beyond registering the new file path in the relevant repository.

## Getting Started

### Prerequisites

- Flutter 3.44.4+
- Xcode (for iOS/macOS builds)
- Android Studio (for Android builds)
- A Firebase project (for Auth/Firestore — optional for local-only development)

### Setup

```bash
flutter pub get
flutterfire configure   # generates lib/firebase_options.dart
flutter run -d macos    # or -d ios / -d android
```

### Notes for contributors

- This project deliberately avoids `google_fonts`-style runtime font fetching — fonts are bundled locally under `assets/fonts/`. Any new font must be added the same way.
- Firebase Storage is not used and should not be reintroduced without discussion — it requires a paid Blaze plan.
- New word/lesson content should follow the existing JSON schema exactly; see existing files under `assets/content/` for the canonical shape.

## Roadmap

- [x] Sprint 0 — Project foundation, design system, Firebase setup
- [x] Sprint 1 — Onboarding + placement test
- [x] Sprint 2 — Word content model + loading system
- [x] Sprint 3 — Daily lesson system (full flow: intro → rating → reading → comprehension → activities → matching → word family → collocations → agree/disagree → post-rating → summary)
- [ ] Sprint 4 — Persistent, growing flashcard system
- [ ] Sprint 5 — Spaced repetition engine
- [ ] Sprint 6 — Customizable notifications
- [ ] Sprint 7 — Statistics + gamification
- [ ] Sprint 8 — Firebase cloud sync
- [ ] Sprint 9 — UI polish + animations
- [ ] Sprint 10 — Testing + launch prep

## License

This project is licensed under the MIT License — see [LICENSE](LICENSE) for details.
