# Product documentation lifecycle playbooks

Read only the playbook needed for the current work.

## Greenfield setup

Use when there is no product documentation, repository, or established system model.

Begin this setup only after the user explicitly asks to establish product documentation or makes a clear product commitment. Casual exploration alone is not setup authority.

1. Confirm the product, users, problem, and current commitment from the conversation. Ask only about a material missing boundary or intent.
2. Follow the workspace's existing folder and page-preparation guidance, then create one minimal Product Map from [artifact-shapes.md](artifact-shapes.md). Record confirmed foundation, known capability areas, and explicit unknowns. Do not invent milestones, architecture, integrations, or implementation choices.
3. Keep early ideas in the active discussion until a system boundary is accepted.
4. When a system is accepted or the user says to build it, add it to the map and create a `Draft` Product Spec with the confirmed purpose, boundary, behavior, Decisions, and evidence gaps.
5. Reuse the user's work stream and Tasks or create only the finite execution work needed by the normal workflow. Link that work to the spec; do not copy its changing status into the page.
6. Do not create an Architecture Map as if architecture exists. Before a repository exists, retain only confirmed technical constraints or Decisions. Create the canonical repository map once code provides evidence; use an explicitly provisional Octopad fallback only when orientation is already useful.

Example: a user explores three collaboration features. Make no three speculative specs. Once the user chooses shared review and says “build it,” create or adopt that system's `Draft` spec, link its execution work, and leave implementation architecture unknown until evidence exists.

## Existing-product setup

Use before creating structure for a product that already has code, docs, or Octopad history.

1. Bound the inventory: connected Octopad organization and workspaces, repositories, default and release branches, docs locations, and active work streams.
2. Search Octopad Pages, Tasks, work streams, and Decisions by product terms and likely synonyms. Read candidate bodies and links before judging duplicates.
3. Inspect repository READMEs, docs indexes, architecture records, contribution rules, release policy, and current code structure. Treat stale or generated docs as time-bounded evidence, not automatic canon.
4. Build a temporary adoption table: artifact, current authority, evidence revision, model destination, duplicate or conflict, and action.
5. Designate or reshape one Product Map for this product documentation set. Treat an existing Product Overview or index as the first adoption candidate when it already owns the entry-point role. Adopt existing product or feature docs as evolving Product Specs when they already own coherent system boundaries.
6. Preserve useful unique content and inbound links before consolidation. Use redirects, superseded markers, or links by default. Require explicit approval before deleting content or irreversibly overwriting history.
7. Adopt one credible architecture overview. Otherwise create the smallest canonical Architecture Map from verified code and configuration, preferably in the repository.
8. Link existing streams, Tasks, Decisions, PRs, and docs. Do not recreate completed history or replace an Octoplan task graph with a documentation-owned plan.
9. Mark conflicts, gaps, and unverifiable claims as documentation debt. Ask about authority only when evidence and normal review cannot resolve it.

## Brainstorm and commitment

Classify impact continuously without making the conversation feel like a form:

- `no impact`: discarded ideas or exploration with no accepted product change;
- `existing-system change`: accepted behavior inside a known system boundary;
- `new system`: a new coherent capability or responsibility with an accepted boundary;
- `technical-only`: implementation or operational work with no product behavior change.

During exploration, keep the classification local and make no speculative durable writes. Commitment is clear when the user accepts a direction, says “build it,” implementation starts, or a delivery artifact is active. Then act without redundant confirmation. If the system boundary remains materially ambiguous, ask one focused question and continue unaffected organization work.

## Implementation context retrieval

1. Identify the affected system and intended behavior.
2. Read only relevant Product Spec sections, applicable Behavioral Contract clauses, the Architecture Map slice, linked Decisions, and the active Task.
3. Inspect current code for files, symbols, imports, dependencies, tests, schemas, and runtime configuration. Prefer current derivation over stored inventories.
4. Carry forward exact source and documentation revisions.
5. Put new enforceable behavior in executable checks where feasible. Update prose only for durable knowledge or user behavior.

Do not load every Product Spec or the whole repository merely because the Product Map links to them.

## Pull request and delivery sync

1. Determine documentation impact: none, existing-system change, new system, or technical-only.
2. Link the existing Task or work stream to the PR through the repository's normal fields, and link the affected Product Spec back to that work.
3. Record exact head and base revisions. Re-check after material drift.
4. Make the smallest draft update needed to preserve intent and reviewability. Keep proposed, approved, and implemented labels separate.
5. Verify claims against code, tests, and the actual diff rather than the PR description alone.
6. Draft pre-release user-documentation or release-note changes when useful, but label them clearly and bind them to the exact approved, implemented, or merged revision. Do not turn them into shipped wording, Product Facts, or marketing claims.
7. After merge, record `merged` only. Do not label the behavior released.
8. When evidence remains missing, mark the update stale or unverified and create or reuse documentation-debt work.

Follow repository review and merge controls. This skill grants no merge authority and creates no separate approval system.

## Release sync

1. Verify the repository's release policy, exact released revision, and included changes.
2. Re-read each affected draft against released code and observed product behavior when available.
3. Update released behavior in affected Product Specs and relevant Architecture Map sections. Preserve exact release provenance.
4. Keep unverified claims out of shipped truth. Track them as documentation debt.
5. Assess downstream impact across user docs, release notes, Product Facts, and marketing claims.
6. Reconcile any pre-release user-documentation or release-note draft against verified released evidence before removing its pre-release label.
7. Draft Product Facts, marketing claims, and final shipped wording only from verified released evidence. Route all downstream material through normal review and publication gates; never publish automatically.

If repository policy explicitly proves that merge equals release, record that policy as evidence. Otherwise keep merge and release separate.

## Maintenance and audit

1. Verify the Product Map points to one current spec per significant system and, when architecture exists, one canonical Architecture Map.
2. Check links, ownership metadata, lifecycle labels, source revisions, and last-verification times.
3. Repair safe metadata and broken links directly when the correct target is unambiguous.
4. Compare high-value claims with current code, release evidence, Decisions, and user-facing behavior. Mark unsupported claims stale or unverified instead of guessing.
5. Consolidate duplicates only after preserving unique knowledge and history. Require explicit approval before deletion or irreversible overwrite.
6. Create or reuse one bounded documentation-debt Task for related missing evidence, unresolved conflicts, or substantial rewrites. Do not create one task per broken link.
7. Report repairs, remaining uncertainty, and the evidence needed to resolve it.

## Downstream documents

For user docs, release notes, Product Facts, or marketing drafts:

1. For pre-release user documentation or release notes, start from approved, implemented, or merged evidence, label the draft pre-release, and bind it to the exact source revision.
2. For Product Facts, marketing claims, or final shipped wording, start only from released Product Spec behavior and exact release evidence.
3. Verify every capability, limit, outcome, compatibility statement, and metric.
4. Separate current behavior from future intent. Exclude internal implementation detail unless the audience needs it.
5. Draft the smallest audience-appropriate change and retain source links in the working artifact when possible.
6. Reconcile every pre-release draft after release, then obtain required publication approval. Do not publish merely because the draft is complete.
