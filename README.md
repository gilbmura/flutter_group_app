# ALU Intercampus Connect

A mobile-first student engagement & collaboration platform for the African
Leadership University (ALU) ecosystem, built with **Flutter**.

> Built for: *Formative Assignment 1 — Mobile App Design & Prototype*.

---

## What makes this ALU-specific (the four standout decisions)

1. **Cross-campus by default.** Kigali ⟷ Mauritius is a first-class concept.
   Posts can be marked *Hybrid*, which lets a student on one campus RSVP to an
   event hosted on the other. The home feed has a Kigali / Mauritius / All
   toggle, and the event detail page shows a "join remotely" nudge to students
   on the other campus.
2. **Mission-aligned discovery.** Students tag the Grand Challenges / missions
   they care about. The feed has a "✨ For my mission" filter that surfaces only
   posts linked to those missions.
3. **Role-gated posting.** Organizers / club leaders can publish *Events* and
   *Opportunities*; students can publish *Announcements*. The gate is enforced
   in the data model (`AppUser.canPostOpportunities`) **and** in the Create Post
   UI (locked tabs + validation).
4. **Leadership footprint profile.** The profile leads with contribution
   (events organized, attending, communities led) instead of vanity follower
   counts — reflecting ALU's leadership-first culture.

## Required features covered
- Authentication / onboarding (mock auth, **persisted** with SharedPreferences)
- Dynamic feed of events / opportunities / announcements with filters
- RSVP / Interested management (**persisted**, survives app restart)
- Lightweight group chat (send messages, live updates)
- Profile / identity with role + campus + missions
- Bottom-nav navigation with preserved per-tab state (IndexedStack)

## Tech & architecture
- **State management:** `provider` (4 ChangeNotifiers: Auth, Feed, RSVP, Chat)
- **Persistence:** `shared_preferences` (auth session + RSVPs)
- **Other:** `uuid` (stable IDs for user posts), `intl` (date formatting)
- **No backend required** — seeded from `lib/data/mock_data.dart`.

```
lib/
  main.dart            app.dart            # entry + provider wiring + AuthGate
  theme/               # design tokens (colors, radius, ThemeData)
  models/              # campus, app_user, post, community, chat
  data/                # mock_data.dart (seed)
  providers/           # auth, feed, rsvp, chat (state + persistence)
  widgets/             # reusable: card, buttons, chips, headers, empty state
  screens/             # onboarding, shell, home, detail, create, rsvps,
                       # explore, communities, chats, profile
```

---

## How to run it (Windows, Android emulator or device)

You need the Flutter SDK installed (`flutter doctor` should pass).

**Option A — drop into a fresh project (recommended):**
```bash
flutter create alu_connect          # creates the platform folders (android/ios)
# then copy this repo's `lib/` folder and `pubspec.yaml` into that project,
# overwriting the generated ones.
cd alu_connect
flutter pub get
flutter run                         # with an emulator running or device plugged in
```

**Option B — if you already have a project**, just replace `lib/` and
`pubspec.yaml`, then `flutter pub get` and `flutter run`.

> Note: this project ships the Dart source (`lib/` + `pubspec.yaml`). The
> generated `android/`, `ios/`, etc. folders are created by `flutter create`
> on your machine, so the app builds for your exact SDK versions.

---

## AI-usage disclosure (fill this in before you submit)

The assignment requires you to disclose where and how AI was used, and every
team member must be able to explain the code live. Use this as a starting point
and edit it to match what your team actually did:

> *AI tools (Claude) were used during this project for: brainstorming the
> cross-campus / mission-matching concept, scaffolding the initial Flutter
> project structure and Provider setup, and debugging import/compilation
> issues. All architecture decisions were reviewed by the team, the code was
> read and modified by [names], and every member can explain the state
> management, persistence, and role-gating logic. AI was **not** used to
> generate the report's analysis or our design rationale, which are our own.*

**Before the demo, make sure each member can explain at least:**
- How `provider` + `notifyListeners()` updates the UI
- How `SharedPreferences` persists the session and RSVPs
- Why the feed shows hybrid posts from the other campus (the rule in
  `FeedProvider.posts`)
- How the role gate works (`AppUser.canPostOpportunities` + Create Post)
