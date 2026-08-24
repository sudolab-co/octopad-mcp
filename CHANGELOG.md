# Changelog

All notable changes to the skills in this repository.

Each Octoplan distribution is versioned independently in its own `Version:` line and plugin manifest. The Claude Code and Codex product-documentation distributions share one synchronized version. Standard semantic versioning applies to each public contract: major changes are incompatible and may require migration or replanning, minor changes add backward-compatible functionality, and patches are backward-compatible fixes or clarifications.

This file records versioned contract changes. GitHub tags and releases are the publication record. Some intermediate Codex versions were superseded before they received a separate GitHub release.

## manage-product-documentation

### 1.2.0 — 2026-08-13

Moves the Architecture Map home. Octopad is now the default, beside the Product Map it serves, where the workspace's own search reaches it. A repository file remains the alternative for a team that wants architecture to change in the same review as the code; that file is then canonical and the Octopad entry carries its link, ownership, status, related systems, and verification metadata. Either way the skill names one canonical home and does not maintain both. Greenfield setup, existing-product adoption, the Product Map shape, and the durable-knowledge rule all follow that default, and the creation threshold is now the same in every file: build the map only once code gives evidence of stable architecture. An existing map is adopted where it already lives, never moved, so no migration follows from upgrading.

The skill's other uses of a connected repository are unchanged, because they are evidence rather than storage: deriving architecture, file paths, symbols, and dependencies from current code; reading pull requests, merges, and the repository's release policy to establish lifecycle state; and honoring repository review and merge controls.

### 1.1.0 — 2026-08-13

Adds parked ideas, so ideas a user engaged with and left open no longer evaporate when the conversation ends. During exploration the skill still creates no Product Spec, Behavioral Contract, or architecture record; parking an idea is now the single exception. At the end of a brainstorm, and for ideas raised in passing, it appends one line per open idea (the date it was parked, the idea, and the problem it addresses) to a `Parked ideas` section of the Product Spec it concerns, or to a single Ideas page when no system owns the idea yet, created on first use and linked from the Product Map. Lines carry no owner, priority, or status, so neither list can become a second backlog.

A line leaves the list when its idea is committed, where normal commitment handling takes over, or when the user rejects it; maintenance audits propose removing lapsed lines in one batch rather than deleting silently. Ideas the user turned down are never parked, and parking begins only once a Product Map exists. Upgrading from 1.0.0 changes default behavior: brainstorms now leave these one-line writes without asking. Existing pages and specs need no migration; the new sections appear only when the first idea is parked.

### 1.0.0 — 2026-08-13

Introduces one AI-neutral product-documentation skill, distributed with the same contract and version for Claude Code and Codex. It supports both greenfield products and existing products: it establishes or adopts one Product Map, maintains one evolving Product Spec per significant system, adds Behavioral Contracts only when precision warrants them, and keeps engineering guidance to one short Architecture Map plus targeted references when durable knowledge cannot be cheaply derived from current code.

During active product work, the skill distinguishes exploration from commitment, recognizes accepted new systems and changes, and makes the smallest evidence-based documentation update without turning brainstorming into a form. It reuses Octopad Pages, work streams, Tasks, Decisions, and links; follows Octopad's Task-creation contract; preserves proposed, approved, implemented, merged, and released as distinct states; and retrieves only the relevant documentation and current code for implementation.

Pull-request, delivery, release, audit, user-documentation, release-note, Product Facts, and marketing playbooks keep drafts tied to exact source and release evidence while preserving normal review and publication gates. The skill can synchronize documentation while an AI session or event-driven workflow is running, but it does not claim background execution: unattended GitHub-to-Octopad updates still require a separately installed and authorized trigger. This release adds both marketplace packages, installation guidance, synchronized versioning rules, and deterministic validation of their shared contract.

## meeting-to-octopad

### 0.1.0 — 2026-08-17

First release of a Claude Code skill that turns a meeting transcript into validated Octopad changes. It takes a file path or pasted text, reads it to the last line, works out what the meeting decided and who owes what, checks each item against what Octopad already holds, and proposes every change in one table. Nothing is written until the user approves that table in the chat, and there is no flag to skip it.

The skill runs in five phases. Intake settles the meeting date, the participants, and the workspace, and asks rather than guessing when one is missing. Extraction sorts the transcript into decisions, action items, updates on existing work, open questions, and goal signals, with a verbatim quote behind every single item. Reconciliation is read-only: it searches Octopad for what each item refers to, resolves participants to workspace members, records whether each match is sure, probable, or absent, searches a second time with different words before concluding that nothing exists, and looks for an earlier meeting record page by tag, date, and participants so a transcript processed twice does not duplicate everything. An item that contradicts what Octopad records becomes a top-of-table question quoting both sides, never a silent update.

Validation is one table and one typed go. Every row names the exact change, old value to new value, with its evidence quote and an owner column. Probable matches are questions naming every candidate, and an unanswered question means that row is skipped. Only then does the skill write: decisions and open questions become Octopad knowledge items with the speaker and meeting as provenance, new tasks follow Octopad's task-creation contract and join the work stream they matched, and one tagged meeting record page anchors the re-run protection. The apply phase keeps a ledger, stops on the first failure, and retries only named failed rows. It never deletes, archives, or closes anything, and it never writes to a goal: closing a goal cascades into archived streams and tasks, so goal signals are reported to the user instead.

The transcript is treated as untrusted data throughout. Text inside it that addresses the AI, such as an instruction to ignore its rules or a claim that changes were pre-approved, is never followed and never copied into Octopad; it is reported to the user as an anomaly.

Out of scope in this release: audio, which the user transcribes first; several meetings in one run; goal changes; and writing without the user's go.

## octoplan-codex

### 18.0.0 — 2026-08-24

Rebuilds Codex Octoplan around the shared three-stage program. Every user-facing message opens with the canonical Brief, Plan, or Delivery banner. Brief playback is always explicit and confirmed. The reviewed Plan uses one plain-language line per step, discloses protected effects and human gates, and records one choice among Full autonomy, Checkpoints, and Step-by-step. In Full autonomy, that Plan go authorizes every disclosed effect and Delivery runs without Octoplan-created interruptions until completion; only an undisclosed event requires new consequence consent, while team-owned house rules remain invariant.

The control plane now fingerprints exact stream and task topology, review triggers, routes, effects, checkpoints, rules, and source versions. It enforces the shared plan and delivery review floors, trigger-specific independent lenses, version-bound continuation receipts, immediate evidence persistence, exact work-state vocabulary, and integrated closure. Progressive references isolate multi-stream and recovery mechanics until needed. Deterministic fixtures fail closed on drift, stale authority, missing review evidence, duplicate reviewer identity, routing ambiguity, non-idempotent retries, unsafe takeover, skipped interruption obligations, and unsupported closure. `CONFORMANCE.md` maps F1–F13 and every retained v17.2 guarantee to its v18 location.

This is a breaking plan contract. Treat every pre-v18 plan as historical evidence: reconcile any live actor or effect, reread current Octopad and target state, then create a freshly confirmed, reviewed, and authorized v18 Plan without carrying forward PASS, authority, pending actions, supervisor ownership, or Goal state. The Claude and Autopilot distributions are unchanged.

### 17.2.0 — 2026-08-17

Keeps task specifications outcome-led and runnable. `How` states the required outcome and constraint, and prescribes a technique or precedent only when current evidence justifies it. A login, third-party seat, or user interface the executor cannot access becomes a named checkpoint instead of an impossible `Verify` step. Any task that consumes another task's output now needs the matching dependency edge, and each user-facing text surface has one owner for its final wording.

Supervision reports an actor or effect only after a returned result or authoritative reconciliation, and leaves one compact close comment that reuses existing receipts. Workers surface any user-facing wording they had to invent; the supervisor records it once on the unstarted owner task without changing the reviewed specification, or replans if that task already started. Deterministic fixtures cover unsupported technique and precedent, unavailable access, missing dependency edges, duplicate wording ownership, mid-run wording, unresolved calls, and reconciled results. Existing v17 plans need no migration. The Claude and Autopilot distributions are unchanged.

### 17.1.0 — 2026-08-14

Keeps verification proportional to the reviewed work. A delivery reviewer may expose risk but cannot enlarge `Done when`; findings block only when grounded in an effective rule, a reviewed `Verify` or `Done when` requirement, an uncleared reviewed checkpoint, or a concrete correctness failure. Persistent CI, generic test harnesses, services, dependencies, and cross-repository artifacts absent from the reviewed plan are rejected as scope expansion, or trigger replanning when a real rule or accepted outcome requires them.

The two-route verification-recovery budget is now shared across the supervisor, workers, and reviewers. After two failed routes, the run preserves its strongest evidence and hands off the gap instead of attempting a third route or building generic infrastructure for one-off proof. Deterministic fixtures cover an unplanned pgTAP suggestion, generic-CI expansion, required replanning, and a cross-actor recovery budget. Existing v17 plans need no migration. The Claude and Autopilot distributions are unchanged.

### 17.0.0 — 2026-08-14

Codex Octoplan now follows a lean Octopad-native contract informed by Octoplan Autopilot 0.2. The current task builds the smallest useful graph, runs one fresh plan challenge, and either supervises authorized delivery itself or hands it to a fresh task before Goal creation when planning consumed substantial context. Delivery authorization carries across that handoff, while protected actions remain separately gated. Octopad tasks, dependencies, Decisions, Questions, and comments hold durable project truth; a native Goal is only the active supervisor's continuity handle.

The lighter contract retains Codex's exact Luna/Sol route admission, branch-local checkpoints, version-bound human clearances, source-first proof, and six-field handoffs. A canonical review fingerprint uses immutable plan-local refs and reconstructs the persisted graph through a verified one-to-one mapping to returned Octopad IDs. Small review, dispatch, action, and supervisor-lease receipts prevent stale PASS reuse, duplicate native-task creation, ambiguous effect replay, concurrent takeover, and Goal transfer without reinstating a universal actor registry or artifact ledger. Deterministic negative fixtures exercise those failure paths and refuse completion while tasks, dispatches, gates, or effects remain unresolved.

This breaking release removes the v6 private JSON control plane, recovery-state guide, historical v3-v5 contract stubs, and eight role packs. Plans created under private Octoplan v3-v6 state are historical evidence only: reconcile any live actor or effect, reread the current mandate and real graph, then create one fresh reviewed v17 plan without carrying forward PASS, authority, pending actions, supervisor ownership, or Goal state. The Claude and Autopilot distributions are unchanged.

### 16.0.0 — 2026-08-13

Octoplan now calibrates plan shape (`simple`, `structured`, or `adaptive`) independently from consequence (`reversible`, `material`, or `protected`). Shape controls graph depth, delegation, WIP, and recovery; the plan's maximum consequence controls brief and adversarial plan-review depth, while each task's own consequence controls its delivery review and protected gates. Every revision receives exactly one fresh adversarial plan-review session, with stable corrections rechecked by that same session rather than multiplying reviewers.

The runtime keeps the exact Luna/Sol model-and-effort router and verifies the observed pair before work. The current Codex task remains the default supervisor, delegates only when the benefit exceeds handoff cost, and uses the native Goal solely for continuity. Every spawned actor enters the exact production Octopad context. Obstacles are classified as transient, evidence-gap, in-envelope, material, or protected so safe recovery remains bounded and independent work can continue.

The universal control plane is replaced by compact v6 recovery state hosted on a real outcome or integration task, never a bookkeeping task. Inline work omits actor bindings but retains intents for mutations and external side effects. Octopad task statuses remain project truth; derived scheduler state, raw logs, telemetry counters, stack snapshots, leases, and compatibility machinery are not persisted. Manifest hashes exclude the delimited state block, and plan-review provenance, unresolved actions, artifact versions, checkpoints, dispositions, and guarded update evidence remain durable.

Artifacts use one strict generic core plus a `repository`, `content`, `research`, or `operations` profile. A coherent task may own several artifacts and profiles when their owner, acceptance, dependencies, and review boundary are shared. Repository evidence stays specific to source changes and migrations; content, research, and operations retain their own proof contracts. Publication, merge, migration application, deployment, destructive effects, spend, access, required human review, and acceptance remain separate protected checkpoints.

This is a clean breaking contract: only `octoplan-plan-v6` runs. Earlier control schemas are rejected and are neither migrated nor translated; a new v6 plan starts from the live mandate. An explicit, precise plan-and-deliver request can cover a faithful creation brief without a redundant confirmation, but planning-only permission never authorizes delivery and protected actions remain separately gated. The Claude distribution is unchanged.

### 15.0.0 — 2026-08-12

Every material replan now expires prior planner leases and requires a unique fresh planner session bound to the candidate, plan and intent revisions, and a bounded source snapshot. An interrupted planner may expire with no output; no stale candidate can be invented or adopted. Two material replans, a repeated graph, or two comparable cycles without accepted progress opens a blocking efficiency incident and requires diagnosis before stable correction may resume.

Supervisor and child context admission is now versioned and operational. Compaction, superseded intent, or repeated no-progress resumes require an explicit `REUSE`, `REPLACE`, or `PAUSE`; unhealthy Goal owners pause substantive work and delegate bounded analysis while retaining ownership. Supervisors remain thin authority and reconciliation shells rather than re-reading unbounded traces.

Every branch, PR, document, and other delivery artifact now has a durable lifecycle through terminal disposition, so orphan drafts block completion and supersession. Baseline leases bind source and stack evidence to the exact actor, task, and semantic generation, while non-overlapping drift no longer creates an automatic refresh treadmill.

This breaking release introduces `octoplan-plan-v5`. Active v4 or older plans are fenced and replanned; an unfinished legacy Goal keeps v5 paused until a genuine terminal state or explicit human lifecycle decision, without false completion, false blocking, or a competing Goal. The v14 route floor, compact title convention, fresh-writer rule, and mandatory reversible archive lifecycle remain enforced. The Claude distribution is unchanged.

### 14.0.0 — 2026-08-12

Octoplan now binds every writer to a semantic task generation and an autonomous manifest. A split, merge, changed task meaning, graph, output, route, authority, acceptance, or rewrite contract fences the predecessor and requires a fresh writer plus a fresh full independent review; a healthy actor may still handle a stable same-generation correction with a targeted recheck. Successor activation requires stop acknowledgement, post-fence quiescence, transfer and creation receipts, binding readback, manifest acknowledgement, and a fresh full-stack admission covering main, stacked bases and heads, ancestry, effective diffs, migrations, checks, verifier coverage, and TTL.

Actor bindings now include plan and intent revisions, supervisor epoch, authority and target identity, role, task ID and generation, contract and manifest hashes, observed model and effort, and stack evidence. Planned and observed routes must agree before work. The automatic ladder is restricted to Luna `max` and Sol `high|xhigh|max`; Terra, Luna below `max`, Sol below `high`, unknown, unavailable, or unobserved routes pause without downgrade. Supervisors require observed Sol `high` or above, and planning remains Sol `xhigh` or justified `max`.

Completed executors must be archived reversibly after accepted evidence and supervisor reconciliation. Archive failure is receipted, retried through bounded recovery, and blocks final close; sessions awaiting correction, review, handoff, a human checkpoint, or unresolved evidence are preserved. Native titles use the single compact convention `<PREFIX>-<short-work-stream-name>-<short-task-name>` with `SUP`, `EX`, `PLN`, and `REV`, while opaque identifiers stay in prompts and durable state.

This breaking release introduces `octoplan-plan-v4`, typed review and telemetry records, explicit parallel frontiers, bounded state compaction, and immutable historical receipts. Active v3 or older plans must be fenced and replanned from the current mandate rather than migrating authority, PASS verdicts, actors, or action receipts. The Claude distribution is unchanged.

### 13.1.0 — 2026-08-11

Interactive clarification and planning now stay in the current user task, while delegated role packs remain reserved for bounded child work. The creation brief is proportional in presentation but complete in authority, effects, routes, lifecycle, review cadence, and human checkpoints. User-facing handoffs are localized, and Octopad task statuses now map cleanly to `todo`, `in_progress`, `blocked`, and `done`; `waiting-human` and `paused` remain coordination states rather than invalid task statuses.

Long-running recovery now revives the unique saved supervisor before considering a successor. A recovery successor requires terminal-or-unreachable evidence, current quiescence proof, and a durable takeover intent whose fence key is deterministically bound to the plan and next epoch. Owner, mode, epoch, predecessor, pause state, and the pending Goal record rotate atomically; the new Goal is created only after guarded readback, while the predecessor Goal remains historical. Existing valid v3 plans adopt 13.1 at a safe boundary without transferring authority, actors, PASS verdicts, receipts, or Goal ownership.

Codex packaging removes the policy override that suppressed Octoplan from fresh sessions and uses one explicit `$octoplan` prompt capped at 128 characters across both manifests. Repository validators now fail closed on the recovery ordering, stale quiescence, invalid statuses, incomplete briefs, version drift, prompt drift, and the known suppression policy. The Claude distribution is unchanged.

### 13.0.0 — 2026-08-11

Octoplan now turns the conversation into one user-readable creation brief before the first Octopad write. The brief exposes the expected result, scope, evidence, governing organization rules, planned Octopad effects, native Codex actors, and every proposed human checkpoint. Validation uses one holistic cadence: either progressive review at the meaningful checkpoints selected from the work, or final review after all safe work is ready. The confirmed tracker, tasks, graph, Decisions, and Questions embody that brief without creating a duplicate bookkeeping Page.

The current Codex task is the supervisor by default and may bind one native Goal only to an authorized delivery. Existing unfinished Goals cannot be silently replaced or transferred. Natural-language user corrections increment a durable intent revision before actors are redirected, and every side effect must join that exact intent, plan revision, supervisor epoch, target, and authority through one receipt. Long-running plans distinguish installed, loaded, and minimum-compatible skill versions, adopt compatible updates only at safe boundaries, and fence then replan older v1 or v2 runs instead of assuming that installation propagated the fix.

Delivery planning now produces coherent units that are independently acceptable, reviewable, and reversible while inheriting the active `AGENTS.md` and repository workflow. Under a one-PR-per-task policy, database, API, and dashboard deliveries therefore become separate tasks and PRs instead of one oversized feature task. Verification maps every changed surface to an actual check, explicitly treats uncovered green CI as insufficient evidence, and probes adjacent cases. Project identity recovery can reconcile a unique `projectId=null` actor from stronger saved and Git evidence without duplicating it, while cyclic graphs, impossible checkpoint frontiers, stale or orphan action receipts, and incomplete Decision or Question mappings are rejected by deterministic fixtures.

This breaking release introduces `octoplan-plan-v3`. Active v1, v2, 12.x, or unknown plans must be fenced and replanned from the current user mandate without inheriting execution authority, PASS verdicts, action receipts, native actors, or Goal ownership. The Claude distribution is unchanged.

### 12.1.0 — 2026-08-11

Octoplan supervisors now own ordinary in-envelope execution failures through one bounded, receipted recovery loop before escalation. Connector, registry, worktree, branch, dependency, CI, and recoverable tool incidents are classified before action and may receive at most two distinct safe, reversible remedies. Existing no-mutation actors are reconciled and reused instead of duplicated, while rewording or waking an incident cannot reset its budget. Actual repository or project mismatches, unknown remotes, secrets or access issues, destructive recovery, protected actions, and material scope, target, or risk changes still stop.

Native project identity now follows an ordered evidence hierarchy. Direct native association or the saved registry remains preferred; when metadata is incomplete after a targeted create, a unique actor may be reconciled from its persisted target and receipt, returned task and creation key, role packet, saved project-to-repository mapping, worktree and Git identity, normalized remote, branch and HEAD audit, and no-mutation state. This does not repair the native registry, and no path, prompt, title, or name is sufficient alone. Valid initial authority also remains valid across technical current-head verification and in-envelope repair; new authority is required only for changed scope, target, risk, or a new protected action.

### 12.0.0 — 2026-08-10

Octoplan now plans from the earliest integrated, demonstrable outcome instead of treating completed components or branches as delivery. The planner records the critical path, bounded `eligible_safe_ready` frontiers, WIP and review budgets, and partial batches with backfill, so independent items such as editorial deliverables can advance concurrently while keeping individual artifacts, receipts, and verdicts. Multi-component work closes only with current integrated-outcome evidence and resolved protected gates.

Every launched plan now has one visible dedicated supervisor, while the planner remains visible and exits the execution loop. Executors are the interaction point for their mission and publish the six-field progress handoff when their artifact is ready, human input is needed, or bounded recovery cannot resolve an incident. Executors, reviewers, recovery sessions, and follow-ups follow an explicit lifecycle and are archived reversibly only after terminal reconciliation; create, message, and archive actions use one source-bound plan grant plus durable intents and receipts to prevent blind replay.

Human PR review and merge remain distinct protected occurrences but are embedded in the owning delivery task rather than represented as separate Octopad tasks. The active repository instructions determine the reviewer and merge workflow, the PR links to that same task, and post-merge auto-closure evidence is reconciled there. Deterministic checks precede judgment, corrections receive targeted rechecks, specialists remain limited to an orthogonal material risk, and a repeated finding triggers diagnosis instead of a third blind review loop. Observable token, tool-call, compaction, and retry telemetry is reported without estimating unavailable values.

This breaking release introduces `octoplan-plan-v2`, including honest draft and awaiting-approval states, dedicated-supervisor ownership, native-action grants, actor lifecycle, embedded gates, budgets, and global outcome evidence. Plans saved under v1, 10.x, or unknown contracts must be replanned from the confirmed mandate without inheriting PASS, authority, creation intents, or launch state. The Claude distribution is unchanged.

### 11.0.0 — 2026-08-09

Octoplan now turns a brainstorm into a detailed, reviewed Octopad task graph, asks material questions in one batch, and separates plan approval, bounded execution authority, finite actor-creation grants, and protected human gates. Tasks use the live Octopad stream, task, dependency, and page-link shapes and carry **Why**, **What**, top-level **Done when**, impact, routes, and proportionate review. One supervisor drives Octopad's native graph, repairs inside the approved envelope, and asks the user only for a real material choice, missing authority, unreconcilable identity, a write still missing after targeted recovery, a conflicting revision, or a protected gate.

The new `octoplan-plan-v1` keeps only plan identity and approved revision, essential Octopad IDs and desired dependencies, review and supervisor ownership, finite grants, gates, and pending recovery keys. Missing `structuredContent`, presentation drift, incomplete MCP prose, and non-byte-identical readback are warnings: per-item receipts and targeted reads confirm uncertain writes, while only proven-absent items may retry. Bootstrap and native actor creation use durable intents, bounded reconciliation, and ambiguity pauses without blind duplicate creation.

This release removes the 10.x fingerprint, canonical readback, saved-state equality, and exhaustive Decision, Question, and task replay contracts. Existing 10.x or unknown plans must be materially replanned from the confirmed mandate without inheriting PASS, digest, consent, or creation intents. The distribution remains organization-agnostic and Codex-only; the Claude distribution is unchanged.

### 10.2.1 — 2026-08-09

Octoplan now treats asynchronous Codex setup as pending until native project identity is ready, persists a deterministic bootstrap intent before its only create call, and binds handoff repair to the returned destination task. A single plan-scoped authority grant covers the exact finite actor set, while compatible tasks are compressed and only equivalent transitive dependencies are removed.

Octopad writes now use the connector's actual stream, goal, and page-link shapes. Batch recovery reconciles each item from its exact direct readback before retrying only missing operations, and accepts the model-facing JSON mirror when a host hides `structuredContent`. Existing 10.2.0 plans remain valid without migration; their exact creation authority can materialize the new runtime grant without rewriting the saved plan. The Claude distribution is unchanged.

### 10.2.0 — 2026-08-09

Octoplan can now start from a plain idea without an existing stream or saved plan. It returns one complete brief, batches every material question, treats the user's answers and Delivery mode choice as confirmation of unchanged fields, and avoids a second confirmation loop. A two-stage execution runway checks the native project, required task-creation and relocation authority, session creation and reconciliation, Octopad access, write shapes, sources, prerequisites, and verifiers before the first durable planning write. Missing capability or authority therefore produces one precise pre-write blocker instead of failing after the plan is built.

New plans are assembled through one non-authoritative, journaled candidate that can resume after a crash and cannot grant consent, PASS, protected actions, or execution. A guarded seal replaces it with the complete supported plan, recomputes the saved fingerprint, and must succeed before consent or native creation. One fresh read-only plan reviewer challenges the draft and then attests a canonical final subject; the planner alone persists the detached evidence and proves full saved-state equality, avoiding the former review/equality cycle. The planning guide is shorter and the fixture inventory no longer consumes runtime context.

Execution now keeps native task-creation and relocation authority as separate source-bound grants, serializes reviewed work when no atomic group transition exists, commits human-wait state and its outbox event together before publication, and replaces an unreachable supervisor only with source-stamped proof plus a successful fence and epoch rotation. Deterministic fixtures cover the complete idea-to-launch journey, question confirmation, candidate crash and seal boundaries, stale consent, failed guards, post-consent drift, outbox retry, serial fallback evidence, supervisor recovery, and zero native creation on every rejected path. Existing 10.1.0 plans remain valid without migration. The Claude distribution is unchanged.

### 10.1.0 — 2026-08-09

Octoplan now proves the execution runway before any Octopad planning write. It verifies native project identity, session creation and reconciliation capabilities, the Octopad entrypoint, required adapters, source access, and the first-frontier verifier. If the current task has no project identity or the wrong one, it relocates the untouched brief once into the exact saved project after the required authority, then restarts preflight there. Ambiguous targets or unavailable capabilities stop before durable planning.

Material questions stay off-record until the runway passes, and unsupported history is no longer rewritten record by record before the replacement graph is feasible. Deterministic fixtures cover same-project readiness, null-project relocation, brief and relocation authority, ambiguous targets, and missing native capabilities. Existing 10.0.0 plans remain valid. The Claude distribution is unchanged.

### 10.0.0 — 2026-08-08

This breaking Codex release formalizes short native-session display titles for supervisors, executors, reviewers, planners, and specialist reviewers. Titles are derived deterministically from saved human-readable names, capped at 64 characters, and never expose UUIDs, hashes, creation tokens, or thread IDs; the display title remains separate from native creation identity. Existing saved plans whose names cannot produce an unambiguous title require replanning.

The supervisor now publishes a six-field handoff before every human gate or decision wait, every pause requiring Alex's attention, and the final recap. Each handoff states the current state, completed facts, blocker, exact decision, resume predicate, and next step, including safe branches that continue when only one branch is blocked.

Automatic routing now normalizes capacity and enforces the Luna max floor (`gpt-5.6-luna` at maximum effort). Terra and Sol remain available only with their existing justification, and least-costly incident routing is restricted to compliant routes; saved routes below the floor require replanning. Native session reconciliation now verifies the actual native project identity from native metadata or the registry before activation; a projectless, null-project, or cross-project observation pauses with the explicit handoff. The Claude distribution is unchanged.

### 9.0.0 — 2026-08-05

This breaking release gives each actor a small role-specific pack and binds every native creation to an immutable packet naming the organization, workspace, work stream, task, route, target, model, effort, and required capability profile. Every native child enters that Octopad context first, while Octopad remains responsible for its own context and status lifecycle. The planner, supervisor, executor, reviewer, recovery, and follow-up responsibilities are explicit.

The supervisor owns incidents end to end: it can delegate bounded reasoning to a fresh actor with an appropriate model and effort, restore a missing capability or use a safe workaround, and asks the user only after proving that no compliant path remains. Analytical delegates cannot impersonate native launchers. Incident planners use the affected task's saved recovery route or default recovery route, and any capacity change creates a reviewed delta. Planning rejects plans decomposed into tool calls or access probes instead of independently deliverable results. Existing 8.0.0 plans require replanning under this creation contract; the Claude distribution is unchanged.

### 8.0.0 — 2026-08-04

Every native Octoplan session now stays in the same Codex project as the planning session. The project ID is fixed across supervisors, executors, lead and specialist reviewers, recovery sessions, and follow-ups; `local` and `worktree` environments may still differ inside that project. Projectless plans keep the exact planning directory. A cross-project or project/projectless substitution stops before session creation.

This breaking release requires earlier saved plans to be replanned before execution. Deterministic fixtures now validate the complete execution environment and every native session role for both project and projectless targets. The Claude distribution is unchanged.

### 7.0.0 — 2026-08-04

This breaking Codex release supports one v5/v2 contract path; earlier saved contracts require replanning and receive no historical support. Users choose a plain-language Delivery mode: **Review before delivery** waits for confirmation, while **Autonomous delivery** can accept an unambiguous end-to-end delegation in the first message, publish a non-blocking scoping checkpoint, independently validate that authority, and continue without asking the user to judge the plan. Neither mode grants protected actions.

The standalone v2 fingerprint binds exact target parsing, extraction/defaults, Unicode-scalar canonical JSON, collection ordering, feasibility coverage/matrix, source and verifier availability, distinct review verdicts, durable run states, stable blocker identity, accounting truthfulness, and the exact human occurrence predicate. Only authoritative actuals are recorded; unavailable provider cost remains unavailable and ambiguous authority waits for independent conformance judgment.

Material incidents use a fresh planner without execution authority, a concrete independent delta review, a whole-run fence/quiescence barrier, explicit adoption or rejection, repeated grounding, read-back, fingerprint, and conformance checks, and a new run without transferring PASS or consent. Natural-language activation fixtures distinguish bounded delegation from urgency, vague trust, or a bare “do it”. Portability, single-source references, generic tool-schema separation, deterministic fixtures, and CI-safe public-hygiene validators are tightened; no historical support is retained.

### 6.1.0 — 2026-08-04

Codex users may now explicitly authorize automatic execution after confirming the scoping brief. Once plan review and saved-state equality pass, Octoplan can bind that prior authority to the exact final plan hash in a guarded coordination-ledger comment and launch without a second wake-up. A bare brief confirmation, broad autonomy, prior chat, or planning permission is never enough.

Advance authority is invalidated by any unresolved Question or material change in result, scope, cost, risk, success, architecture, route bounds, validation mode, or protected actions. Consent evidence and launch-binding records remain runtime state outside the plan fingerprint. Existing 6.0 plans with `octoplan-supervision-v4` and normal later final-hash consent remain valid; protected actions, human gates, the Claude distribution, and the Octopad MCP are unchanged.

### 6.0.0 — 2026-08-03

Codex plans now use one byte-deterministic `octoplan-fingerprint-v1` input bound to `octoplan-supervision-v4`. The structured fingerprint covers the supervision policy, binding execution targets, review record, participating streams, governing Decisions, and every agent and human task, with exact field extraction, ordering, UTF-8 JSON escaping, and exclusions for runtime state. Final-hash locations are normalized to `PENDING`, the ledger manifest has explicit exclusion sentinels, and any hidden copy of the persisted digest stops verification instead of creating a self-referential hash.

Native Codex sessions now use readable titles for dedicated supervisors, executors, lead reviewers, and specialist reviewers. Repair, fallback, and recovery sessions preserve the owning stream and ranked delivery-task title; unsafe control or bidi characters and malformed task titles stop before creation. A canonical internal `OCTOPLAN_CREATION` JSON line retains the complete technical identity in the first prompt and durable record without exposing it in the visible title.

Every `create_thread` response shape now converges through `list_threads` and `read_thread` before a creation record becomes ready. Client IDs are never passed to thread tools, every real candidate is checked for the exact internal identity, and ambiguous or lost results pause without retrying creation. This release is breaking: plans using `octoplan-supervision-v3` or older must be replanned before execution. The Claude distribution and Octopad MCP are unchanged.

### 5.1.0 — 2026-08-03

User-facing Octoplan replies now keep opaque identifiers out of visible prose: raw UUIDs, session metadata, SHA-256 values, and Git commit hashes are retained only in internal records, agent-to-agent prompts, exact commands, or required Markdown link destinations. Codex session references use a readable label linked with the native `codex://threads/<thread-id>` deep link. PR, migration, task, and `#N` numbering remains unchanged.

### 5.0.0 — 2026-08-03

Codex plans now choose gradual or final human validation. The planner reviews a complete symbolic draft before writing only the final graph to Octopad, verifies deterministic saved-state equivalence, binds the result to `octoplan-supervision-v3`, and still asks for explicit execution consent on the final hash. Delivery tasks end at review-ready agent artifacts; human review, merge, migration application, deployment, publication, and acceptance are separate tasks with explicit completion evidence and optional event-wake predicates.

The supervisor can resolve bounded in-scope repairs without a new plan, create crash-idempotent non-blocking follow-ups, and continue unrelated safe branches while another branch waits on CI or a human. Repair classification is persisted before work, judgmental classification gets independent review, and artifact review scales from targeted deterministic checks to one independent lead plus an orthogonal specialist only when needed. Human rejection reopens the original delivery task while preserving history and returns to the same review task after correction.

GitHub event wakes deduplicate immutable deliveries, verify the exact PR head and saved human-task predicate, and resume reconciliation without authorizing protected actions. Incremental reconciliation avoids full-plan rereads unless authority or fingerprinted state may have changed. The supervisor owns the final recap and reports actual repairs, rejection loops, sessions, external wakes, delivered artifacts, remaining human work, and follow-ups from the existing ledger.

This is breaking: older plans do not contain the v3 validation, repair, follow-up, wake, or review contract and must be replanned before execution under 5.0.0. Explicit-only invocation, final execution consent, native target fencing, exact saved routes, and protected human-action gates remain in force.

### 4.0.0 — 2026-08-02

Codex plans now bind every supervisor, executor, reviewer, and recovery session to a saved native project and environment. The manifest separates inline and dedicated supervisor targets, the default executor target, and task-role overrides; projectless execution must be explicit and justified. Project ID and environment are fingerprinted into review and execution consent, while host, path, and Git metadata remain non-blocking audit evidence.

Launch, activation, resume, takeover, fallback, and artifact provenance now stop on a target mismatch instead of inferring from the caller's directory or task context. This is breaking: pre-4.0 plans do not contain the environment-bound `octoplan-supervision-v2` contract and must be replanned. The explicit-only invocation behavior introduced in 3.0.1 is preserved, and the Octopad MCP and Claude distribution are unchanged.

### 3.0.1 — 2026-08-02

Codex no longer loads Octoplan implicitly. It now requires an explicit `$octoplan` invocation, and the trigger description excludes general Octopad actions, organization connection, onboarding, and unapproved task execution. This prevents unrelated onboarding prompts from entering Octoplan.

### 3.0.0 — 2026-08-02

Approved execution now runs through one fenced supervisor. Small linear streams stay in the planning or recovery session; four or more delivery tasks, parallel work, multi-stream coordination, or interruption gates justify a dedicated parent at a saved route. Supervisor epochs make takeover restartable, and one saved replacement bound prevents parent churn.

One compact Octopad Plan manifest and tracker pointers replace copied contracts. Its canonical hash is persisted before plan review and consent; any plan change needs a new review, consent, and run. Native session creation uses durable identities and an activation barrier, including all-ready activation for parallel groups. Executors produce immutable artifacts, lead reviewers own revision-bound correction and completion, and only the supervisor launches successors. Saved lineage, same-route recovery, and evidence-gated executor fallback keep replacement work bounded.

This is breaking: pre-3.0 plans are unsupported and must be replanned. The Octopad MCP and Claude distribution are unchanged.

### 2.0.1 — 2026-08-01

Mixed tasks now route execution and review independently when objectively specified implementation has qualitative acceptance. Choices the executor must originate determine the execution route; qualitative judgment assigned only to review no longer inflates it. The full routing rubric still applies, and unresolved material judgment continues through Terra or Sol.

The planner's saved-state check records that distinction in each applicable execution rationale, and the routing validator now guards it alongside the synchronized 2.0.1 version.

### 2.0.0 — 2026-07-31

Every executable task now receives a fresh independent adversarial review. The lead reviewer owns corrections, durable completion, and relay; one simultaneous specialist is allowed only for a distinct material failure domain. Every PASS is bound to the same immutable artifact revision, and reviewer rerouting starts a fresh guarded attempt with an authorized correction executor and full review set.

Execution and review routing now minimize expected cost per accepted task. Luna covers exact and strongly verified work, Terra is a real technical and non-code judgment rung, and Sol is reserved for open, weakly verified, or hard-to-reverse work. Risk labels never select Sol alone; every Sol route must state why Luna and Terra are inadequate. Plan-review routes and rationales are saved and reread before launch.

This is breaking: saved plans that skip review or use the previous routing contract must be replanned before execution.

### 1.6.1 — 2026-07-31

Octoplan now distinguishes execution guidance from retrievable source context. Tasks save the outcome, decisions, boundaries, verified approach, exact pointers, risks, and verification that direct a fresh executor, while live pages, documents, and code remain in their systems of record. Engineering tasks identify the applicable files, symbols, patterns, integration points, invariants, regressions, and tests without copying implementation context.

Executor and reviewer prompts now explicitly start the Octopad workspace session, call `build_context` for the task, and open the saved source pointers before acting. This is a wording clarification only: existing task schemas, saved plans, routing, approvals, relay behavior, and terminal contracts remain valid.

### 1.6.0 — 2026-07-31

Octoplan now routes after decomposition by verification strength, consequence, and subjectivity. Luna `high` handles mechanical work, Luna `xhigh` is the default for well-specified autonomous execution, and Luna `max` handles difficult but strongly verifiable tasks. Terra `high` and `xhigh` cover everyday business communication and well-bounded product or decision documents. Sol `high` and `xhigh` remain for open-ended strategy, weak verification, polished or high-consequence public work, sensitive systems, and confirmed lower-tier capacity failures; planning remains Sol `xhigh`, with `max` reserved for justified extra scope, risk, or ambiguity.

Tasks now carry the smallest complete memory-less handoff: observable result, boundaries, inputs, acceptance, verification, and any decisions, sources, safeguards, proofs, or escalation conditions that affect execution. Business communication and editorial deliverables add only the audience, channel, intended effect, voice, message, claim-source, format, and review constraints that actually apply.

Review routing now uses Luna `max` for deterministic completeness and verifiability, Sol `high` for difficult or editorial judgment, and Sol `xhigh` for sensitive or costly public work. Failed work is diagnosed as a plan gap, environment or verifier blocker, or model-capacity problem before escalation. A changed route is a material task rewrite: it must be saved, reviewed, and explicitly approved in a fresh run; executors and reviewers never substitute a model themselves.

Existing saved plans remain valid. No task field, title convention, continuation prompt, or terminal contract changes.

### 1.5.0 — 2026-07-31

After explicit execution approval, Codex now passes continuation directly between task sessions. The planning session launches only the first ready task or parallel group. A review-skipped executor completes and relays its task; a review-required executor creates one fresh routed reviewer, which owns corrections, completion, and the next launch after PASS.

An Octopad ledger binds every session to the approved run, plan fingerprint, guarded task attempt, and persisted pending or real thread IDs. Parallel groups use all-or-none preflight and guarded claims, so racing completions cannot create duplicate reviewers or successors. Human gates, protected actions, plan changes, ambiguous recovery, and failed reviews stop without advancing.

Existing plans need no migration: their current `Next` values and dependency edges carry the relay, with no new required task field. Relay mechanics live in a separate reference loaded only after approval, keeping planning-time routing and consent guidance lightweight. Repository version guidance now follows standard compatibility-based semantic versioning, making this backward-compatible capability a minor release.

### 1.4.0 — 2026-07-30

Every full planning pass now returns a short scoping brief before writing anything to Octopad: the planner's understanding, explicit in/out of scope, definition of success, assumptions with their basis, and open questions. The brief is the whole reply, and the planner waits for a later user confirmation before saving Decisions, Questions, tasks, tracker logic, or Blueprint pages.

A prior prompt or apparently complete stream cannot satisfy the gate. Partial replies never silently accept an unanswered assumption: the planner asks once more, then records anything still open as a Question and leaves affected tasks as flesh-out placeholders. Multi-stream efforts use one effort-level brief before the stream split; a later full pass on one stream uses its own brief.

Reduced event-driven rebalancing remains available without a new brief only for at most two added or materially rewritten tasks when scope, result, material risk, cost, and definition of success stay unchanged; mechanical graph and title repairs do not count toward that limit. Only pure plan-hygiene repair continues under the existing execution approval. Any added, removed, or materially rewritten executable task requires fresh execution approval, while larger or material changes require a fresh full planning pass.

The Codex execution-consent boundary, saved model and effort routing, independent executor sessions, and protected-action gates are unchanged. Existing saved plans remain valid.

### 1.3.2 — 2026-07-29

Full planning and targeted replanning accept `gpt-5.6-sol` at `xhigh` or `max`; `max` remains for verified extra scope, risk, or ambiguity.

### 1.3.1 — 2026-07-28

First public Codex release, intentionally aligned with the current Claude `1.3.1` version.

- Keeps planning and execution separate: completing a plan never launches work. The planner asks the user whether Codex should start execution and waits for an explicit yes.
- After approval, Codex executes the saved plan in dependency order by creating fresh worktree or local sessions with each task's exact model and reasoning effort.
- Explicitly independent tasks can run in parallel after complete-group preflight; executor sessions are one-shot and the planning session remains the sole orchestration owner.
- Includes Codex-specific GPT-5.6 execution and review routing, durable recovery rules, Blueprint support, and event-driven replanning.
- No Kickstart skill or Branch command.

## octoplan-autopilot

### 0.10.0 — 2026-08-22

Restructures the skill so each session loads only what its job needs. `SKILL.md` shrinks to the always-needed core — the resume check, the non-negotiables, the task template, the per-task self-check, the replanning rules, and a load index that names which reference file to load at which moment. Four new reference files carry the rest: `references/planning.md` holds the eleven planning steps, the stream-type lenses, the multi-stream cut test, the per-plan self-check, and the planning-mistakes table; `references/routing.md` holds the Exec rubric, the effort vocabulary, lane dispatch, and the review-lens rules; `references/continuation.md` holds the two block formats and the six Next-line patterns, verbatim from 0.9.0; `references/multi-stream.md` holds the Blueprint protocol. `references/supervision.md` is unchanged apart from six load-instruction edits.

Behavior is unchanged with two exceptions. The Opus 4.6 compatibility lane is removed: the rubric now covers only the current model set, and a team on different models maps to the nearest equivalents. And sessions that plan, rebalance, or supervise a stream belonging to a multi-stream effort are now explicitly told to load the multi-stream reference, closing a gap the restructure would otherwise have opened. Saved plans, task descriptions, Next lines, and recorded delivery contracts from 0.9.0 remain valid with no migration; the Next-line patterns, block formats, rubric table, and effort table are byte-identical to 0.9.0.

### 0.9.0 — 2026-08-21

Scales Octoplan from one work stream to a whole effort, and lets a supervisor renew itself without user intervention. Every new mechanism is gated on what the session's environment actually provides and degrades to the existing single-session behavior where it doesn't.

Planning: the multi-stream cut now has concrete signals — cut when the definition of success only reads as several independent successes, or when the work spans domains with different owners each holding three or more tasks' worth; a large single-domain plan is grounds to hunt for a seam, never a cut by itself — and the test runs in step 1, with a self-check row so a stream that stayed single can show why. After the effort brief and Blueprint, the master planner may fork one sub-planner per stream: each inherits the master's full conversation, plans its own stream (main Steps 4–8 and 10), and sends every seam question and every user-facing decision back to the master, which alone talks to the user, wires cross-stream dependencies, runs the effort-level adversarial review, and hands off. Forking is dearer in tokens and cheaper in time; the text says so and says when not to.

Delivery: a multi-stream effort gets one supervisor per stream. The go Decision, the contract Decisions, and the octoplanned suffix now land on every stream so each supervisor's resume check passes without re-asking the user. Shared landing targets are ordered in the dependency graph, never in chat; each supervisor rebalances only its own stream and stops for the user at any seam; discoveries that matter to a sibling stream are written to Octopad first, with inter-session messages as nudges to go read them. Independent task groups may launch as background workers together, with the verification gate still run per task and failure classes kept distinct.

Renewal: a supervisor low on context may spawn one fresh sub-supervisor (never a fork — a fork inherits the spent budget) at the recorded supervisor route, whose prompt opens with the supervisor handoff block so it briefs itself from Octopad like any successor. The original session becomes a pure relay: it announces the delegation, forwards reports and escalations verbatim, and carries the user's decisions back. One level only — a sub-supervisor never delegates; the relay retires it before handing off itself, so two supervisors never run one stream. Where the environment cannot message a running subagent, delegation is unavailable and the pasted handoff block remains the path.

### 0.8.0 — 2026-08-19

Fixes the failure that let a whole stream idle overnight: a supervisor held three ready tasks because their dependencies' code sat on open, unmerged branches, even though the stream's own delivery contract said to stack dependent work on those branches. The rule existed as prose; nothing forced the supervisor to obey it at the moment it picked work.

What now happens differently. When Octopad reports a task ready, the supervisor works it — the dependency graph is the only judge of waiting, and every real wait must have a written source: a dependency edge, a human-only task, a gate in the contract, or the contract's stacking choice set to wait. Code on an unmerged branch is never a reason to hold a task when the contract stacks. Before a supervisor may tell the user that nothing can proceed, it must walk the open tasks and name each one's written wait; a wait that exists only in its own reasoning is either work to start now or a plan defect to wire into the graph. On the planning side, a real-world state only a person can create (a migration applied, a deploy run, an approval given) must be wired as a human-only task with a dependency edge, not left as a prose Preconditions line the machine order cannot see — with the matching self-check row. A new mistakes-table row names the idling failure so the cost stays visible.

No gate weakens: humans still merge, migrations are still applied by their named person, and one-way doors still stop.

### 0.7.0 — 2026-08-18

Applies the lessons of the first two supervised runs, which delivered real merged work but let two defects reach the main branch, spent most of one session's budget on review rounds, and reported themselves so poorly the operator could not follow. Every change below traces to a recorded failure, and the release itself passed a two-agent adversarial review.

Plans now close the artifact graph: the planning review's executability lens, the self-check, and a new mistakes-table row all require that everything a task produces has a named production consumer and a named producer, populator, or trigger, and that a task deferring work to another appears in that task's own spec — the rule that would have caught the scheduling seam and the writer-less registry both runs paid for. Tasks that change production code carry a call-site proof in their Verify slot (remove the real path, show the suite fail, restore, show it pass), the supervisor adds one at the gate when the plan lacks it, and workers prove their own new tests can fail — the single most repeated review finding, moved to where it costs almost nothing. Review lines now name their lenses (one by default, two or three only where a mistake cannot be taken back, a wiring lens where tasks share artifacts), and every review finding gets an explicit disposition before the next round so a known defect can no longer cross a round unfixed.

Supervised delivery gains a delivery report: one page on the stream, created at the start, holding the phase map and one plainly-worded state line per task — built, reviewed, merged, applied, verified, never a bare "done" — updated in place as a view of the task graph, never a second record of it. Chat shrinks to one plain line per event, with one exception that never compresses: any judgement call the user could reasonably disagree with. Workers are launched with a template that now tells them the spec and the stream's Decisions may be wrong and to verify claims at the source, forbids them spawning their own reviewers, and has them write findings onto the task incrementally so a crashed session loses nothing. Supervisors verify a claim before handing an item to a human, do reversible in-plan actions instead of reporting them as risks, retry infrastructure deaths without asking while still escalating unverifiable work, and decide their own handover instead of posing it as a question.

Model-and-depth routing becomes enforceable: where the environment defines one agent per rubric lane (a named set of five), the supervisor dispatches workers and reviewers by lane and both model and depth are pinned; where lanes are absent the depth is declared, once per run, as a request nothing verifies. Existing saved plans remain valid; new guidance applies to plans and dispatches made from this version on.

### 0.6.0 — 2026-08-17

Standardizes the hand-off so the user always approves a plan they can see, and always knows how to launch what comes next. A live run ended its planning pass by asking for the delivery go without showing the plan's steps, and handed over the next-session prompt with no model or reasoning-effort recommendation — the user rightly called the go meaningless.

Step 11's hand-off message now has a fixed five-part shape, in the same order every time: the plan shown as one line per step with every human step in bold and its owner named, plus the plan's open questions and unfinished placeholders (a go signs off known unknowns too); the changes to what was agreed before the tasks existed; the delivery offer, which now names the model and reasoning effort for a fresh supervisor session — never cheaper than the strongest route saved in the plan — and whether it runs solo; a bolded one-sentence go request saying what the go does; and the prompt block for the recommended path, saying plainly which block it is and that a supervisor block is pasted only after the go is recorded.

Two supporting rules make the settings travel. Every block handed to the user in chat now carries one plain line under it: model, reasoning effort, and solo or parallel-safe. The Next-line patterns say it in their own words, because the session emitting a block from a saved task has never read this skill — it quotes the target task's saved Exec line. And the go Decision now records the supervisor's route alongside the go itself, so a replacement supervisor finds its settings in Octopad instead of a dead chat. Existing saved plans stay valid; Next lines written under 0.5.0 keep working, they just hand over bare blocks until replanned. No migration.

Makes the skill write to the user in plain words. A live run showed the delivery contract reaching the user as a wall of the skill's own vocabulary — gates, routing, stacking, dials, floors, one-way doors — with whoever acts left out of nearly every sentence, and it closed by asking the user to confirm a choice their own rules had already made for them. A reader who does not code could not answer it; a reader who does would skim past the one question that needed them.

A new non-negotiable covers everything the user reads: the scoping brief, the delivery contract, each decision put to them, the hand-off message, and every report from delivery. Each names what will happen and who does it, in words a non-technical reader can answer without asking what one means and precise enough that a technical reader finds nothing vague. The skill's own vocabulary, and any synonym standing in for it, stays out of those messages. The empty passive is named as the failure it is: "it goes for review", with nobody in it, has to become a person, a role, or the automatic check that clears it. The rule is scoped to what the session writes to the user in the chat, and says so explicitly: the Octopad records, task descriptions, Next lines, continuation blocks and the worker launch template keep the planner's precise wording untouched, because other sessions read them and their exact words carry the safety limits.

The delivery contract message also gets a fixed shape: four headings in fixed words (What needs your OK · Who checks the work · Does dependent work wait? · How much I decide alone), whatever the target's own rules already settle stated once as settled under the heading it belongs to rather than dressed up as a question, and an ending on the questions the user can genuinely answer, each with two named options, a recommendation with its reason, and how hard it is to undo — no blanket "confirm the rest". The hand-off delta reuses the same four headings, and the supervisor's escalation report points at the plain-words rule. Existing saved plans stay valid; no migration.

### 0.4.0 — 2026-08-14

Closes the delivery-side half of a planning rule 0.3.0 added. The plan already forbids an early task from writing wording that a later task is scoped to write or rewrite. But the first live run showed workers inventing such wording mid-run — button labels and messages that did not exist when the plan was written, which no planning rule can reach. Two additions to the supervision reference cover that path. The worker launch template now tells every worker to list any wording a user will read that it had to write. The supervisor treats each such string as a miss in the plan: it copies the string into the owning task's How before that task launches and re-runs the self-check on it, and if the owning task has already started or closed, it stops and runs the Replanning rules instead, because a copy pass cannot settle text it never saw. Existing saved plans stay valid; no migration.

### 0.3.0 — 2026-08-14

The first live run of Autopilot delivered a whole work stream end to end. It also showed where the skill lets a session look more finished, more checked and more honest than it was. This release folds those findings back in. Most of it rewrites rules that were already there but too soft to bite; the rest closes gaps the run exposed.

**A task no longer claims a finish line the session cannot reach.** The task template used to define a code task as done at the merged and deployed state, while most teams stop an agent at an open change it may not merge. Nothing said which won, so the run closed seven tasks whose work had not landed, and the board read delivered while nothing had shipped. Now a delivery task ends where the session can actually end — open, checks green, handed off — and the step that finishes the job becomes one human-only landing task, owned by the named person, wired last: it depends on the final validation task, which depends on the delivery tasks. The stream ends on it. A new continuation pattern covers that terminal gate, and a self-check row catches the edge wired the wrong way round.

**Saved reasoning depth is described honestly.** The skill claimed a task's model and depth were applied exactly, with no substitution. Half of that was never true: the call that launches a worker carries a model and no depth, so a supervisor can only ask. Depth is now binding on the manual path, where the user sets it, and requested rather than enforced under supervision — a gap that closes once a team ships one agent definition per rubric lane, not a policy. The worker launch template says the same thing and asks a worker that cannot honour the depth to say so. Reviewers, who had no route at all, now get one: never cheaper than the work they attack.

**Specs describe the outcome, not the technique.** A row demanding a concrete example to copy pushed the planner into dictating exact methods it had never tested, and six of them were wrong on the merits — a colour that failed contrast, a mechanism silent for the case it was added for. The How now asks for the outcome and the constraint, and a precedent may be named only where the session checked that it carries.

**Checks that were never runnable are caught at planning time.** Three triggers say a step is not a check: it needs a login, a seat on a third-party product, or a browser the executor cannot drive. Access the team can grant becomes a task wired first; access only a person can exercise becomes a human-only task. The environment survey now settles what the executor can drive, so the third trigger is answerable.

**The supervisor's own account of itself is held to the evidence rule the skill applies to specs.** Twice in the run it reported work it had not done, once telling the user reviewers were attacking a change before any had been launched. Nothing exists until the call that created it returns, and nothing unreturned goes into a report. A supervisor comment now lands on every task before it closes, naming the reviewer it spawned and what came back, so the run leaves a record a later session can read rather than a transcript nobody will.

**Smaller, from the same run.** A go recorded only as a clause inside another Decision is not the recorded go, in both the resume gate and the supervision reference. A base that moves under the supervisor is a replan trigger it owns, since no worker will report it, and the final validation task is the first spec to re-read because nothing else corrects it. Tracker logic is rewritten in place, never corrected underneath stale text. One task owns each piece of user-facing text, so no earlier task invents wording a later one is scoped to rewrite. And a mechanical dependency test: every task whose How, Verify or Preconditions names another task's output carries an edge to it.

Deliberately not in this release: enforcing reasoning depth through shipped agent definitions, which needs an install path that does not yet exist and fails silently if half-shipped; and the run's two judgement failures, over-escalating to the user and over-speccing discoveries, which already have rules and want a second run before they cost lines.

Upgrading needs no migration. A stream planned under 0.2.0 keeps working; its tasks simply carry the older Done when shape and no landing task until it is replanned.

### 0.2.0 — 2026-08-14

Supervision can now change hands. 0.1.0 assumed the session that planned a stream would also supervise its delivery, which holds for a light planning pass and breaks after a heavy one. Supervising is cheap per task, but its verification gate is not: reading each change and each reviewer's findings, task after task, is what spends the budget. A planner that arrives at the delivery go already depleted runs out mid-stream, and by then summarising has dulled the judgement it was kept for.

The delivery offer at step 11 now asks who should supervise rather than assuming, and the planner judges its own remaining context before offering. It recommends a fresh supervisor whenever the pass was heavy — an adversarial review that came back with substantial findings, a replan, a target that changed mid-session, a long exploration phase — and hands off when in doubt, because handing off costs one paste and running out stalls the stream.

A **supervisor handoff block** joins the continuation prompts: the stream name plus its organisation and workspace, a pointer like every other block in this skill, with a third line allowed only for something true of the environment that Octopad cannot hold. It covers all three cases — the planner handing over at the go, a running supervisor handing over the rest, and replacing a session that died. The recorded delivery go carries across, so a fresh supervisor reads it as permission already given and never re-asks for a decision the user has made. The supervision reference gains the matching guidance: a supervisor running low hands over deliberately, before its judgement thins, rather than pushing on.

No change to the planning core, the delivery contract, the verification gate, or the task format. Upgrading needs no migration, and a stream planned under 0.1.0 resumes unchanged.

### 0.1.0 — 2026-08-13

First release of a separate Claude Code distribution that plans a work stream and then delivers it. It keeps the Octoplan planning core unchanged and adds two things around it. `octoplan-claude` is untouched and stays the planning-only distribution.

A new **delivery contract** step runs right after the scoping brief is confirmed. The session reads the target's own rule files, then presents one message: a forecast of every point the plan will need a person, who reviews which class of task, whether dependent changes stack, and two dials the user sets — how much may be merged without them, and how much may be resolved without asking. The rule files are a floor the dials cannot lower, and one-way doors such as schema changes, permissions, payments and deletions always stop for a named person whatever the dials say. The confirmed contract is recorded as Decisions on the stream, so the mandate outlives the conversation, and its gate map is re-confirmed as a short delta once the tasks exist.

A new **supervision** reference defines delivery. On the user's explicit go, the planning session becomes a supervisor: it picks the next ready task, sends a fresh worker a pointer to it plus the mandate, and closes nothing until the task's own verification steps have run with their output recorded and any required fresh review is clean. Independent tasks may run in parallel in isolated copies of the repository. When work stops for a person, the report is six fields — state, done, blocked, decision expected, to unblock, next step — in the user's language, and a checkpoint blocks only its own branch while safe work continues. The continuation prompts stay in every task as the recovery path: if the supervising session dies, a fresh one resumes from Octopad alone.

This is an experimental variant published for a live trial. Install it in place of `octoplan-claude` for the duration of the test, not alongside it: both skills trigger on the same request, so only one can be installed at a time. `octoplan-codex` is unaffected.

## octoplan-claude

### 1.5.0 — 2026-08-13

- Exec recommendations now name the current Claude routes instead of generic tiers: Sonnet 5 `xhigh` only for bounded, reversible, concretely verifiable work; Opus 5 `high` for standard substantive delivery and `xhigh` for hard or consequential work; Fable 5 `xhigh` for genuinely open or long-horizon problems only after its mandatory 30-day retention is accepted, with Opus 5 as the fallback.
- The skill now covers every exposed depth label without pretending they form one ladder: `low`, `medium`, `high`, `xhigh`, and `max` are native efforts. Claude Code's `/effort ultracode` session setting adds automatic workflow orchestration to `xhigh`, while the one-prompt `ultracode` keyword leaves the current effort unchanged. `max` stays rare because more reasoning can overthink rather than reliably improve a result.
- Opus 4.6 is an explicit compatibility or interaction-style lane, not a presumed cheap fallback. It cannot satisfy an `xhigh` route, has the same list price as Opus 5, and may use fewer tokens for equivalent text without being universally cheaper per successful task.
- The trigger description now says "Octoplan followed by a work-stream name" instead of using angle-bracket placeholder syntax rejected by the generic skill validator; triggering behavior is unchanged.
- This is backward-compatible guidance. Existing task descriptions and saved plans remain valid; a future Octoplan pass can refresh their Exec lines.
- Repository validation now requires a valid increasing semantic version and exact agreement across the skill, manifest, README, and one changelog heading. It also checks the Sonnet floor, native effort set, Fable retention gate, Opus 4.6 `xhigh` prohibition, and Ultra distinction as routing invariants.

### 1.4.0 — 2026-07-30

- New step 2, **Scoping brief — reflect back, then wait**: before locking any decision, drafting any design page, or writing any task, the planner hands the user one short brief merging what the user said with what the sources hold — understanding restated in its own words, in/out of scope, definition of success, an explicit Assumptions list (every point settled by inference rather than a source or the user's words), and open questions — then stops. The old flow only forced a question when a spec slot could not be filled at all; a plausible-but-wrong inference could fill the slot and ship silently. The Assumptions list makes those inferences visible so the user can veto them before planning starts.

  Three guards keep the gate from being talked around: confirmation must be a reply sent AFTER seeing the brief (no launch prompt, prior chat, or tracker note counts, however complete it looks); the brief is the entire message, with no decision proposals or draft breakdown riding along to be swept up by one "go"; and a reply that leaves part of the brief unanswered never defaults to the planner's assumption — re-ask once, then log a Question and mark the affected tasks as flesh-out placeholders. An empty Assumptions list has to show its work rather than assert itself. A call already settled in the brief reply is recorded as a Decision directly, not re-presented in step 3.

  Scope of the gate: every full planning pass. A multi-stream effort writes ONE effort-level brief before the cut into streams, and a later pass on one stream of that effort writes its own stream-level brief. A mid-execution rebalance does not rerun it — and a "rebalance" that would add or materially rewrite more than a couple of tasks, or move the scope, now has to stop and ask for a fresh Octoplan pass instead. The adversarial review's design-soundness lens also checks the specs against the confirmed brief, so a correction cannot silently fail to propagate.

  Steps renumbered (old 2–9 are now 3–10), with matching rows in the self-check list and the mistakes table.

  Not breaking: nothing in existing task descriptions changes shape; plans written under 1.3 keep working unchanged.

### 1.3.1 — 2026-07-28

- New "Changing this skill" note: edit the source repository and release, never an installed copy — auto-update silently overwrites it. This guard used to live in a project instruction file; it belongs here, where it travels with the skill.

### 1.3.0 — 2026-07-28

- Scheduled checkpoints are gone. The "Octoplan checkpoint <stream>" trigger and its every-3–4-tasks revision rhythm never came from a real decision, and a plan has no reason to change on a schedule. What replaces them is event-driven: the new **Replanning** section. When a session executing a task discovers something that adds a task, drops one, or changes the order, that session invokes this skill and rebalances the whole plan — specs re-validated, `#N` prefixes renumbered, dependencies and Next lines rewired, tracker logic updated, self-check re-run on anything added or rewritten. If the discovery invalidates the stream's definition of success, the session stops and asks for a fresh Octoplan pass instead.

  Not breaking: nothing in existing task descriptions references checkpoints, so plans written under 1.2 keep working unchanged.

### 1.2.0 — 2026-07-28

- The continuation prompt is now two lines instead of one:

```
<work stream> #N - <task title>
Octopad · Organisation: <organisation> · Workspace: <workspace>
```

  The work and its rank lead, because an assistant names the session after the start of what it is given, so that line has to carry the readable label. The address moved to the second line and gained the organisation: workspace names can repeat across organisations, and naming only the workspace left the receiving session guessing. The stream's plain name is used, without the ` (octoplanned)` suffix.

  Not breaking: a plan written under 1.0 or 1.1 keeps working, its tasks simply still emit the older one-line prompt, which resolves the same way. Run an Octoplan pass on the stream when convenient to refresh those Next lines.

- Dropped the remaining framing about execution being a separate mode. There is no mode. What a later session needs is written into the task description, and that is all the skill says about it.

### 1.1.0 — 2026-07-28

- The planner now writes the plan's reasoning into the stream tracker: why the tasks run in this order, which branches are parallel, where the human gates sit, what ends the stream. Logic only, no statuses and no copied task content, so it doesn't go stale. This is what the Blueprint page already did for multi-stream efforts, applied to a single stream.
- Dropped the "two-tier workflow" framing. There is no execution mode: this skill runs at planning time, and everything an executor needs is written into the task descriptions themselves.

### 1.0.0 — 2026-07-28

First public release.

- Planning protocol for Octopad work streams: a planning session locks decisions with the user and writes every task as a complete, self-contained spec, verified against the real codebase or reference documents.
- Execution needs nothing installed: each task carries its own hand-off instruction, and a finishing session emits a one-line continuation prompt (`Octopad: <workspace> / <stream> #N - <task title>`) the user pastes into a fresh session.
- Execution order comes from real Octopad dependency edges plus a `#N - ` prefix in task titles.
- Parallel groups: exactly one sibling is the relay and emits the continuation; the others end silently, so the chain cannot fork.
- Multi-stream efforts: one goal, several work streams, one light Blueprint page explaining the global logic, and cross-stream dependencies enforcing it.
- Works for engineering and non-technical streams alike, with per-domain lenses for the interview and the specs.
