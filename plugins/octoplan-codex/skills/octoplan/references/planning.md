# Octoplan Brief and Plan

Use phases 1 to 3 to confirm intent, compose and review the smallest adequate Plan, and activate only authorized Delivery. Drafts stay in conversation; confirmed intent, graph, authority, and evidence live in Octopad.

## Enter or resume

Start production Octopad and read the live methodology, tool schemas, named work, dependencies, Decisions, Questions, linked sources, target state, and effective instructions. Retrieve only material gaps.

If an `Octoplan 18 plan contract` has the same confirmed brief, an exact current fingerprint, a valid supervisor fence, and delivery authority that still covers the work, follow [codex-supervision.md](codex-supervision.md) without asking again. If the same confirmed brief has a reviewed Plan but no delivery authorization, refresh the Plan and ask only its interruption-level go. A material change to outcome, proof, boundaries, assumptions, protected effects, authority, or target starts a new Brief. For any pre-v18 plan or private control object, read [recovery.md](recovery.md).

## Phase 1: confirm the Brief

Ask one natural-language question at a time, only about expensive-to-change foundations: purpose, audience, outcome, proof, boundaries, unacceptable outcomes, constraints, ownership, and known consequences. State reasonable assumptions; never make the user design technical or cosmetic choices.

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

Keep the playback to two lines plus a one-word confirmation when that fully captures a bounded request. Never skip the playback or infer confirmation from the invocation. Brief confirmation authorizes planning only. It never authorizes delivery or a protected effect.

After confirmation, persist one `Octoplan 18 brief` Decision containing purpose, audience, ownership, outcome and proof, boundaries, sources, constraints, assumptions, known consequences, confirmation source, and a normalized fingerprint. Use guarded revisions. Reuse it only while material fields match.

## Phase 2: compose the Plan

Build the first integrated result, not a catalog. Verify material premises at source and reuse work that owns the outcome. Use one stream for one success definition; load [multi-stream.md](multi-stream.md) only for independently closable parts, distinct targets or gates, parallel ownership, or separate cadences. Use one top-level task per acceptable deliverable. Split only for a different owner, verifier, gate, dependency, or useful parallel path. Keep one small task inline.

The final Plan starts with the fixed banner. Use one plain-language line per step; disclose every protected effect and rule-required human wait with its consequence and owner. Never ask the user to judge technical implementation.

```markdown
**Octoplan · Step 2 of 3 — Plan**

1. <step and observable result>
2. <step and observable result>

**Disclosed effects**
- <plain consequence, bounded target, and when it occurs>

**Human gates required by house rules**
- <owner, exact wait, and evidence that resumes it, or none>

**User checkpoints in Checkpoints mode**
- <name, consequence, owner, blocked work, exact subject/version or future binding rule, continuation evidence, and invalidation rule; or none>

**Recommendation**
<Full autonomy, Checkpoints, or Step-by-step, with one trade-off>

**Open questions**
- <unresolved follow-ups that do not change this Plan, or none>

**First ready work**
- <the first safe step and any independent branch that can start with it>

**Choose the interruption level and authorize this disclosed Plan:**
Full autonomy · Checkpoints · Step-by-step
```

Offer this choice in the conversation, not a settings screen. Do not offer or accept a Plan go while an open question can change the fingerprint, authority, effects, user checkpoints, or house-rule gates; label that Plan `Not authorized for delivery`, resolve the question, and review the resulting state first. For a plan-and-deliver mandate, that one choice is the Plan go. It authorizes every disclosed effect at the stated bound. Full autonomy adds no mid-delivery approval for those effects and reports when done. Effective rules can still route a named action to a person or require later exact evidence; disclose that as a house-rule gate, not as a mode. Any effect, outcome change, or authority need absent from the Plan remains unauthorized.

Planning-only permission never authorizes delivery. In that case label the Plan `Not authorized for delivery`, do not present the choice as a go, create no Goal or lease, and stop after persisting the reviewed graph. When delivery is later requested, refresh sources and rules, revalidate the review binding, show the current Plan, and ask the one interruption-level question.

Every executable task carries:

```markdown
**Plan ref**
<stable plan-local ref such as E01>

**Why**
<why this deliverable exists and what it builds on>

**What**
<one job, scope, and important non-goals>

**How**
<verified paths or sources, required outcome and constraint, edge cases, and only a precedent verified to fit this case>

**Verify**
<exact commands or concrete checks available now>

**Done when**
<accepted end state in the real system of record>

**Exec**
<exact model and effort from codex-runtime.md, with reason>

**Review**
<targeted checks, fresh independent review, and any human reviewer required by effective rules>
```

Use the live task schema. Top-level tasks require literal **Why**, **What**, and **Done when** sections plus `impact` and `impact_rationale`; subtasks require **Why** and **What** plus their impact fields. Every dependency edge carries a rationale. Add `**Preconditions**` only when a prior artifact must be live or a dated event must mature.

Write `How` as the required outcome and constraint. Prescribe a technique only when a verified trap makes it necessary, and say why; name a precedent only when current evidence shows it fits this case.

Plan only `Verify` steps the executor can run now. A required login, third-party seat, or UI the executor cannot drive is a named access or human checkpoint with an owner and evidence, not a `Verify` step.

Do not create tasks for reads, logins, ordinary tool calls, progress reports, approvals, reviews, merges, or publications. Keep those as steps or protected checkpoints unless a person owns a distinct artifact. Use subtasks only as a checklist for three or more internal steps inside one deliverable. If `How`, `Verify`, or `Preconditions` consumes another task's output, add its dependency edge with a rationale. Give each user-facing text surface one task that owns its final wording; earlier tasks supply standards or constraints, not draft text for that task to rewrite.

Match proof to the deliverable:

- **Repository:** exact repository, base/head, changed surfaces, applicable checks, review state, and migration/backout evidence when relevant.
- **Content:** exact document revision, factual sources, audience, approval, and publication target.
- **Research:** exact question, retained source set, citation coverage, uncertainty, and synthesis revision.
- **Operations:** exact target, dry run, approval, execution receipt, and rollback evidence.

These are proof lenses, not persistent artifact profiles or a second lifecycle system. Effective repository, privacy, security, legal, and publication rules may add stricter proof.

## Phase 3: challenge and activate

Set the floor before review. A Plan below every high-risk trigger gets one fresh independent read-only reviewer. A Plan with eight or more tasks, or touching schema, permissions, money, privacy, or destructive operations, gets at least two independent reviewer judgments with distinct primary lenses. One reviewer applying two checklists does not satisfy the higher floor.

Give each reviewer the confirmed Brief, complete draft task text and dependency graph, applicable Decisions and Questions, real sources, protected-effect inventory, interruption semantics, and effective rules. Each reviewer starts a production Octopad session, reads the exact bounded context, and makes no write or authority decision.

Across the required lens set, attack mandate fidelity, missing work or decisions, simpler decomposition, dependencies, artifact consumers and triggers, executable proof, hidden assumptions, route fit, disclosed effects, authority, and human gates. Assign integration and conflict as a primary lens for broad parallel work. Assign privacy, security, data loss, reversibility, permissions, spend, and public effect as distinct primary lenses where triggered. Scale checks inside each review without using one identity to impersonate two independent judgments.

Accept only `PASS`, `REVISE`, `INFEASIBLE`, or `HUMAN_DECISION`, with stable finding keys, checks, evidence, and a disposition for every finding: fixed; deferred with authority and rationale; or dismissed with evidence. Apply stable fixes and return them to the same reviewer for a targeted recheck of that lens. A change to outcome, scope, stream/task graph or membership, task meaning, authority, route, proof, review trigger, disclosed effect, user checkpoint, or house-rule gate is a material replan and receives the newly applicable fresh review floor.

Fingerprint the review subject as SHA-256 over one normalized, ordered packet: confirmed Brief fingerprint; exact stable stream refs, definitions, targets, ownership, task refs, titles, descriptions, and stream membership; dependency edges expressed by plan ref with rationales; material Decisions and Questions; the three interruption options and their semantics; review-floor triggers; disclosed effects; user checkpoints; house-rule gates; routes; target/source versions; and effective-rules snapshot. Server-generated stream/task IDs, statuses, assignees, timestamps, and the later user choice are excluded. Persist one `OCTOPLAN_PLAN_REVIEW` receipt per independent judgment with the fingerprint, distinct reviewer-task identity, primary lens, observed route and availability, exact source/rules snapshot, verdict, explicit findings and dispositions set, checks, and evidence. A stable targeted recheck records the corrected fingerprint and same reviewer identity.

Activation requires the complete applicable lens set at PASS on one fingerprint. Immediately before activation, reconstruct the packet from the persisted graph by mapping returned task IDs through their unique `**Plan ref**` fields, then require an exact match to every current PASS receipt. A missing, duplicate, or changed mapping, stale lens, identity reuse at the two-review floor, or content drift is unreviewed.

### Persist and hand off

Immediately before writing, reread current Octopad schemas, target versions, and effective rules. Persist only after the Brief is confirmed and the complete applicable plan-review floor is PASS:

1. create or adopt each work stream and assign it an immutable plan-local ref in the plan contract;
2. create the reviewed tasks, their stable plan refs, and dependency edges in the fewest coherent batch calls;
3. record material choices and open questions as Decisions and Questions;
4. persist every `OCTOPLAN_PLAN_REVIEW` receipt and finding disposition;
5. record one `Octoplan 18 plan contract` Decision containing the Brief reference, outcome and proof, topology, canonical fingerprint recipe, review-floor triggers, review-receipt set, disclosed-effect map, user-checkpoint map, house-rule gates, safe parallel branches, supervisor route, and activation status;
6. define each user checkpoint with exact subject/version or future binding rule, owner, blocked descendants, required continuation evidence, and an invalidation rule;
7. define each house-rule gate with the same exact binding, owner, blocked descendants, required evidence, and invalidation rule;
8. let Octopad maintain tracker progress and activity; never mirror status or task text into a Plan page, private JSON control object, scheduler, or artifact ledger.

Stream and task refs are fingerprint identities; returned Octopad IDs are API identities. Store task refs such as `E01` in `**Plan ref**`. After creation, read the exact streams and tasks, require one-to-one ref-to-ID mappings, map task membership and dependency IDs back to refs, and recompute the packet. Never pass a plan ref where a tool requires an ID. After incomplete output, list once, inspect only uncertain items by exact title, ID, edge, ref, or operation key, and retry only what is proved absent. Never replay the batch. Use `expected_updated_at` on guarded updates.

Mark the stream ` (octoplanned)` only after the graph, Decisions, Questions, and complete review-receipt set exist. Reconstruct the packet and require the exact current fingerprint before showing the Plan. Its steps show the created graph; its structured fields show open questions, house-rule gates, and first ready work.

For authorized plan-and-deliver work, show the fixed Plan message and wait for its one interruption-level choice. Record one `Octoplan 18 delivery authorization` Decision containing the exact Plan fingerprint, choice, go source, disclosed effects and bounds, user checkpoints, undisclosed-event rule, and house-rule gates. The authorization covers disclosed effects in Full autonomy; it does not widen the outcome, target, or effective rules. Any changed disclosure, checkpoint, or material drift requires a refreshed Plan, applicable focused review, and new go.

For plan-only work, stop there without a supervisor lease or Goal. For authorized delivery, choose the supervisor before creating a Goal. Record one `Octoplan 18 supervisor lease` Decision with owner native-task identity, generation, Goal identity or null, acquired time, and status; every guarded lease update uses `expected_updated_at`. Continue in the current task only after a light planning pass with enough context left to verify the whole run. Otherwise give a fresh task this minimal handoff:

```text
Use $octoplan to resume delivery of <work stream>.
Octopad: <organization> / <workspace>. Delivery authorization is recorded in the stream Decisions; do not ask for it again.
```

The receiving task revalidates the Brief, fingerprint, review floor, authority, supervisor lease, disclosed effects, user checkpoints, and house-rule gates. It acquires the initial lease while `goal identity` is null, then creates and records its one native Goal. Never alter an unrelated unfinished Goal to make room; use the disclosed fresh-supervisor route or ask for direction.
