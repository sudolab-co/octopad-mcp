# Octoplan Brief and Plan

Phases 1 to 3 confirm intent, review the smallest adequate Plan, and activate authorized Delivery. Drafts stay in conversation; durable truth lives in Octopad.

## Enter or resume

Read production Octopad, target state, and effective instructions; retrieve only material gaps.

Select the actual host profile from [SKILL.md](../SKILL.md). Read an existing Plan and its authority using that profile's compatibility rules; a release number does not invalidate a saved plan. If the confirmed Brief, review coverage, and mandate still hold, follow [supervision.md](supervision.md) without asking again. New plans use `Octoplan brief`, `Octoplan stakes`, `Octoplan plan contract`, `Octoplan delivery authorization`, and `Octoplan supervisor` Decisions. Continue valid legacy names on resume without duplicating the records.

A changed user outcome or foundational boundary returns to Brief. A changed graph, task meaning, route, verifier, deliverable, review trigger, disclosure, checkpoint, or gate returns affected work to Plan and focused review. Such a return does not itself withdraw authority. Ask only when the user owns a new consequence or a rule requires their decision. Unknown or unsupported saved state uses [recovery.md](recovery.md).

## Phase 1: confirm the Brief

Ask one natural question at a time only about expensive-to-change foundations. State reasonable assumptions; never make the user design implementation.

Every new or materially changed Brief gets an explicit playback. Start that message with the fixed banner and use this localized Markdown shape:

```markdown
**Octoplan · Step 1 of 3 — Brief**

**Purpose, audience, and ownership**
<why, for whom, and who owns consequence decisions>

**Outcome and proof**
<what must exist and how the user will know>

**Boundaries**
<in, out, and what must never break>

**Sources, constraints, and assumptions**
<only what can change the result>

**Known consequences**
<plain-language effects already visible, or none known yet>

**Confirm**
<one direct confirmation question>
```

Scale playback to the request. Never infer confirmation from invocation. Brief confirmation authorizes planning only, never Delivery or a protected effect.

After confirmation, persist one guarded Brief Decision with those fields and its confirmation source. Any interpretation it fixes records the accepted reading, rejected reading, and countable success; reuse it only while material fields match.

### Agree autonomy before detailing the Plan

For plan-and-deliver work, explain the known effects and boundaries, recommend **Full autonomy**, **Checkpoints**, or **Step-by-step** with one trade-off, and ask for the mode and mandate to prepare then deliver. Describe any real runtime limitation now. Reuse an explicit applicable choice already made after Brief confirmation; no repeated choice or absence condition. Record the answer's exact source and bounds in the delivery-authorization Decision as a standing mandate, pending Plan review. This is not an active Plan or permission for unknown effects. An optional native continuity feature is offered only when the chosen profile supports it and its own explicit-request conditions are met.

In Checkpoints mode, use the default set unless the user specifies adjustments; Step-by-step uses the agreed units shown in the Plan. Questions that affect the outcome or coverage must be resolved before dependent work. Optional asynchronous questions may accompany independent reads; elapsed time never supplies a required answer. Planning-only requests skip this choice and never launch delivery.

## Phase 2: compose the Plan

Planning is overhead paid by the outcome. Persist a compact stakes Decision naming the decision served, blast radius, reversibility, countable success, kill question, and any actual user limits. That Decision sizes everything after it (F15): a small reversible stream gets the one-review floor, a Verify slot with only the load-bearing checks, and no repair rounds beyond a same-reviewer recheck. Quote requests for simplicity or efficiency. Use one stream per independently verifiable local success definition and one top-level task per deliverable. Parallel tasks can stay in one stream; several related streams use the Delivery Map, interface and integration rules in [multi-stream.md](multi-stream.md). Put useful supervisor handoff seams in the existing sequencing rationale, not extra tasks or per-task token budgets. After two comparable review rounds without accepted progress, diagnose and simplify or change strategy; an internal planning estimate is not a reason to ask the user a technical question. Actual user limits remain binding across replans and identities. Load [multi-stream.md](multi-stream.md) only when needed.

Map the full path's secrets without values, credentials, remote surfaces, permissions, effects, and human inputs. Check the capacities and actual inputs that constrain this plan, including tool versions or automatic writers when they affect the result. Preflight connectors, GitHub, CI, messaging, and deployment without effects; record readiness and human action; distinguish authority from credential entry. Never bypass a failed connector on its service. Give each unavailable remote surface one human-only access task; only its consumers depend on it. Independent work continues from authoritative sources. An unavailable code host blocks remote refresh, push, PRs, hosted CI or proof, not local-checkout reads, edits, or tests. Local versus remote never changes authority. The Plan uses the fixed banner, one line per step, and names each effect and rule-required wait with owner.

Before review, distinguish each independently executable effect and bounded target. Compare it with the recorded mandate, quote its source, and classify it as covered, needing a new decision, or subject to a selected checkpoint or effective-rule gate. Use the Plan contract and owning tasks for this coverage; no extra register. Uncovered or ambiguous effects wait, while independent covered work may proceed after review. A task specification or chosen mode is never its own authorization source.

Checkpoints default to marking every disclosed protected effect, human step, and Plan landing. The planner may add points; the user may strike some at go.

```markdown
**Octoplan · Step 2 of 3 — Plan**

1. <step and observable result>
2. <step and observable result>

**Disclosed effects**
- <coverage or required decision> <one independently executable consequence, bounded target, and when it occurs>

**Human gates required by house rules**
- <subject and owner, or none>

**User checkpoints in Checkpoints mode**
- <subject and owner, or none>

**Open questions**
- <unresolved follow-ups that do not change this Plan, or none>

**First ready work**
- <the first safe step and any independent branch that can start with it>

**Autonomy and next action**
<recorded mode and its mandate; first supervisor launch, or the precise decision needed for an uncovered effect>
```

Showing this Plan does not require a second global go. A question that could change work, authority, or gates blocks its dependent scope until answered and reviewed; do not convert Full autonomy to Checkpoints to represent it. Disclose effective-rule waits with their owners.

Planning-only permission never authorizes Delivery: label it `Not authorized for delivery` and stop after persisting the reviewed graph. A later Delivery request refreshes sources, rules, review binding, and any missing choice before activation.

Every executable task carries:

```markdown
**Why**
<why this deliverable exists and what it builds on>

**What**
<one job, scope, and important non-goals>

**How**
<verified paths or sources, required outcome and constraint, edge cases, and only a precedent verified to fit this case>

**Verify**
<exact commands or checks available now, naming the real proof surface>

**Done when**
<accepted end state in the real system of record>

**Exec**
<exact model and effort from the selected runtime profile, with reason>

**Review**
<targeted checks, fresh independent review, and any human reviewer required by effective rules>

**Octopad**
<yes or no, with reason: no when the spec alone does the job and no slot names Octopad, a page, or the task as a read or write surface>
```

Use the live schema. Top-level tasks require literal **Why**, **What**, **Done when**, `impact`, and `impact_rationale`; subtasks require **Why**, **What**, and impact fields. Every edge carries a rationale. Add `**Preconditions**` only for a live prior artifact or maturing event.

Write `How` as outcome and constraint. Prescribe a technique or precedent only when verified evidence makes it fit. Prepare the task for an efficient capable worker: settled choices, precise sources, constraints, edge cases, expected output, and runnable acceptance checks, so the worker need not rediscover project decisions. Reference live inputs and predecessor outputs precisely; do not copy the whole project or invent details. Choose `Exec` from the judgment remaining after preparation. Plan review challenges sufficiency and route fit together. Extra planning, launches, and reviews also cost. A manual `Next` block is needed only when the selected runtime actually uses manual execution; valid saved blocks need not be removed.

Plan only runnable `Verify` steps. Use the preflight access task when a remote surface is unavailable; a seat or UI only a person can exercise is a named human checkpoint, never verification.

Design a defeat proof for each load-bearing check: name how it could pass while the claimed outcome is broken, then show that it does not. Match the method to the actual surface and stakes; a self-produced claim cannot verify itself. When tests can bypass a changed executable production path, require negative proof at the real call site: disable the relevant call, filter or write in an isolated scratch checkout, demonstrate that the relevant check fails, restore it and demonstrate that it passes. Choose the smallest set covering the material bypass risks, not one mutation for every path. For declarative configuration, CSS or static content, use a direct falsification on the real proof surface, such as demonstrating that a broken value or rendered state is detected; do not invent a call site. Every `Verify` slot names its proof surface and runnable check matched to `Done when`. Size this evidence to F15 without weakening required checks or accepting an irrelevant green result.

Do not create tasks for reads, logins, tool calls, status, approvals, reviews, merges, or publications unless a person owns a distinct artifact. The only access exception is the single human-only task defined by preflight. Use subtasks for three or more internal steps. Consumed outputs need dependency edges. Give each user-facing text surface one final-wording owner.

Match proof to the deliverable and its real target. Source or test inspection cannot satisfy rendered-UI or live-API acceptance, and an aggregate cannot satisfy a no-regression decision:

- **Repository:** exact repository, base/head, changed surfaces, applicable checks, review state, and migration/backout evidence when relevant.
- **Content:** exact document revision, factual sources, audience, approval, and publication target.
- **Research:** exact question, retained source set, citation coverage, uncertainty, and synthesis revision.
- **Operations:** exact target, dry run, approval, execution receipt, and rollback evidence.

These are proof lenses, not another lifecycle system. For measurement, comparison, simulation, or synthetic proof, an outward-in reader blind to the rig's justifications builds a parity manifest from the real system, bound to raw JSONL, receipts, fixtures, and exact verifier revisions, and justifies the declared variable. Run a cheap rehearsal of every materially different verifier branch before expensive dispatch; failure blocks, and a material post-dispatch rig repair creates a new task. For measurement, comparison, visual proof, or research synthesis, review the upstream premise before the output with verdict `PASS`, `INPUT UNFIT`, or `INFEASIBLE`; the latter two stop dispatch and scoring, and downstream qualification cannot rescue the input.

## Phase 3: challenge and activate

Apply [SKILL.md](../SKILL.md). Materialize steps 1–3 before review so judgments bind exact task revisions. Two checklists from one reviewer are one judgment.

Give reviewers the Brief, task graph, Decisions, Questions, sources, effects, interruption semantics, and rules, including the exact mandate quote, source, and effect coverage. Each reads the bounded current evidence and stays read-only. Missing production access cannot be presented as a completed live review.

Across the required lenses, attack mandate fidelity, upstream premise, missing work, simpler decomposition, dependencies, failure containment, consumers, proof, assumptions, route fit, effects, authority, and gates. Assign integration and conflict for broad parallel work, and distinct privacy, security, data loss, reversibility, permissions, spend, or public-effect lenses when triggered. One identity never impersonates two judgments.

Accept only `PASS`, `REVISE`, `INFEASIBLE`, or `HUMAN_DECISION`, with stable keyed findings, checks, evidence, and dispositions. Return stable fixes to the same reviewer. Repeated non-progress calls for diagnosis or a bounded planning repair; changing reviewer identity does not reset real limits. A verdict describes the reviewed artifact's validity, not whether all authorized diagnosis must stop. Material change gets the fresh applicable floor.

Receipts and contract fields that exceed what a Decision holds live on ONE contract page per stream, linked from the plan-contract Decision; that page carries authority, receipts, and repairs, never progress, and no second page is created for later receipts. Draft one append-only `OCTOPLAN_PLAN_REVIEW` receipt per judgment with exact task IDs and `updated_at` revisions reviewed, Plan-contract Decision ID and `updated_at` reviewed, identities, lens, route, rules, verdict, round, findings, dispositions, checks, and evidence. A superseding review or authorization links, never overwrites, its predecessor. Apply the selected runtime's route observation rule.

Activation needs every applicable lens at PASS. Confirm the current task and contract revisions against those receipts. A timestamp change requires reread: an evidenced status-only update does not revoke a content review or mandate; changed or unprovable content gets the affected recheck. Record the comparison and current revision. A stale judgment or identity reuse at the two-review floor is unreviewed.

### Persist and hand off

Reread current Octopad schemas, target versions, and effective rules. After the Brief is confirmed:

1. create or adopt each work stream;
2. create the proposed tasks and dependency edges in the fewest coherent batch calls;
3. record material choices and open questions as Decisions and Questions;
4. record a Plan-contract Decision with Brief and stakes references, outcome and proof, task set and revisions, review triggers, access map, effect coverage and mandate source, checkpoints, gates, safe branches, supervisor route, and `Awaiting review` status;
5. run the review floor against that task set and Plan-contract revision; on PASS, persist every receipt and finding disposition;
6. define each user checkpoint and house-rule gate by subject and owner; persist the user's recorded continuation when it clears;
7. let Octopad project tracker progress; never mirror state into a Plan page, private control object, scheduler, or artifact ledger.

Apply F1 record integrity to every Decision, comment, receipt, and handoff. A tracker provides navigation, not a competing progress record; reconcile drift without letting it override tasks, Decisions, receipts, or target state. A legacy Claude tracker may still hold the verified Brief confirmation described by its compatibility profile; preserve that source. After incomplete output, inspect uncertain items and retry only what the authoritative target proves absent. Never replay a batch; guard updates with `expected_updated_at`, and reread before every guarded write: Octopad advances a task's `updated_at` on its own after a write and when a dependency closes, with no text change, so a value copied from a write receipt or a handoff goes stale, and drift is judged by comparing content, never timestamps alone.

Before review, reread every executable task from Octopad (what was saved, not what you remember writing) and check: literal **Why**/**What**/**Done when** and impact fields; Exec, Review, and Octopad lines with their reasons; every protected effect named in plain consequence words; `How` names the specific files or sources, never "follow the existing pattern"; every claim measured this session (F16); every `Verify` slot with its proof surface and load-bearing checks with their risk- and surface-appropriate defeat proof; three or more internal steps as subtasks; one job per task; every gap a Question, a Decision, or a placeholder. Fix failures on the spot, then recheck the fixed task.

Mark the stream ` (octoplanned)` only when graph, Decisions, Questions, and receipts exist. Confirm task and Plan-contract revisions against PASS receipts before showing the Plan, whose fields show open questions, gates, and first ready work.

Show the reviewed Plan before Delivery. Bind the existing mandate to that exact Plan by appending an activation receipt in the delivery-authorization Decision after its contract ID and revision match PASS. Record task revisions, mode, exact mandate source/time, activating Plan message, effect bounds, selected checkpoints, and house-rule gates. This binding is the planner's evidence operation, not a new user approval. It cannot expand coverage. A changed coverage map needs focused review and only its actual consent delta. Keep earlier authorization evidence intact.

For authorized Delivery, launch the fresh supervisor or qualified disjoint supervisors selected by the reviewed topology through the actual runtime; confirm each creation and guarded ownership. Reserve capacity for task work and review before launching more supervisors. Planning and execution must not share a heavy inherited conversation. The original session becomes the runtime's lightweight relay; executors start only after activation. If the real environment cannot provide that route, use its declared manual fallback from [continuation.md](continuation.md). Report that limitation honestly: a saved handoff is not an active supervisor. Plan-only work creates no delivery actor or Goal. The receiving supervisor applies [recovery.md](recovery.md); the recorded mandate carries across the handoff.
