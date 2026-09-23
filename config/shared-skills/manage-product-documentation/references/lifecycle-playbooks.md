# Product documentation lifecycle playbooks

Read only the playbook needed for the current work.

## Greenfield setup

Use when there is no product documentation, repository, or established system model.

Begin this setup after the user explicitly asks to establish product documentation or a substantive design discussion needs its first owner. A passing idea alone is not setup authority.

1. Confirm the product, users, problem, and current evidence state from the conversation. Ask only about a material missing boundary or intent.
2. Follow the workspace's existing folder and page-preparation guidance, then create one minimal Product Map from [artifact-shapes.md](artifact-shapes.md). Record confirmed foundation, known capability areas, and explicit unknowns. Do not invent milestones, architecture, integrations, or implementation choices.
3. Keep passing ideas in the active discussion. Park an idea the user engaged with and left open as one line on the Ideas page, created on first use and linked from the map.
4. Once discussion develops a real system boundary, behavior, contract, or meaningful alternative, add the system to the map and create its Product Spec at `idea` with confirmed material and explicit gaps. Do not invent execution work. Advance it only when later evidence supports the next state.
5. Reuse the user's work stream and Tasks or create only the finite execution work needed by the normal workflow. Link that work to the spec; do not copy its changing status into the page.
6. Do not create an Architecture Map as if architecture exists. Before code exists, retain only confirmed technical constraints or Decisions. Create the map once code gives evidence of stable architecture, in Octopad or in the repository when the team wants it beside the code.

Example: a user mentions three collaboration features and discusses shared review in enough detail to establish its boundary. Create or adopt that system's spec at `idea`, leave implementation architecture unknown, and park only the other ideas the user engaged with and left open. Create execution work only after a separate commitment requires it.

## Existing-product setup

Use before creating structure for a product that already has code, docs, or Octopad history.

1. Bound the inventory: connected Octopad organization and workspaces, repositories, default and release branches, docs locations, and active work streams.
2. Search Octopad Pages, Tasks, work streams, and Decisions by product terms and likely synonyms. Read candidate bodies and links before judging duplicates.
3. Inspect repository READMEs, docs indexes, architecture records, contribution rules, release policy, and current code structure. Treat stale or generated docs as time-bounded evidence, not automatic canon.
4. Build a temporary adoption table: artifact, current authority, evidence revision, model destination, duplicate or conflict, and action.
5. Designate or reshape one Product Map for this product documentation set. Treat an existing Product Overview or index as the first adoption candidate when it already owns the entry-point role. Adopt existing product or feature docs as evolving Product Specs when they already own coherent system boundaries.
6. Preserve useful unique content and inbound links before consolidation. Use redirects, superseded markers, or links by default. Require explicit approval before deleting content or irreversibly overwriting history.
7. Adopt one credible architecture overview wherever it already lives, and record that home. Otherwise create the smallest canonical Architecture Map from verified code and configuration, in Octopad or in the repository when the team wants it beside the code.
8. Link existing streams, Tasks, Decisions, PRs, and docs. Do not recreate completed history or replace an Octoplan task graph with a documentation-owned plan.
9. Mark conflicts, gaps, and unverifiable claims as documentation debt. Ask about authority only when evidence and normal review cannot resolve it.

## Brainstorm and design maturity

Classify impact continuously without making the conversation feel like a form:

- `no impact`: a rejected or abandoned idea, or work outside product documentation;
- `existing-system change`: idea, explored, accepted, or later behavior inside a known system boundary;
- `new system`: substantive design establishing a new coherent capability or responsibility, beginning at `idea`;
- `technical-only`: implementation or operational work with no product behavior change, which can still affect architecture or an Engineering Reference.

During casual exploration, keep the classification local and park only an idea the user engaged with and left open. When the discussion becomes substantive design, create or adopt the owning Product Spec at `idea`, add or update its Product Map link and `idea` status, then remove any duplicate parked entry while preserving its unique content in the spec. Do not wait for a build decision. Acceptance, implementation, merge, and release advance that same record only on their own evidence. If the product or system boundary remains materially ambiguous after reading current context, ask one focused question and continue unaffected organization work.

At the end of a brainstorm, park only the remaining passing ideas the user engaged with and left open that did not become owned design. Park an idea raised in passing during other work the same way. Park nothing the user turned down or dropped. Each line carries the date it was parked, the idea, and one clause on the problem it addresses; [documentation-model.md](documentation-model.md) states where the line lives and how it leaves the list.

## Implementation context retrieval

1. Identify the affected system and intended behavior.
2. Read only relevant Product Spec sections, applicable Behavioral Contract clauses, the Architecture Map slice, linked Decisions, and the active Task.
3. Inspect current code for files, symbols, imports, dependencies, tests, schemas, and runtime configuration. Prefer current derivation over stored inventories.
4. Carry forward exact source and documentation revisions.
5. Put new enforceable behavior in executable checks where feasible. Update prose only for durable knowledge or user behavior.

Do not load every Product Spec or the whole repository merely because the Product Map links to them.

## Pull request and delivery sync

1. Determine documentation impact: none, existing-system change, new system, or technical-only. Record it on the PR in the repository's normal way, naming affected documents or carrying the proven negative receipt. Follow the complete no-impact protocol in `SKILL.md`: inventory the maintained set for every affected product without a title filter, then supplement it with diff-derived search and read likely candidates. `technical-only` does not imply `none` when durable architecture or an Engineering Reference changed. Behavior that changed while no page owns it is documentation debt rather than no impact.
2. Link the existing Task or work stream to the PR through the repository's normal fields, and link the affected Product Spec back to that work.
3. Record exact head and base revisions. Re-check after material drift.
4. Make the smallest draft update needed to preserve intent and reviewability. Keep proposed, approved, and implemented labels separate.
5. Verify claims against code, tests, and the actual diff rather than the PR description alone.
6. Draft pre-release user-documentation or release-note changes when useful, but label them clearly and bind them to the exact approved, implemented, or merged revision. Do not turn them into shipped wording, Product Facts, or marketing claims.
7. After merge, record `merged` only. Do not label the behavior released.
8. When evidence remains missing, mark the update stale or unverified and create or reuse documentation-debt work.

Follow repository review and merge controls. This skill grants no merge authority and creates no separate approval system.

## Release sync

Run one full pass per release, when changes actually reach users. This pass is the safety net that keeps shipped truth current: it must end with either updated docs or named debt, never a silent skip. Keep one durable record per release — a release page or runbook entry: step 9 writes it, and step 2 reads the previous one. On the first pass ever, no previous record exists; bound on the oldest evidence you can verify and say so.

1. Verify the repository's release policy, exact released revision, and included changes.
2. Bound the release window. Read the boundary the previous release pass recorded: an exact revision, or failing that a date resolved to a revision. Collect every change between that boundary and this release's exact revision. Never bound on a moving branch head or a bare date; a date boundary silently drops same-day changes. When the boundary is imprecise, over-collect toward the older side and say so in the closing record — a duplicate is visible, a dropped change is not.
3. Consume each change's documentation-impact mark when the delivery workflow records one. A mark naming a maintained doc puts that doc on the update list with the change as evidence. Recheck an explicit `none` against the diff and its receipt. A missing or wrong owner is resolved by adopting or creating the smallest authorized owner when the evidence is sufficient; otherwise file documentation debt. A mark naming another family's doc is a handoff, not an edit order.
4. Re-read each affected draft against released code and observed product behavior when available.
5. Update released behavior in affected Product Specs and relevant Architecture Map sections. Preserve exact release provenance.
6. Keep unverified claims out of shipped truth. Track them as documentation debt.
7. Resolve and open each existing product authority affected by the release, including the Product Map and any Product Facts whose dependencies moved. A Product Facts page is born only with the first substantiated public claim; its prior absence is normal. Create or adopt a missing ordinary owner when the released evidence and session authority support it, or record the exact gap. Only a document the product context explicitly marks as locked requires exact before/after approval before editing.
8. Reconcile pre-release user documentation or release notes against verified released evidence before removing their label. Draft or revise Product Facts here. Hand marketing claims and final marketing wording to product marketing. Preserve every review and publication gate.
9. Close the loop on the release record: the boundary covered and this release's exact revision (the next pass's lower bound), each doc updated with its evidence, each canon outcome (not needed, validated and applied, pending task, or escalated), and a link to the documentation-debt work.

If repository policy explicitly proves that merge equals release, record that policy as evidence. Otherwise keep merge and release separate.

## Maintenance and audit

1. Verify the Product Map points to one current spec per significant system and, when architecture exists, one canonical Architecture Map.
2. Check links, ownership metadata, lifecycle labels, source revisions, and last-verification times.
3. Repair safe metadata and broken links directly when the correct target is unambiguous.
4. Compare high-value claims with current code, release evidence, Decisions, and user-facing behavior. Mark unsupported claims stale or unverified instead of guessing.
5. Consolidate duplicates only after preserving unique knowledge and history. Require explicit approval before deletion or irreversible overwrite.
6. Review parked ideas and the Ideas page. Propose removing lines whose problem has lapsed, in one batch; do not remove them silently.
7. Create or reuse one bounded documentation-debt Task for related missing evidence, unresolved conflicts, or substantial rewrites. Do not create one task per broken link.
8. Report repairs, remaining uncertainty, and the evidence needed to resolve it.

## Downstream documents

For user docs, release notes, and Product Facts, plus handoffs to marketing:

1. For pre-release user documentation or release notes, start from approved, implemented, or merged evidence, label the draft pre-release, and bind it to the exact source revision.
2. For Product Facts, apply the skill's exact-claim and state evidence requirements: shipped or released behavior and software's current capabilities or availability require exact verified release evidence regardless of wording; non-software offer, service or physical-specification facts require the relevant authoritative evidence for their stated scope and state. Approval or validation alone proves neither availability nor launch. Route marketing claims and final marketing wording to product marketing with those Facts as inputs.
3. Verify every capability, limit, outcome, compatibility statement, and metric.
4. Separate current behavior from future intent. Exclude internal implementation detail unless the audience needs it.
5. Draft the smallest audience-appropriate change and retain source links in the working artifact when possible.
6. Reconcile every pre-release draft after release, then obtain required publication approval. Do not publish merely because the draft is complete.
