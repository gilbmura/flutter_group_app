# ALU Intercampus Connect — Technical Report (Draft)

*Replace the bracketed placeholders, trim to ~3 pages, and put it in your team's
own words before submitting. Verify every reference and add page numbers.*

---

## 1. Overview

ALU Intercampus Connect is a mobile-first platform that helps students across
the African Leadership University's Kigali and Mauritius campuses discover
events and opportunities, manage their participation, coordinate in group
chats, and present a leadership-focused identity. Existing general-purpose
social and campus tools treat a university as a single location and optimise for
passive consumption (likes, followers). ALU's reality is different: two
campuses, a mission-driven curriculum, and a strong leadership culture [1]. The
app is designed around those three facts.

## 2. Unique, ALU-fit functionalities

**Cross-campus participation.** Campus is a first-class attribute on every post.
Posts can be flagged *Hybrid*, which makes them joinable remotely from the other
campus. The feed exposes a Kigali / Mauritius / All toggle, and the event detail
screen shows a contextual prompt to students on the opposite campus. This
directly serves a two-campus institution that most campus apps cannot model.

**Mission-aligned discovery.** Students declare the Grand Challenges / missions
they care about during onboarding. A "For my mission" filter surfaces only posts
tagged with those missions, connecting engagement to ALU's mission-centred model
of education [1].

**Role-gated publishing.** The app answers the product question "who should be
allowed to post opportunities?" explicitly: organizers and club leaders publish
events and opportunities, while students publish announcements. This reduces
noise and misinformation while still giving every student a voice.

**Leadership footprint.** The profile leads with contribution metrics (events
organized, attending, communities led) rather than follower counts, reinforcing
intrinsic, leadership-oriented motivation rather than vanity metrics.

## 3. UI/UX redesign reasoning

The provided inspiration used a generic icon grid and a search-first home. We
restructured the home screen around the two questions an ALU student actually
asks first — *which campus?* and *what serves my mission?* — by promoting the
campus toggle and mission filter to the top of the feed. We kept a deep-navy
canvas with a single amber accent for a calm, focused hierarchy: amber is
reserved exclusively for primary actions and the active navigation state, so the
eye always knows where the next action is. Cards use a coloured left rail and a
type badge so events, opportunities, and announcements are distinguishable at a
glance, supporting recognition over recall [2]. A central amber "+" in the
bottom bar makes posting the most discoverable action.

## 4. Additional functionalities

Beyond the minimum brief, the app persists both the authenticated session and a
user's RSVPs locally, so state survives app restarts; provides search across
titles, tags, and authors on the Explore screen; supports joining/leaving
communities; and handles empty states everywhere a list can be empty (no
results, no RSVPs yet), which improves perceived robustness during the demo.

## 5. Navigation and state handling

Navigation uses a persistent bottom bar backed by an `IndexedStack`, which keeps
each tab's scroll position and filter state alive when switching tabs; detail,
create, and RSVP screens are pushed as routes on top. Application state is
managed with the `provider` package [3] using four `ChangeNotifier` stores
(authentication, feed, RSVPs, chat) created once at the widget tree's root. UI
widgets subscribe with `context.watch` and trigger updates by calling provider
methods, giving a single source of truth per concern. Persistence uses
`shared_preferences` [4] to store the session and RSVP sets, loaded on launch by
an `AuthGate` that shows onboarding or the app shell accordingly.

## 6. Justification of major decisions

We chose Flutter for a single codebase targeting Android and iOS [2], and
`provider` over heavier alternatives because the app's state is moderate and the
team can fully explain it — important given the live-demo requirement. We
deliberately avoided network images and extra dependencies so the prototype runs
reliably on an emulator with no connectivity, and used mock data so the feature
set, not backend plumbing, is what gets evaluated. Role-gating lives in the data
model so the rule is enforced in one place rather than scattered through the UI.

## 7. Challenges and solutions

The main challenges were: (a) modelling cross-campus visibility without a
backend — solved with a single rule in the feed provider that always includes
hybrid posts; (b) keeping RSVP state consistent (a post is *Going* or
*Interested*, never both) — solved with two mutually exclusive sets that persist
together; and (c) ensuring the prototype is fully defensible — addressed by
centralising logic, documenting decisions, and keeping the dependency surface
small.

## References

*(IEEE style — confirm URLs/dates and adjust to your course's required format.)*

[1] African Leadership University, "Our Model / Mission," ALU. [Online].
    Available: https://www.alueducation.com. [Accessed: ___].

[2] Flutter, "Flutter documentation," Google. [Online].
    Available: https://docs.flutter.dev. [Accessed: ___].

[3] R. Rousselet, "provider package," pub.dev. [Online].
    Available: https://pub.dev/packages/provider. [Accessed: ___].

[4] Flutter Community, "shared_preferences package," pub.dev. [Online].
    Available: https://pub.dev/packages/shared_preferences. [Accessed: ___].
