# Codex routing and authority

Read this before choosing a model, delegating, creating a Goal, or asking for authority.

## Authority

Translate the user's mandate into the disclosed plan writes, native tasks, target, effects, and protected checkpoints. A faithful creation brief covered by an explicit plan-and-deliver request needs no ceremonial second approval. A new target, material scope, external effect, or protected action needs new authority. A Goal never widens authority.

Read-only planning and review need no delivery authority. They still use production Octopad and the exact bounded context, and they cannot write, claim, complete, launch, or approve.

## Exact route table

Choose by detection difficulty and reversibility. Save the exact model, effort, and short reason on every spawned task.

| Work profile | Route |
|---|---|
| Mechanical work with deterministic proof | `gpt-5.6-luna · effort max` |
| Bounded product, technical, editorial, review, or supervision judgment | `gpt-5.6-sol · effort high` |
| Difficult, open-ended, weakly verified, or high-consequence work | `gpt-5.6-sol · effort xhigh` |
| Open architecture or investigation without a reliable verifier | `gpt-5.6-sol · effort max` |

The only automatic routes are Luna `max` and Sol `high|xhigh|max`. Terra, Luna below `max`, Sol below `high`, unknown, unavailable, or unobserved pairs pause without substitution. Role admission is stricter: planner = Sol `xhigh|max`; plan reviewer, supervisor, and delivery reviewer = Sol `high|xhigh|max`; worker = the exact table route. These floors apply to the current inline task and spawned tasks alike.

Before planning or inline delivery, verify the current task's observed model and effort from system or native task/session evidence. After spawning, do the same for the returned task before work or effects. Prompt text, title, or the requested route is not observation. If the host cannot expose the pair, pause that actor; do not treat a planned route as an observed one.

## Native tasks and delegation

The current user task is the default planning and supervision target. Use a fresh supervisor after a heavy planning pass, when another native Goal is already active, or when repository/worktree isolation requires it. Create the Goal only after the supervisor is chosen and delivery is authorized.

Use a spawned worker only when isolation, specialization, independent parallelism, or context reduction is worth the handoff. Keep a small sequential task inline. Before create, write `OCTOPLAN_DISPATCH <stable-key>` on the owning task with role, Octopad task ID, intended native target/project/worktree, exact route, and authority source. Include the key in the prompt. Create once, then reconcile the returned native task through native list/read and record its exact task identity, target/project/worktree association, Octopad binding, and observed route before work. Ambiguous creation pauses that branch; never create again merely because one response field is missing.

Every worker starts production Octopad, reads the exact task and stream Decisions, reads effective target rules, and works only that task. The supervisor alone closes tasks, advances the graph, validates checkpoints, and creates other actors. Record a terminal dispatch receipt when the worker stops and its effects are reconciled. Create a replacement only after native evidence proves the predecessor stopped and the authoritative targets prove its effects quiescent.

Give native tasks readable titles under 64 characters: `SUP-<stream>-delivery`, `EX-<stream>-<task>`, or `REV-<stream>-<subject>`. Shorten the stream first; omit `octoplanned`; keep opaque IDs in prompts and tool records.

Parallelize only tasks whose real write surfaces and outputs are independent. Never parallelize migrations, shared generated artifacts, or siblings where one shapes the other's contract.

## Review and protected checkpoints

Run deterministic checks before judgment. Every task gets targeted verification. Add one fresh source-first reviewer when a mistake is costly or effective rules require it. Add a specialist only for a distinct second material domain that the first review cannot cover.

Secrets, access grants, destructive effects, spend, required human review, merge, migration application, deployment, publication, and acceptance remain protected. Keep them on the owning task as named checkpoints, not fake delivery tasks. A checkpoint blocks only descendants that need it; continue independent safe work.
