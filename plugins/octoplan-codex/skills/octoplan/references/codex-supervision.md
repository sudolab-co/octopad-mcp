# Codex supervision

Read this after authorization or on resume. Octopad holds the durable Brief, Plan, authority, evidence, and progress; Codex holds the live run.

## Enter or resume

Start or refresh production Octopad. Read all `Octoplan 18` Decisions, the current `OCTOPLAN_PLAN_REVIEW` receipts, open graph, in-progress comments, native Goal and tasks, effective target rules, and real artifact state.

Continue only while the Brief, reviewed task revisions, review floor, interruption level, scope, and disclosed effects match. A supervisor change never repeats consent. For withdrawn authority, Plan drift, an undisclosed event, an ambiguous effect, or any pre-v18 state, pause the affected branch and read [recovery.md](recovery.md).

One supervisor acts at a time, as named in the stream Decision. Reread that Decision before every spawn, external effect, task close, checkpoint clearance, and Goal transition. If this task has an unrelated unfinished Goal, do not mutate it; use the already disclosed fresh-supervisor route or ask the user. Set a token budget only when the user explicitly requested one.

Every user-facing Delivery contact starts with `**Octoplan · Step 3 of 3 — Delivery**`. Apply the interruption contract from [SKILL.md](../SKILL.md), persist progress and evidence immediately, and use the six-field consequence handoff below for every wait.

## Phase 4: advance the ready frontier

Repeat until the integrated outcome is proved or no safe work remains:

1. **Refresh.** Read latest user intent, current supervisor, reviewed task revisions and lens set, ready tasks, dependencies, assignments, current artifact versions, checks, disclosed effects, and house-rule gates.
2. **Pick.** Choose the next ready task. Do not take a task assigned to another person. Set the owning task in progress before work.
3. **Route.** Keep small work inline. Spawn only for net benefit; apply the saved route, checking observation when exposed or using the recorded degradation.
4. **Collect.** Require the real deliverable, changed version, executed verification output, decisions, and blockers to be written on the owning task.
5. **Review.** Run targeted checks and apply the delivery review floor in [SKILL.md](../SKILL.md). A cleared checkpoint or gate records its subject, owner, and the user's continuation. Confirmed stable findings return to the same healthy worker.
6. **Advance.** Close the task only after current proof is accepted and every finding is dispositioned. Persist the evidence immediately, then refresh the ready frontier.

Treat a worker, reviewer, message, or effect as created only after its call returns or the authoritative target confirms it; record the returned or reconciled identity or result before reporting it. Before task close, add one compact supervisor comment that references existing receipts and names the checks, review or checkpoint outcome, and any retry or material decision. Do not create another log.

If a worker had to write wording a user will read, require the exact strings and surface. When another unstarted task owns that surface, record them in one comment on that task without changing its reviewed specification; if its owner started or closed, replan instead.

Do not mirror a scheduler, Plan page, delivery report, or artifact registry. Task statuses and dependencies are the graph state; task comments carry receipts and recovery evidence. The Goal is a continuity handle, not a second source of project truth.

## Worker prompt

Send a bounded prompt; do not paste predecessor history:

```text
Deliver one Octopad task: <task title>.
Octopad: <organization> / <workspace> / <work stream>.
Use <saved model and effort>; verify observation when exposed, otherwise use
the run's persisted degradation.

Start production Octopad, build exact context on this task, read the stream's
Octoplan 18 Decisions, and read the target's effective rules. Work only this
task and only within its recorded authority. Run its exact Verify steps and
write the real output, artifact version, decisions, and blockers on the task.
List the exact strings and surface of any wording a user will read that you had
to write.

Do not close the task, advance the Plan, launch another actor, approve a gate,
or perform a protected effect. Return the six-field handoff if attention is
needed; otherwise return one line naming the artifact and verification result.
```

For an errored, missing, or unverifiable worker, stop that branch and follow [recovery.md](recovery.md). Never finish covertly under another identity.

## Proof and review

Verify the exact artifact version that will advance. Repository work refreshes base, head, diff, and applicable checks before mutation, push, review, and handoff. Content, research, and operations use their own proof lenses from planning; never invent Git evidence for them.

Green CI proves only what it ran. An unavailable verifier is a blocker, not permission to skip it. An independent review uses one fresh source-first task. Reuse that reviewer only for stable finding corrections; changed scope, contract, route, acceptance, deliverable, or one-way-door lens gets the newly applicable fresh review.

When a test can pass without exercising the production path, require negative proof at the real call site. A fixture-only or source-only check cannot establish that the live path uses the intended behavior.

Only the supervisor validates advancement and durable authority. A worker or reviewer verdict is evidence, not permission.

A reviewer may expose risk but cannot enlarge `Done when`. A finding blocks only when it cites an effective rule, a reviewed `Verify` or `Done when` requirement, an uncleared selected checkpoint or house-rule gate, or a concrete correctness failure; otherwise record residual risk and continue. Disposition every finding as fixed, deferred with authority and rationale, or dismissed with evidence.

A persistent CI workflow, generic test harness, service, dependency, or cross-repository artifact absent from the reviewed plan is a material plan change, not a verification detail. Reject it as scope expansion unless an effective rule or accepted outcome requires it; if so, replan before building it.

## Phase 5: reconcile change and interruption

Before an external non-idempotent effect that could duplicate or be hard to undo, record its `OCTOPLAN_ACTION <stable-key>` per [recovery.md](recovery.md). Refresh its Plan bound, authority, target, and effective rules, then apply the interruption contract in [SKILL.md](../SKILL.md); record new undisclosed-event consent on the `Octoplan 18 delivery authorization` Decision. At a selected checkpoint, Step-by-step pause, or house-rule gate, record the subject, owner, and user's continuation.

Consent alone does not refresh the Plan. A material changed outcome, proof, boundary, assumption, target, authority need, or protected consequence returns to Brief; a material changed graph or membership, task meaning, route, verifier, deliverable, review trigger, disclosure, checkpoint, or house-rule gate changes the Plan and gets the applicable fresh focused review before a new go. A wording fix or stable finding correction does not. Record drift, affected conclusion, and recheck as evidence.

For a timeout, incomplete mutation, worker failure, takeover, or evidence gap, read [recovery.md](recovery.md) before acting. Do not infer success, replay work, or stop independent safe branches.

### Consequence handoff

At any user wait, record the subject, owner, and user's continuation. Start with `**Octoplan · Step 3 of 3 — Delivery**`, state the practical consequence, and report in the user's language with these six labels and one line each:

- **State** — where the outcome stands.
- **Done** — what is finished and proved.
- **Blocked** — what is waiting and why.
- **Decision expected** — the exact human decision or action.
- **To unblock** — who must provide what evidence.
- **Next step** — what resumes immediately afterwards and what safe work continues meanwhile.

Any field may say the local equivalent of “none”. Do not mark the Goal blocked for an ordinary chosen checkpoint or a first recoverable incident. Use native blocked only after the same real impasse persists for three consecutive Goal turns and no meaningful in-scope progress remains.

## Phase 6: prove closure or hand off

Choose a fresh supervisor before Goal creation whenever the planning pass was heavy. For a later takeover or incomplete handoff, stop at a safe boundary and follow [recovery.md](recovery.md). Persist in-flight state on its owning tasks; never transfer a Goal or authority through chat alone.

Complete only when the current integrated outcome is proved; the confirmed Brief and reviewed task revisions still match the PASS receipts; every required review and finding disposition is satisfied; every selected checkpoint, Step-by-step pause, and house-rule gate has the user's recorded continuation; every disclosed effect has a receipt or is proved unnecessary; no task remains active; and no ambiguous effect is unresolved.

Close the achieved outcome task and Goal, then release supervisor ownership in the stream Decision. Publish one `**Octoplan · Step 3 of 3 — Delivery**` six-field recap. Use supported shared states (`built`, `reviewed`, `merged`, `applied`, `verified`, `released`, `accepted`) or domain equivalents, stopping at the real finish line. Name recorded residual risks and findings deferred with authority and rationale. Name out-of-scope follow-up without presenting it as incomplete delivery.
