# Octoplan planning

Use this workflow to understand the request, show the smallest adequate plan, challenge it once, and persist it in Octopad. The conversation holds the draft; Octopad holds the accepted plan.

## Contents

- [Enter and resume](#enter-and-resume)
- [Create the brief](#create-the-brief)
- [Draft the plan](#draft-the-plan)
- [Challenge once](#challenge-once)
- [Persist and hand off](#persist-and-hand-off)

## Enter and resume

Start a production Octopad session, read the live methodology, and build exact context for the named task or work stream. Read existing tasks, dependencies, Decisions, Questions, linked sources, and the target's effective instruction files. Retrieve only material gaps.

If the stream already has an active `Octoplan 17 plan contract` Decision, follow [codex-supervision.md](codex-supervision.md) when its delivery authorization still stands. If it has a reviewed v17 plan but no delivery authorization, show the plan and checkpoints and ask only for the missing delivery decision. If it has an older private control object, follow the legacy rule in SKILL.md.

## Create the brief

Interview in natural language. Ask only about facts that can change the outcome, proof, scope, constraints, ownership, order, authority, or a protected effect. State reasonable assumptions instead of making the user design implementation details.

Before any Octopad write, show one localized **creation brief**:

- **Outcome and proof** — what integrated result must exist and how it will be demonstrated.
- **In / out** — explicit scope and the nearest non-goals.
- **Sources and constraints** — the governing repository, documents, rules, access, deadlines, and assumptions.
- **Open questions** — only unresolved choices that can change the plan.
- **Smallest graph** — proposed tasks, dependencies, first integrated result, and safe parallel branches.
- **Execution and review** — inline work versus spawned workers, saved model routes, task checks, and the one fresh plan challenge.
- **Authority and checkpoints** — plan-only or bounded delivery, every protected action, owner, blocked descendants, safe continuation, and exact evidence that resumes it.
- **Supervisor** — this task or a fresh task after planning; recommend fresh supervision when the planning pass is heavy.

Keep the brief compact for small reversible work and expand only the parts whose failure is costly. An explicit initial request to plan and deliver is an authority source when this brief merely restates it and adds no material target, role, effect, or choice. Otherwise wait for a reply. A reply can approve only the plan while leaving delivery for later.

## Draft the plan

Build the first integrated demonstrable result, not a catalog of possible work. Use one top-level task per independently acceptable deliverable. Split only when ownership, verifier, protected gate, real dependency, or useful parallelism differs. Prefer inline execution for a single small task.

Every executable task carries:

```markdown
**Plan ref**
<stable plan-local ref such as E01>

**Why**
<why this deliverable exists and what it builds on>

**What**
<one job, scope, and important non-goals>

**How**
<verified paths or sources, patterns to reuse, and edge cases>

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

Do not create tasks for reads, logins, ordinary tool calls, progress reports, approvals, reviews, merges, or publications. Keep those as steps or protected checkpoints unless a person owns a distinct artifact. Use subtasks only as a checklist for three or more internal steps inside one deliverable.

Match proof to the deliverable:

- **Repository:** exact repository, base/head, changed surfaces, applicable checks, review state, and migration/backout evidence when relevant.
- **Content:** exact document revision, factual sources, audience, approval, and publication target.
- **Research:** exact question, retained source set, citation coverage, uncertainty, and synthesis revision.
- **Operations:** exact target, dry run, approval, execution receipt, and rollback evidence.

These are proof lenses, not persistent artifact profiles or a second lifecycle system. Effective repository, privacy, security, legal, and publication rules may add stricter proof.

## Challenge once

Give one fresh read-only reviewer the approved brief, the complete draft task text and dependency graph, applicable Decisions and Questions, real sources, and effective rules. The reviewer starts a production Octopad session, reads the exact bounded context, and makes no write or authority decision.

Ask it to attack mandate fidelity, missing work or decisions, simpler decomposition, dependencies, executable proof, hidden assumptions, route fit, protected actions, and human gates. Add integration and conflict checks for parallel work; add privacy, security, data-loss, reversibility, public-effect, and failure-containment checks where relevant. Scale lenses inside this one review instead of multiplying reviewers.

Accept only `PASS`, `REVISE`, `INFEASIBLE`, or `HUMAN_DECISION`, with stable finding keys, checks, and evidence. Apply stable findings and return them to the same reviewer for a targeted recheck. A change to outcome, scope, graph, task meaning, authority, route, proof, or protected actions is a material replan and gets one new fresh review.

Fingerprint the review subject as SHA-256 over one normalized, ordered packet: approved brief; exact stable plan refs, task titles, and descriptions; dependency edges expressed by plan ref with rationales; material Decisions and Questions; authority; checkpoints; routes; target/source versions; and effective-rules snapshot. Server-generated task IDs, statuses, assignees, and timestamps are excluded. Persist a `OCTOPLAN_PLAN_REVIEW` receipt with the fingerprint, distinct native reviewer-task identity, observed route, source/rules snapshot, verdict, finding keys, checks, and evidence. A stable targeted recheck records the corrected fingerprint and same reviewer identity. Immediately before activation, reconstruct the packet from the persisted graph by mapping returned task IDs back through their unique `**Plan ref**` fields, then require an exact fingerprint match to the latest PASS; a missing, duplicate, or changed mapping, or any content drift, is unreviewed.

## Persist and hand off

Immediately before writing, reread current Octopad schemas and target versions. Persist only after the mandate covers the brief and plan review is PASS:

1. create or adopt the work stream;
2. create the reviewed tasks, their stable plan refs, and dependency edges in the fewest coherent batch calls;
3. record material choices and open questions as Decisions and Questions;
4. record one `Octoplan 17 plan contract` Decision containing the outcome/proof, authority boundary, reviewer routing, protected checkpoint map, safe parallel branches, selected supervisor route, canonical fingerprint recipe, and latest review-receipt reference;
5. define each protected checkpoint with exact subject/version, owner, blocked descendants, required evidence, and an invalidation rule that reopens it whenever that subject changes;
6. when delivery is authorized, record one `Octoplan 17 delivery authorization` Decision with its source, exact scope, and still-protected actions;
7. record one `Octoplan 17 supervisor lease` Decision with owner native-task identity, generation, Goal identity or null, acquired time, and status; every guarded lease update uses `expected_updated_at`;
8. let Octopad maintain tracker progress and activity; never mirror status or task text into a plan Page.

Give every planned task one immutable ref such as `E01` in its `**Plan ref**` field. The ref is its fingerprint identity; the returned Octopad ID is its API identity. After creation, read the exact persisted tasks, require a one-to-one ref-to-ID mapping, map dependency IDs back to refs, and recompute the reviewed packet. Never pass a plan ref where a tool requires an ID. After incomplete or timed-out output, list once, inspect only uncertain items by exact title, ID, edge, ref, or operation key, and retry only what is proven absent. Never replay the whole batch. Use `expected_updated_at` on guarded updates.

Mark the stream ` (octoplanned)` only after the graph, Decisions, Questions, and review receipt exist. Show the created graph, open questions, checkpoints, and first ready task.

For plan-only work, stop there without a Goal. For authorized delivery, choose the supervisor before creating a Goal. Continue here only after a light planning pass with enough context left to verify the whole run; otherwise give a fresh task this minimal handoff:

```text
Use $octoplan to resume delivery of <work stream>.
Octopad: <organization> / <workspace>. Delivery authorization is recorded in the stream Decisions; do not ask for it again.
```

The receiving task revalidates the fingerprint, authority, supervisor lease, and protected gates, acquires the initial lease while `goal identity` is null, then creates and records its one native Goal. Never alter an unrelated unfinished Goal to make room; use the disclosed fresh-supervisor route or ask for direction.
