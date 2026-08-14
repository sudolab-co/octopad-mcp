---
name: manage-product-documentation
description: Organize and maintain product documentation in Octopad while a user explores, builds, changes, ships, or audits a product. Use during ordinary product discussion, accepted feature or system work, implementation and pull-request activity, release sync, documentation cleanup, architecture documentation, user-documentation work, release-note preparation, and Product Facts or marketing drafting. Support both greenfield products with no repository or docs and existing products whose pages, tasks, decisions, repositories, and docs must be adopted before anything new is created.
---
Version: 1.2.0

# Manage Product Documentation

Keep product knowledge useful without turning product work into a documentation ceremony. Administer the structure, links, drafts, classifications, and routine maintenance while the user works normally.

## Load the needed guidance

- Read [references/documentation-model.md](references/documentation-model.md) before creating, adopting, splitting, merging, or substantially restructuring product documentation.
- Read [references/artifact-shapes.md](references/artifact-shapes.md) when creating or materially reshaping a Product Map, Product Spec, Behavioral Contract, Architecture Map, Ideas page, or documentation-debt Task.
- Read [references/lifecycle-playbooks.md](references/lifecycle-playbooks.md) for setup, brainstorm classification, implementation context, PR or release sync, audits, and downstream drafts. Load only the section needed for the current work.

## Operate with evidence

1. Confirm the connected Octopad organization and relevant workspace before writing. Confirm each repository and branch from current evidence. Follow their local instructions. Before creating a Page, use the workspace's available folder and page-preparation guidance and preserve its established organization.
2. Search before creating. Read likely matches, not only titles. Reuse and link existing pages, streams, tasks, decisions, repository docs, and PRs. Supersede or redirect duplicates non-destructively after preserving unique facts and links; never automatically delete content or overwrite history.
3. Treat unknown facts as unknown. Ask only when an unresolved system boundary, product intent, or authority conflict would materially change the result. Otherwise use a concise `Unknown`, `Unverified`, or documentation-debt marker and keep working.
4. Never fabricate architecture, behavior, ownership, dates, metrics, source revisions, release state, or customer evidence. Derive technical facts from current code and repository configuration when available.
5. Keep provenance beside material claims: evidence source, observed revision or release, verification state, and last verified time. Do not present an old observation as current.
6. Minimize persisted evidence. Never copy secrets, credentials, private local paths, personal or customer identifiers, or unnecessary source bodies into Octopad. Prefer a safe repository link, public revision, or redacted summary that proves the claim without exposing unrelated data.

## Administer the documentation system

Use this asymmetric structure:

- Keep exactly one **Product Map** per product documentation set as its entry point. Adopt an existing Product Overview or index when it already serves that authority.
- Keep one evolving **Product Spec** for each significant product system.
- Add a **Behavioral Contract** only when risk, ambiguity, or cross-boundary precision warrants one.
- Keep one short canonical **Architecture Map** in Octopad. Put it in a connected repository instead when the team wants architecture to change in the same review as the code; then keep the Octopad entry as its link, ownership, status, related systems, and verification metadata. Either way, name the one canonical home and do not maintain both.
- Add targeted **Engineering References** only for stable, important knowledge that cannot be cheaply derived from code. Never create one per Product Spec by default.

Keep durable knowledge in Pages, or in the repository docs that already hold it. Keep finite execution, owners, and current status in existing work streams and Tasks. Link them rather than copying task state into pages. Reuse an existing Octoplan-created stream or task graph when present; do not require Octoplan and do not create a parallel planning system.

Derive file paths, symbols, imports, dependencies, and call graphs from current code on demand. Put enforceable invariants in tests, types, schemas, lint rules, or CI instead of relying on prose. Retrieve only the smallest relevant slice of the Product Spec, any applicable contract, Architecture Map, decisions, and current code for implementation.

## Recognize commitment without interrupting exploration

During casual brainstorming, silently classify the likely documentation impact as:

- `no impact`
- `existing-system change`
- `new system`
- `technical-only`

Do not interrupt exploration. While exploration continues, create no Product Spec, Behavioral Contract, architecture record, or new Product Map system entry; parking an idea is the single exception, because a parked line is cheap and trivially reversible. Act when commitment becomes clear through an explicit decision such as “build it,” acceptance of a system boundary or behavior, creation or start of implementation work, or an active delivery workflow. An explicit build decision is sufficient authority for ordinary in-scope drafting and linking; do not ask for the same confirmation again.

Park what exploration leaves behind. At the end of a brainstorm, and whenever an idea is raised in passing during other work, append each idea the user engaged with and left open, without asking: one line carrying the date it was parked, the idea, and the problem it addresses, in the `Parked ideas` section of the Product Spec it concerns, or on the single Ideas page when it concerns no existing system yet. Creating that page on first use and linking it from the Product Map is part of parking, not a separate authority. Add no owner, priority, or status, and keep each line within the persisted-evidence rules. Never park an idea the user turned down or dropped. A line leaves the list when the idea is committed, where ordinary commitment handling takes over, or when the user rejects it; moving or removing a parked line is routine list maintenance, not the content deletion that needs approval. Before a Product Map exists, keep ideas in the conversation and follow the setup playbooks.

When commitment is clear, make the smallest useful update:

- For a new accepted system, add it to the Product Map and create its Product Spec as `Draft`.
- For an existing-system change, update the evolving Product Spec with clearly labeled proposed or approved behavior and link the existing execution work.
- For technical-only work, update architecture or a targeted Engineering Reference only when the change creates durable, non-derivable knowledge.
- For no impact, create no documentation artifact beyond any parked idea line and, on first use, the Ideas page that holds it.

## Preserve lifecycle truth

Keep `proposed`, `approved`, `implemented`, `merged`, and `released` distinct. Never infer one from another.

- Code or tests can prove implementation, not approval or release.
- A pull request can prove a proposed source revision.
- A merge proves only that a revision reached its base branch.
- Mark behavior as released or shipped only after verifying the repository's actual release policy and release evidence. A merge is not a production release unless that policy proves it.

During active implementation, PR, delivery, or release work, maintain documentation impact, links among Tasks and PRs, the smallest relevant draft edits, provenance, and exact source revision. Promote shipped truth only after release verification. If evidence is missing, mark the claim stale or unverified and create or reuse documentation-debt work instead of guessing.

When creating an Octopad Task, follow the server contract: write literal `Why` and `What` sections, plus `Done when` for every top-level Task; provide `impact` from 1 to 5 and `impact_rationale`; use `parent_task_id` for a subtask; and include a rationale for every dependency edge. Reuse an existing suitable Task instead of creating a duplicate.

## Keep human authority narrow and meaningful

Administer templates, folders, links, classifications, drafts, parked ideas, routine sync, and safe metadata or link repair without asking. Ask the user only for:

- material ambiguity in product intent or a significant system boundary;
- an unresolved conflict over which source is authoritative;
- a consequential decision not already handled by the normal product or repository review;
- deletion, irreversible overwrite, or another destructive consolidation;
- approval to publish externally.

Do not automatically publish user docs, release notes, Product Facts, or marketing copy. Before release, user-documentation and release-note drafts may use approved, implemented, or merged evidence only when they remain clearly labeled pre-release and cite the exact source revision. Draft Product Facts, marketing claims, and final shipped wording only from verified released evidence. Preserve every applicable review and publication gate.

## State the automation boundary honestly

This skill is workflow intelligence, not a background service. It can activate implicitly while an AI is running in a conversation, implementation or PR workflow, audit, or release sync. It cannot observe GitHub or update Octopad after the AI stops. Truly unattended event-driven updates require a separately installed and authorized Octopad/GitHub event or automation trigger. Never claim that installing this skill alone enables background synchronization.
