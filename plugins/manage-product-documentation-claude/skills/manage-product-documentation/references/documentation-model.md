# Product documentation model

Use the smallest set of durable artifacts that makes the product understandable and safe to change. Adopt clear existing vocabulary instead of renaming established systems merely to fit this model.

## Product Map

Keep one concise Product Map per product documentation set as the entry point. If an existing Product Overview or index already performs this job, adopt or reshape it instead of creating a competing map. Include:

- confirmed product purpose and intended users;
- significant product systems and each system's lifecycle state;
- links to each Product Spec and, when useful, its active work stream;
- the canonical Architecture Map, when architecture exists;
- important cross-system relationships;
- explicit gaps, stale areas, and last-verification metadata.

Do not turn the map into a second backlog, full architecture document, or copied status report.

## Product Spec

Keep one evolving Product Spec per significant product system. A system is significant when it owns a coherent user capability, durable behavior, or boundary that people need to reason about independently.

Use the compact shape in [artifact-shapes.md](artifact-shapes.md). Update the existing spec as the system evolves. Split only when distinct system boundaries have emerged. Supersede or link duplicates after preserving unique facts and links; require explicit approval before destructive consolidation.

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
