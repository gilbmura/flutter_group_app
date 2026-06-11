# ALU Intercampus Connect — Technical Report

**Course:** Formative Assignment 1 — Mobile App Design & Prototype  
**Platform:** Flutter (Android / iOS)  
**Team:** *[Group name — fill in before submitting]*

---

## 1. Overview

ALU Intercampus Connect is a mobile-first platform that helps students across the African Leadership University's Kigali and Mauritius campuses discover events and opportunities, manage participation, coordinate in group chats, and present a leadership-focused identity. General-purpose social tools treat a university as a single location and optimise for passive consumption. ALU's reality is different: two campuses, a mission-driven curriculum, and a strong leadership culture [1]. This app is designed around those three facts.

**What we hope to achieve:** Give every ALU student one place to find campus-relevant opportunities, participate across campuses, and build a profile rooted in contribution rather than vanity metrics.

---

## 2. Unique, ALU-fit functionalities

**Cross-campus participation.** Campus is a first-class attribute on every post. Posts can be flagged *Hybrid*, allowing remote students on the other campus to RSVP. The home feed exposes a Kigali / Mauritius / All toggle, and the event detail screen shows a contextual nudge to students on the opposite campus.

**Mission-aligned discovery.** Students declare Grand Challenges / missions they care about during onboarding and can edit them on Profile. A "For my mission" filter surfaces only posts tagged with those missions, connecting engagement to ALU's mission-centred model [1].

**Role-gated publishing.** Organizers and club leaders publish events and opportunities; students publish announcements. The gate is enforced in the data model (`AppUser.canPostOpportunities`) and in the Create Post UI (locked tabs + validation).

**Leadership footprint.** The profile leads with live contribution metrics — posts organized, events attending, communities joined — rather than follower counts.

**Additional engagement features:** Explore search across titles, tags, authors, and missions; community join/leave with persistence; lightweight group chat with persisted messages; empty states on every list surface; and SnackBar feedback on key actions.

---

## 3. UI/UX redesign reasoning

The provided inspiration used a generic icon grid and search-first home. We restructured the home screen around the two questions an ALU student asks first — *which campus?* and *what serves my mission?* — by promoting the campus toggle and mission filter above the feed. We kept a deep-navy canvas with a single amber accent: amber is reserved for primary actions and the active navigation state so hierarchy stays clear. Cards use a coloured left rail and type badge so events, opportunities, and announcements are distinguishable at a glance [2]. A central amber "+" in the bottom bar makes posting the most discoverable action. Explore remains search-first for discovery, while Home is feed-first for daily engagement — a deliberate split, not a copy of the sample layout.

---

## 4. Navigation and state handling

Navigation uses a persistent bottom bar backed by an `IndexedStack`, which keeps each tab's scroll position and filter state alive when switching tabs. Detail, create, RSVP, communities, and chat screens are pushed as routes on top.

Application state is managed with `provider` [3] using five `ChangeNotifier` stores (authentication, feed, RSVPs, chat, communities) created once at the widget tree root. UI widgets subscribe with `context.watch` and trigger updates via provider methods.

Persistence uses `shared_preferences` [4] for: auth session, RSVP sets, user-created posts, chat messages, and community join state. An `AuthGate` loads all stores on launch and routes to onboarding or `AppShell`.

---

## 5. Implementation details

| Layer | Location | Responsibility |
|-------|----------|----------------|
| Models | `lib/models/` | `Post`, `AppUser`, `Campus`, `Community`, `Chat` |
| Seed data | `lib/data/mock_data.dart` | Relative dates, sample posts/chats/communities |
| Providers | `lib/providers/` | State + SharedPreferences persistence |
| Widgets | `lib/widgets/` | Reusable cards, chips, buttons, empty states |
| Screens | `lib/screens/` | Onboarding, shell, feed, explore, detail, create, RSVPs, chats, profile |

**RSVP logic:** Two mutually exclusive sets (`going` / `interested`) persisted together. **Feed logic:** Hybrid posts always visible when a campus filter is active. **Explore:** Reads `allPosts` so Home filters do not shrink search results.

---

## 6. Challenges and solutions

| Challenge | Solution |
|-----------|----------|
| Cross-campus visibility without a backend | Single rule in `FeedProvider`: hybrid posts bypass campus filter |
| RSVP state consistency | Mutually exclusive sets with shared persistence |
| User-created content lost on restart | JSON-serialize user posts to SharedPreferences |
| Demo reliability offline | Mock data + no network images |
| Explaining code live | Small providers, one concern each, documented in README |

---

## 7. AI usage disclosure

*[Each team member must edit this section before submitting.]*

AI tools were used for brainstorming ALU-specific features, scaffolding the Flutter/Provider structure, and debugging. All architecture decisions were reviewed by the team; every member can explain state management, persistence, and role-gating. The report analysis and design rationale are the team's own work.

---

## References

[1] African Leadership University, "Our Model," ALU. [Online]. Available: https://www.alueducation.com. [Accessed: Jun. 11, 2026].

[2] Flutter, "Flutter documentation," Google. [Online]. Available: https://docs.flutter.dev. [Accessed: Jun. 11, 2026].

[3] R. Rousselet, "provider package," pub.dev. [Online]. Available: https://pub.dev/packages/provider. [Accessed: Jun. 11, 2026].

[4] Flutter Community, "shared_preferences package," pub.dev. [Online]. Available: https://pub.dev/packages/shared_preferences. [Accessed: Jun. 11, 2026].
