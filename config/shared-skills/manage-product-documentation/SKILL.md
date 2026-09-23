---
name: manage-product-documentation
description: Keep one or more products' documentation true to the work as it happens. In a multi-product workspace, establish the affected product scope before choosing a page; the first matching document does not establish scope. Load it when product behavior is explored, decided, implemented, merged, released, rolled back, or retired; for product ideas, specs, contracts, architecture, user documentation, release notes, and Product Facts; and before claiming no product or documentation impact. It owns product truth and passes claim-safe facts to product marketing. A change confined to agent instructions, internal notes, or pure marketing does not need it; build tooling still needs an impact check when durable architecture or release behavior moves.
---
Version: 4.0.0-public-r2
Candidate status: local and unreleased

# Manage Product Documentation

Keep a living account of the user's product vision and how it becomes real. Preserve vision as attributed intent even before code exists; preserve shipped behavior only when evidence proves it. Organize and link the documents so the user's AI can find and apply the right context without making the user administer the structure.

## Resolve the product first

Before selecting a document to change:

1. Use an explicit product selection from the conversation or assigned task. A workspace name or search result is not a selection.
2. Otherwise read the product Maps and candidate Specs to build the set of products whose Specs describe the behavior being changed. Keep **every** matching product. Remove one only when evidence puts it outside the requested scope; never rank plausible owners or choose the best match.
3. Count the remaining products: **zero** — record the gap or ask; **one** — continue; **more than one** — ask which products are intended and leave their documents unchanged until answered.

For multi-product work, read [product-scope-and-seams.md](references/product-scope-and-seams.md) before writing.

## Load the needed guidance

- Read [references/documentation-model.md](references/documentation-model.md) before creating, adopting, splitting, merging, or substantially restructuring product documentation.
- Read [references/artifact-shapes.md](references/artifact-shapes.md) when creating or materially reshaping a Product Map, Product Spec, Behavioral Contract, Architecture Map, Ideas page, or documentation-debt Task.
- Read [references/lifecycle-playbooks.md](references/lifecycle-playbooks.md) for setup, brainstorm classification, implementation context, PR or release sync, audits, and downstream drafts. When the request itself identifies an audit, classify it before inspecting maintained content and load the audit section before the first maintained-content read or audit conclusion. Load only the section needed for the current work. Do not apply the audit section to a non-audit request unless its facts make that section applicable.
- Read [references/product-scope-and-seams.md](references/product-scope-and-seams.md) when the workspace contains several products, a shared component changes, a Product Fact moves, or another documentation skill owns a downstream projection.

## Operate with evidence

These four request classes are defined here and reused by the documentation family. Classify the work before writing:

- **create:** establish the missing owner after proving none exists;
- **refresh:** replace stale current truth in the existing owner while preserving history;
- **audit:** inspect a bounded maintained set, repair the unambiguous, and record gaps;
- **synchronize:** propagate a changed source through this family's projections and hand other outputs to their owners.

## Stop before writing

- Create or activate a Product Fact only after reading evidence, retrieved or supplied, competent to prove its exact claim, product scope and state. Claims of shipped or released behavior, or of software's current capabilities or availability, require verified release evidence, whether or not their wording mentions a release. Facts about a non-software offer, service or physical specification require the relevant authoritative decision, service record or technical evidence for their exact state; approval or validation alone proves neither availability nor launch. A named artifact or an assurance that evidence is available is a pointer, not proof. If the required evidence cannot be found, create no Fact or dependent approved copy and name the gap.

1. Confirm the connected Octopad organization and relevant workspace before writing. Identify the affected product or products from current evidence; do not equate product, repository, project, or workspace. Confirm each repository and branch from current evidence. Follow their local instructions. Before creating a Page, use the workspace's available folder and page-preparation guidance and preserve its established organization.
2. Search before creating, and before declaring absence. Read likely matches, not only titles. Reuse and link existing pages, streams, tasks, decisions, repository docs, and PRs. Supersede or redirect duplicates non-destructively after preserving unique facts and links; never automatically delete content or overwrite history.
3. Prove a negative before writing one. `No documentation impact` is a claim about the maintained set for every affected product. Harvest terms from the changed lines and each touched file's header comments. First list that maintained set without a title filter and read its descriptions or summaries; then open likely candidates and supplement the inventory with search over the harvested names and product terms. Record the receipt beside the claim, on one line: affected product or products, terms searched, pages inventoried, candidates read or `no candidate`, and either the document the change cites or `the change cites no document`. Search alone, or an inventory of the wrong product, proves nothing. Behavior that changed while no page owns it is a gap: record one documentation-debt item instead of closing the question.
4. Treat unknown facts as unknown. Ask only when an unresolved system boundary, product intent, or authority conflict would materially change the result. An explicit unresolved authority conflict affecting this change always meets this bar: preserve both sources and ask instead of choosing or rewriting either one. Otherwise use a concise `Unknown`, `Unverified`, or documentation-debt marker and keep working.
5. Never fabricate architecture, behavior, ownership, dates, metrics, source revisions, release state, or customer evidence. Derive technical facts from current code and repository configuration when available.
6. Keep provenance beside material claims: evidence source, observed revision or release, verification state, and last verified time. Do not present an old observation as current.
7. Minimize persisted evidence. Never copy secrets, credentials, private local paths, personal or customer identifiers, or unnecessary source bodies into Octopad. Prefer a safe repository link, public revision, or redacted summary that proves the claim without exposing unrelated data.

## Administer the documentation system

Use this asymmetric structure:

- Keep one concise **Product Overview** role per product for purpose, experience, design pillars, non-goals, and relationships above system specs. Keep this authority distinct from the Product Map's navigation and status role, even when one existing page serves both through separate sections.
- Keep exactly one **Product Map** per product as its entry point. A portfolio index may route to several product maps but must not restate their truth. Adopt an existing Product Overview or index when it already serves the product's entry-point authority.
- Keep one evolving **Product Spec** for each significant product system.
- Add a **Behavioral Contract** only when risk, ambiguity, or cross-boundary precision warrants one.
- Keep one short canonical **Architecture Map** in Octopad. Put it in a connected repository instead when the team wants architecture to change in the same review as the code; then keep the Octopad entry as its link, ownership, status, related systems, and verification metadata. Either way, name the one canonical home and do not maintain both.
- Add targeted **Engineering References** only for stable, important knowledge that cannot be cheaply derived from code. Never create one per Product Spec by default.

Keep durable knowledge in Pages, or in the repository docs that already hold it. Keep finite execution, owners, and current status in existing work streams and Tasks. Link them rather than copying task state into pages. Reuse an existing Octoplan-created stream or task graph when present; do not require Octoplan and do not create a parallel planning system.

Use documentation as working context, not only as a record. For design or a product question, retrieve the relevant vision, intended behavior, Decisions, and open points. For implementation or release, add the applicable contracts, architecture, current code, and release evidence. Load the smallest slice needed; derive paths, symbols, imports, dependencies, and call graphs from current code, and put enforceable invariants in tests, types, schemas, lint rules, or CI.

## Capture exploration without waiting for a build decision

During product discussion, silently classify the likely documentation impact as:

- `no impact`
- `existing-system change`
- `new system`
- `technical-only`

A substantive design discussion is different from a passing thought. Once the discussion develops a real user problem, system boundary, behavior, contract, or meaningful alternative, in the same turn: create or adopt the owning Product Spec at `idea`; add or update its Product Map link and `idea` status; then remove any duplicate parked entry while preserving its unique content in the spec. Do this even when nobody has decided to build. It records the thinking without claiming approval or delivery and without inventing an execution Task. When the user accepts a direction, implementation starts, or an active delivery workflow exists, update that same spec and let ordinary work tracking own execution.

Park what exploration leaves behind. At the end of a brainstorm, and whenever an idea is raised in passing during other work, append each remaining passing idea the user engaged with and left open, without asking: one line carrying the date it was parked, the idea, and the problem it addresses, in the `Parked ideas` section of the Product Spec it concerns, or on the single Ideas page when it concerns no existing system yet. Creating that page on first use and linking it from the Product Map is part of parking, not a separate authority. Add no owner, priority, or status, and keep each line within the persisted-evidence rules. Never park an idea the user turned down or dropped. A line leaves the list when the idea is committed, where ordinary commitment handling takes over, or when the user rejects it; remove it rather than replacing it with a rejected or abandoned line. Moving or removing a parked line is routine list maintenance, not the content deletion that needs approval. Before a Product Map exists, keep ideas in the conversation and follow the setup playbooks.

As evidence advances, make the smallest useful update:

- For a substantively discussed new system, add it to the Product Map and create its Product Spec at `idea`.
- For an existing-system change, update the evolving Product Spec with clearly labeled proposed or approved behavior and link the existing execution work.
- For technical-only work, update architecture or a targeted Engineering Reference only when the change creates durable, non-derivable knowledge.
- For no impact, create no documentation artifact beyond any parked idea line and, on first use, the Ideas page that holds it.

## Preserve lifecycle and product scope

Keep `idea`, `explored`, `accepted`, `implemented`, `merged`, `released`, and `retired` distinct. Never infer one from another. If an existing record uses `proposed` or `approved`, preserve its vocabulary while mapping it explicitly to the same evidence boundary.

- Code or tests can prove implementation, not approval or release.
- A pull request can prove a proposed source revision.
- A merge proves only that a revision reached its base branch.
- Mark behavior as released or shipped only after verifying the repository's actual release policy and release evidence. A merge is not a production release unless that policy proves it.

Attribute every lifecycle claim and Product Fact to its product. A shared component can have one canonical spec, but deployment, activation, rollback, availability, and claim scope advance separately for each consuming product. Evidence for one product never promotes another.

During active implementation, PR, delivery, or release work, maintain documentation impact, links among Tasks and PRs, the smallest relevant draft edits, provenance, and exact source revision. Promote shipped truth only after release verification. If evidence is missing, mark the claim stale or unverified and create or reuse documentation-debt work instead of guessing.

When product work needs a Task, reuse suitable existing work and follow the active kernel and server contract for its shape, hierarchy, and dependencies.

## Work with the other documentation skills

Product documentation owns product behavior, release truth, and Product Facts. Product marketing consumes Product Facts and owns ICP, positioning, pricing, campaigns, approved claims, and their messages. Company context owns business-level context and the Company Overview shell. Technical writing improves technical and user documentation without deciding its facts or evidence state.

For a pure marketing request, do not draft the output here. Load product marketing when it is available; otherwise name that owner and hand the request over without inventing copy.

When owned product truth changes, update this family's canonical records and identify every affected downstream output. Hand each external projection to its owner. If that skill is available, the same request authorizes the downstream edit, and its own gates are satisfied, load it and continue rather than leaving known stale text behind. Until projection assembly is automated, the skill changing an authoritative source may patch only its declared section of a shared Company Overview. Never use that narrow exception to take over another family's canon.

Product Facts are the operational seam: this skill produces and verifies them per product; product marketing consumes them and owns claims derived from them. A correction or rollback must leave the Fact-to-output dependency visible so affected messages can be reviewed without rewriting unrelated products or outputs.

## Keep human authority narrow and meaningful

Administer templates, folders, links, classifications, drafts, parked ideas, routine sync, and safe metadata or link repair without asking. Ask the user only for:

- material ambiguity in product intent or a significant system boundary;
- an unresolved conflict over which source is authoritative;
- a consequential decision not already handled by the normal product or repository review;
- deletion, irreversible overwrite, or another destructive consolidation;
- approval to publish externally.

Do not automatically publish user docs, release notes, Product Facts, or marketing copy. Before release, user-documentation and release-note drafts may use approved, implemented, or merged evidence only when they remain clearly labeled pre-release and cite the exact source revision. Draft Product Facts and marketing claims only from evidence meeting the exact-claim and state requirements above; claims of shipped or released behavior, or of software's current capabilities or availability, still require verified release evidence regardless of wording. Preserve every applicable review and publication gate.

## State the automation boundary honestly

This skill is workflow intelligence, not a background service. It can activate implicitly while an AI is running in a conversation, implementation or PR workflow, audit, or release sync. It cannot observe GitHub or update Octopad after the AI stops. Truly unattended event-driven updates require a separately installed and authorized Octopad/GitHub event or automation trigger. Never claim that installing this skill alone enables background synchronization.
