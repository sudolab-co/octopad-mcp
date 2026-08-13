# Product documentation model

Use the smallest set of durable artifacts that makes the product understandable and safe to change. Adopt clear existing vocabulary instead of renaming established systems merely to fit this model.

## Product Map

Keep one concise Product Map per product documentation set as the entry point. If an existing Product Overview or index already performs this job, adopt or reshape it instead of creating a competing map. Include:

- confirmed product purpose and intended users;
- significant product systems and each system's lifecycle state;
- links to each Product Spec and, when useful, its active work stream;
- the canonical Architecture Map, when architecture exists;
- the Ideas page, when one exists;
- important cross-system relationships;
- explicit gaps, stale areas, and last-verification metadata.

Do not turn the map into a second backlog, full architecture document, or copied status report.

## Product Spec

Keep one evolving Product Spec per significant product system. A system is significant when it owns a coherent user capability, durable behavior, or boundary that people need to reason about independently.

Use the compact shape in [artifact-shapes.md](artifact-shapes.md). Update the existing spec as the system evolves. Split only when distinct system boundaries have emerged. Supersede or link duplicates after preserving unique facts and links; require explicit approval before destructive consolidation.

## Parked ideas

Keep an idea the user engaged with and left open as one line in the `Parked ideas` section of the Product Spec it concerns. An idea the user turned down or dropped is discarded; never park it. Give the line the date it was parked, the idea, and one clause on the problem it addresses. Add no owner, priority, status, origin, or rationale: that weight is what stops the list from being written at all, and its absence is what stops the list from becoming a second backlog. Finite execution, owners, and status stay in work streams and Tasks.

An idea that concerns no existing system yet goes on one Ideas page for this product documentation set. Create that page on the first such idea, never in advance, and link it from the Product Map so it stays findable; creating the page and its map link is part of parking, not a separate authority. Move a line to a system's Product Spec once that system exists. Parking begins once a Product Map exists; before then, keep ideas in the conversation and follow the setup playbooks.

Keep the list self-emptying. When an idea is committed, move its line into the spec's proposed or approved changes and let ordinary commitment handling take over. When the user rejects an idea, remove its line and record at most a one-clause reason in its place. Moving or removing a parked line, or dropping an emptied section, is routine list maintenance, not the content deletion that needs approval. During maintenance and audit, propose removing lines whose problem has lapsed, in one batch; do not remove them silently. Never grow either list into a status report.

## Behavioral Contract

Create a Behavioral Contract only when at least one condition applies:

- safety, privacy, permissions, billing, data integrity, or another consequential risk needs precision;
- multiple components depend on the same exact behavior;
- ambiguous edge cases repeatedly cause defects or disagreement;
- compatibility or migration behavior must remain stable.

State inputs, outputs, invariants, failure behavior, compatibility, and evidence. Link enforceable parts to tests, types, schemas, lint, or CI. Do not copy an executable invariant into prose and then treat the prose as enforcement.

## Architecture Map

Keep architecture intentionally asymmetric: one short map, not one engineering document per Product Spec.

Prefer canonical Markdown in a connected repository when code exists. Choose a discoverable docs location consistent with that repository. Keep Octopad as the index for its link, ownership, status, related systems, and verification metadata. If no repository exists, create an explicitly provisional Octopad page only when stable architecture is already useful; otherwise leave the map uncreated and record the gap.

Include only stable orientation:

- major runtime or deployable components;
- data stores and external services;
- important boundaries and directional relationships;
- where to find current code and enforceable contracts;
- how release state is determined.

Do not manually inventory every file, symbol, import, endpoint, or dependency. Derive those from current code when needed.

## Engineering References

Create a targeted Engineering Reference only for important knowledge that is stable and not cheaply derivable, such as a non-obvious operational constraint, durable integration convention, or difficult data-model rationale. Link it from the Architecture Map and affected Product Specs. Prefer a Decision for a choice and its rationale; prefer code for mechanics.

## Relationships and provenance

Use links instead of duplicated prose. Maintain useful edges when they exist:

- Product Map → Product Spec → active work stream or Tasks;
- Product Spec → Decisions, Behavioral Contract, Architecture Map section, released user docs;
- Task or work stream → Product Spec and PR;
- PR or release → documentation impact and exact draft or shipped revision.

For each material claim, make it possible to answer:

- What source supports it?
- At which repository revision or release was it observed?
- Is it proposed, approved, implemented, merged, released, stale, or unverified?
- When was it last verified?

Use explicit unknowns instead of placeholder facts. Never invent a value to make a template look complete.
