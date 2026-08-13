# Codex supervision

Read this after delivery is authorized or when a fresh task resumes supervision. Octopad holds the plan and mandate; Codex holds the live run.

## Enter or resume

Start or refresh a production Octopad session. Read the `Octoplan 17 plan contract`, `Octoplan 17 delivery authorization`, and `Octoplan 17 supervisor lease` Decisions; the latest `OCTOPLAN_PLAN_REVIEW` receipt; open tasks and dependencies; each in-progress task's latest comments and dispatch receipts; current native Goal/tasks; effective target rules; and real artifact state.

Delivery may continue only when the authorization still covers the exact scope and effects. Do not ask again merely because supervision changed tasks. If authority was withdrawn, the contract changed, a protected action is next, or an unfinished effect is ambiguous, pause only the affected branch and reconcile it.

The supervisor acts only while the guarded lease names its exact native-task identity and Goal. Reread it before every spawn, external effect, task close, checkpoint clearance, and Goal transition. The supervisor owns one native Goal through integrated proof. If this task has an unrelated unfinished Goal, do not mutate it; use the already disclosed fresh-supervisor route or ask the user. Set a token budget only when the user explicitly requested one.

## The loop

Repeat until the integrated outcome is proved or no safe work remains:

1. **Refresh.** Read latest user intent, lease owner/generation, reviewed plan fingerprint, ready tasks, dependencies, assignments, current artifact versions, checks, dispatch receipts, and protected checkpoints.
2. **Pick.** Choose the next ready task. Do not take a task assigned to another person. Set the owning task in progress before work.
3. **Route.** Work inline for small sequential work. Spawn a worker only when the benefit exceeds the handoff; apply the task's exact saved route and verify the observed pair.
4. **Collect.** Require the real deliverable, changed version, executed verification output, decisions, and blockers to be written on the owning task.
5. **Review.** Run targeted checks, plus the task's required fresh or human review. A protected clearance records exact subject/version, owner, evidence, and invalidation rule; artifact drift reopens it. Confirmed findings return to the same healthy worker when scope is stable.
6. **Advance.** Close the task only after current proof is accepted. Report one short progress line, then refresh the ready frontier.

Do not mirror a scheduler or artifact registry. Task statuses and dependencies are the plan state; task comments carry receipts and recovery evidence. The Goal is a continuity handle, not a second source of project truth.

## Worker prompt

Send a bounded prompt; do not paste predecessor history:

```text
Deliver one Octopad task: <task title>.
Octopad: <organization> / <workspace> / <work stream>.
Use <saved model and effort>; verify the observed pair before work.

Start production Octopad, build exact context on this task, read the stream's
Octoplan 17 Decisions, and read the target's effective rules. Work only this
task and only within its recorded authority. Run its exact Verify steps and
write the real output, artifact version, decisions, and blockers on the task.

Do not close the task, advance the plan, launch another actor, approve a gate,
or perform a protected action. Return the six-field handoff if attention is
needed; otherwise return one line naming the artifact and verification result.
```

A worker that errors, disappears, or returns unverifiable work gets one fresh retry on the same task only after native evidence proves it stopped, its dispatch is terminal, and authoritative targets prove its effects quiescent. The replacement gets a new dispatch key. If the retry also fails, stop that branch and report it; never finish covertly under another identity.

## Proof and review

Verify the exact artifact version that will advance. Repository work refreshes base, head, diff, and applicable checks before mutation, push, review, and handoff. Content, research, and operations use their own proof lenses from planning; never invent Git evidence for them.

Green CI proves only what it ran. An unavailable verifier is a blocker, not permission to skip it. A targeted review may run inline; an independent review uses one fresh source-first task. Reuse that reviewer only for stable finding corrections; changed scope, contract, route, acceptance, or deliverable gets a new review.

Only the supervisor validates advancement and durable authority. A worker or reviewer verdict is evidence, not permission.

## Non-idempotent effects

Before any external effect that could duplicate or be hard to undo, add a task comment with `OCTOPLAN_ACTION <stable-key>`, the exact target, authority source, intended effect, and pre-effect state. Use the same key for one retry of that same intent.

After a timeout or incomplete response, assume neither success nor failure. Inspect the authoritative target, record the receipt if present, and retry only when absence is proved. An unresolved action stays on the owning task and blocks its descendants, not independent work.

Use `expected_updated_at` on guarded Octopad updates. A conflict causes reread and reconciliation, never overwrite.

## Problems and replanning

Classify an obstacle just enough to choose the next move:

- **Transient:** retry once with the same operation key.
- **Evidence gap:** refresh the authoritative source; never infer.
- **In scope:** try at most two distinct safe, reversible remedies.
- **Plan change:** stop affected work, update the brief/Decisions/tasks/dependencies, and run one fresh plan review.
- **Protected:** open or resume the named human checkpoint.

A wording fix or stable finding correction is not a replan. A changed outcome, scope, task meaning, graph, authority, route, proof, deliverable, or protected action is. Stop and reconcile any old worker before a replacement writes; keep useful evidenced artifacts only when the new task explicitly adopts them.

After two comparable work/review cycles without newly accepted artifact, review, or integrated proof, diagnose the plan, context, task size, route, tool, and verifier before launching more work. Activity, drafts, tokens, or irrelevant checks are not progress.

## Human checkpoints

Before accepting a protected checkpoint, refresh its exact subject/version and require the named owner and evidence. A changed subject invalidates the old receipt. At a protected checkpoint or unrecovered problem, report in the user's language with these six labels and one line each:

- **State** — where the outcome stands.
- **Done** — what is finished and proved.
- **Blocked** — what is waiting and why.
- **Decision expected** — the exact human decision or action.
- **To unblock** — who must provide what evidence.
- **Next step** — what resumes immediately afterwards and what safe work continues meanwhile.

Any field may say the local equivalent of “none”. Do not mark the Goal blocked for an ordinary planned checkpoint or a first recoverable incident. Use native blocked only after the same real impasse persists for three consecutive Goal turns and no meaningful in-scope progress remains.

## Handover and close

Choose a fresh supervisor before Goal creation whenever the planning pass was heavy. If takeover is needed later, stop at a safe boundary before judgment degrades. Write in-flight state, artifact versions, verification output, dispatch state, ambiguous effects, and the next ready task onto their owning tasks; record a quiescence receipt; then update the supervisor lease with `expected_updated_at` to the successor identity and incremented generation. The predecessor is fenced immediately and may perform no further effect if it wakes.

A successor first verifies the predecessor terminal or unreachable, the guarded lease rotation, and post-fence effect quiescence; then it creates a new Goal and records its identity on the lease. The predecessor Goal remains historical and is never claimed transferred or marked complete unless its own objective was actually achieved. The recorded authorization carries, so settled choices are not reopened.

Complete only when the current integrated outcome is proved, the live plan fingerprint still matches its PASS receipt, every required review and version-bound checkpoint is satisfied, no task or dispatch remains active, and no ambiguous effect is unresolved. Close the outcome task and current Goal, retire the supervisor lease, then publish the same six-field recap with accepted evidence and any follow-up that remains outside scope.
