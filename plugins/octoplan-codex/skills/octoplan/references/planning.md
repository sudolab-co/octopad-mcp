# Octoplan Brief and Plan

Phases 1 to 3 confirm intent, review the smallest adequate Plan, and activate authorized Delivery. Drafts stay in conversation; durable truth lives in Octopad.

## Enter or resume

Read production Octopad, target state, and effective instructions; retrieve only material gaps.

If an `Octoplan 18 plan contract` still matches the confirmed Brief, reviewed task revisions, and authority, follow [codex-supervision.md](codex-supervision.md) without asking again. Without delivery authorization, refresh and show the Plan; activate a qualifying standing intent under the rule below or ask once. Changed outcome, proof, boundary, assumption, target, authority, protected effect, or user-owned consequence returns to Brief; changed graph, task meaning, route, verifier, deliverable, review trigger, disclosure wording or placement, checkpoint, or house-rule gate returns to Plan. Pre-v18 state uses [recovery.md](recovery.md).

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

After confirmation, persist one guarded `Octoplan 18 brief` Decision with those fields and its confirmation source. Any interpretation it fixes records the accepted reading, rejected reading, and countable success; reuse it only while material fields match.

## Phase 2: compose the Plan

Planning is overhead paid by the outcome. Persist one `Octoplan 18 stakes` Decision naming the decision served, blast radius, reversibility, countable success, kill question, and numeric ceilings for top-level tasks and total Plan-review rounds. A round covers the review floor; allow at most two without a user decision. Quote user requests for simplicity or efficiency; tighten both ceilings. Verify premises; use one stream per success definition and one top-level task per deliverable. Split only for owner, verifier, gate, dependency, or useful parallelism. Never exceed a ceiling silently: reduce, replan, or ask. Load [multi-stream.md](multi-stream.md) only when needed.

Map the full path's secrets without values, credentials, remote surfaces, permissions, effects, and human inputs. Preflight connectors, GitHub, CI, messaging, and deployment without effects; record readiness and human action; distinguish authority from credential entry. Never bypass a failed connector on its service. Give each unavailable remote surface one human-only access task; only its consumers depend on it. Independent work continues from authoritative sources. An unavailable code host blocks remote refresh, push, PRs, hosted CI or proof, not local-checkout reads, edits, or tests. Local versus remote never changes authority. The Plan uses the fixed banner, one line per step, and names each effect and rule-required wait with owner.

Before review, each entry is one independently executable effect with a bounded target. For qualified standing intent, quote words and source, classify every entry `covered` or `checkpoint` under [SKILL.md](../SKILL.md), and put the map in the Plan contract and display. Compound entries, generic assent, and ambiguity wait.

Checkpoints default to marking every disclosed protected effect, human step, and Plan landing. The planner may add points; the user may strike some at go.

```markdown
**Octoplan · Step 2 of 3 — Plan**

1. <step and observable result>
2. <step and observable result>

**Disclosed effects**
- <`covered` or `checkpoint` for standing intent> <one independently executable consequence, bounded target, and when it occurs>

**Human gates required by house rules**
- <subject and owner, or none>

**User checkpoints in Checkpoints mode**
- <subject and owner, or none>

**Recommendation**
<Full autonomy, Checkpoints, or Step-by-step, with one trade-off>

**Open questions**
- <unresolved follow-ups that do not change this Plan, or none>

**First ready work**
- <the first safe step and any independent branch that can start with it>

**Interruption level and authorization**
Full autonomy · Checkpoints · Step-by-step
<if the user is present, ask one choice; for a qualified standing intent, name its mode and source and state that Delivery starts after this Plan>
```

Offer this choice as one question when the user is present. A question that could change reviewed work, authority, effects, checkpoints, or gates makes the Plan `Not authorized for delivery` until resolved and reviewed. Disclose effective-rule waits as house-rule gates, not modes.

Planning-only permission never authorizes Delivery: label it `Not authorized for delivery`, create no Goal, and stop after persisting the reviewed graph. A later Delivery request refreshes sources, rules, review binding, and the Plan before its one choice.

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
<exact model and effort from codex-runtime.md, with reason>

**Review**
<targeted checks, fresh independent review, and any human reviewer required by effective rules>

**Octopad**
<yes or no, with reason: no when the spec alone does the job and no slot names Octopad, a page, or the task as a read or write surface>
```

Use the live schema. Top-level tasks require literal **Why**, **What**, **Done when**, `impact`, and `impact_rationale`; subtasks require **Why**, **What**, and impact fields. Every edge carries a rationale. Add `**Preconditions**` only for a live prior artifact or maturing event.

Write `How` as outcome and constraint. Prescribe a technique or precedent only when verified evidence makes it fit.

Plan only runnable `Verify` steps. Use the preflight access task when a remote surface is unavailable; a seat or UI only a person can exercise is a named human checkpoint, never verification.

Do not create tasks for reads, logins, tool calls, status, approvals, reviews, merges, or publications unless a person owns a distinct artifact. The only access exception is the single human-only task defined by preflight. Use subtasks for three or more internal steps. Consumed outputs need dependency edges. Give each user-facing text surface one final-wording owner.

Match proof to the deliverable and its real target. Source or test inspection cannot satisfy rendered-UI or live-API acceptance, and an aggregate cannot satisfy a no-regression decision:

- **Repository:** exact repository, base/head, changed surfaces, applicable checks, review state, and migration/backout evidence when relevant.
- **Content:** exact document revision, factual sources, audience, approval, and publication target.
- **Research:** exact question, retained source set, citation coverage, uncertainty, and synthesis revision.
- **Operations:** exact target, dry run, approval, execution receipt, and rollback evidence.

These are proof lenses, not another lifecycle system. For measurement, comparison, simulation, or synthetic proof, an outward-in reader blind to the rig's justifications builds a parity manifest from the real system, bound to raw JSONL, receipts, fixtures, and exact verifier revisions, and justifies the declared variable. Run a cheap rehearsal of every materially different verifier branch before expensive dispatch; failure blocks, and a material post-dispatch rig repair creates a new task. For measurement, comparison, visual proof, or research synthesis, review the upstream premise before the output with verdict `PASS`, `INPUT UNFIT`, or `INFEASIBLE`; the latter two stop dispatch and scoring, and downstream qualification cannot rescue the input.

## Phase 3: challenge and activate

Apply [SKILL.md](../SKILL.md). Materialize steps 1–3 before review so judgments bind exact task revisions. Two checklists from one reviewer are one judgment.

Give reviewers the Brief, task graph, Decisions, Questions, sources, effects, interruption semantics, and rules. For standing intent, include its exact quote and source plus the proposed atomic `covered` or `checkpoint` map. Each starts production Octopad, reads bounded context, and stays read-only.

Across the required lenses, attack mandate fidelity, upstream premise, missing work, simpler decomposition, dependencies, failure containment, consumers, proof, assumptions, route fit, effects, authority, and gates. Assign integration and conflict for broad parallel work, and distinct privacy, security, data loss, reversibility, permissions, spend, or public-effect lenses when triggered. One identity never impersonates two judgments.

Accept only `PASS`, `REVISE`, `INFEASIBLE`, or `HUMAN_DECISION`, with stable keyed findings, checks, evidence, and dispositions. Return stable fixes to the same reviewer. Do not exceed the stakes round ceiling: shrink or replan the graph, or get a user decision. Counts persist across identities; reviewers judge convergence. Material change gets the fresh applicable floor.

Draft one append-only `OCTOPLAN_PLAN_REVIEW` receipt per judgment with exact task IDs and `updated_at` revisions reviewed, Plan-contract Decision ID and `updated_at` reviewed, identities, lens, route, rules, verdict, round, findings, dispositions, checks, and evidence. A superseding review or authorization links, never overwrites, its predecessor. Apply [codex-runtime.md](codex-runtime.md).

Activation needs every applicable lens at PASS. Immediately confirm that every reviewed task still has the timestamp in current receipts; drift, a stale lens, or identity reuse at the two-review floor is unreviewed.

### Persist and hand off

Reread current Octopad schemas, target versions, and effective rules. After the Brief is confirmed:

1. create or adopt each work stream;
2. create the proposed tasks and dependency edges in the fewest coherent batch calls;
3. record material choices and open questions as Decisions and Questions;
4. record one `Octoplan 18 plan contract` Decision with Brief and stakes references, outcome and proof, task set and revisions, review triggers, access map, atomic effects, standing-intent source and coverage map if any, checkpoints, gates, safe branches, supervisor route, and `Not authorized for delivery` status;
5. run the review floor against that task set and Plan-contract revision; on PASS, persist every receipt and finding disposition;
6. define each user checkpoint and house-rule gate by subject and owner; persist the user's recorded continuation when it clears;
7. let Octopad project tracker progress; never mirror state into a Plan page, private control object, scheduler, or artifact ledger.

Apply F1 record integrity to every Decision, comment, receipt, Goal handoff, and report. A tracker is navigation, never evidence or authority: reconcile or disclose drift, and never let it override tasks, Decisions, receipts, Goals, or target state. After incomplete output, inspect only uncertain items and retry only what the authoritative target proves absent. Never replay a batch; guard updates with `expected_updated_at`.

Mark the stream ` (octoplanned)` only when graph, Decisions, Questions, and receipts exist. Confirm task and Plan-contract revisions against PASS receipts before showing the Plan, whose fields show open questions, gates, and first ready work.

For plan-and-deliver work, show the fixed Plan before Delivery. If the user is present, wait for one choice. If they chose a mode after confirming the Brief and then declared unavailability, show the Plan and activate without another reply; absence authorizes nothing. Copy only the unchanged reviewed per-effect map into an append-only `Octoplan 18 delivery authorization` Decision after its Plan-contract ID and `updated_at` match PASS receipts; any map or revision change needs focused review. Record reviewed task revisions, choice, authority delta including none, exact handoff reference, go source and time, standing-intent quote/source when used, activating Plan message, effect bounds, post-strike selected checkpoints, and house-rule gates. Drift refreshes the Brief or Plan and focused review; it requires a new go only under [SKILL.md](../SKILL.md).

Plan-only work stops without a Goal. For authorized Delivery, choose one supervisor and record it with its Goal in a guarded stream Decision. Continue here only with enough context to verify the run; otherwise use this handoff:

```text
Use $octoplan to resume delivery of <work stream>.
Octopad: <organization> / <workspace>. Delivery authorization is recorded in the stream Decisions; do not ask for it again.
```

The receiving task applies handoff acceptance from [recovery.md](recovery.md), confirms its predecessor stopped, then creates its one Goal. Never alter an unrelated Goal or ask for another go without an authority delta.
