# Codex runtime routing and authority

Read this before choosing a model, delegating, creating a Goal, or asking for authority.

## Authority

Apply the single authority and interruption contract in [SKILL.md](../SKILL.md). Persist the user's Plan choice and bounds in `Octoplan 18 delivery authorization`; a Goal never widens them.

A plan reviewer is read-only: it uses production Octopad and exact bounded context but cannot write, claim, complete, launch, approve, or authorize. A worker receives only the delivery authority its owning task needs. The supervisor validates all advancement and authority.

## Exact route table

The planner selects each worker by the judgment remaining after task preparation, not project size. Consider Luna `max` first, including substantial implementation with settled decisions and reliable checks; record why a more capable route is needed. These are routing defaults, not measured cost rankings. Save the exact model, effort, and reason on each task.

| Role or remaining work | Default route |
|---|---|
| Planner: resolve design choices and prepare executable tasks | `gpt-6-astra · effort xhigh` |
| Supervisor: dispatch the reviewed graph, collect proof, arrange review, handle incidents | `gpt-5.6-sol · effort high` |
| Worker: task preparation resolves the difficult choices and verification is reliable | `gpt-5.6-luna · effort max` |
| Worker: bounded judgment still exceeds the first candidate | `gpt-6-astra · effort low` |
| Worker: several unresolved reasoning steps within a well-specified task | `gpt-6-astra · effort medium` |
| Reviewer: bounded verification with reliable checks | `gpt-5.6-sol · effort high` |
| Worker or reviewer: difficult reasoning or hard-to-detect errors | `gpt-6-astra · effort high` |
| Worker or reviewer: weak verification or high consequences | `gpt-6-astra · effort xhigh` |

Astra `max` is exceptional after diagnosis, never automatic. New role admission: planner = Astra `xhigh|max`; supervisor = Sol `high`; worker = Luna `max` or Astra `low|medium|high|xhigh|max`; reviewer = Sol `high` or Astra `high|xhigh|max`. Independent review floors remain mandatory; the worker's price never determines its reviewer.

Existing v18 plans retain all saved routes valid under 1.3.0: Luna workers `max`; Sol planners `xhigh|max`, supervisors, reviewers and workers `high|xhigh|max`; Astra planners and supervisors `xhigh|max`, reviewers `high|xhigh|max`, workers `low|medium|high|xhigh|max`. Keep the exact model and effort on resume, including active actors. Any change to a saved route returns to Plan under [planning.md](planning.md) before dispatch. Other declarations or known unavailability pause only the affected actor; never substitute silently.

Compare total usage over comparable accepted work, including planning, supervision, workers, reviews, context, and rework. Quota burn per minute or benchmark dollars alone prove no savings. Diagnose two comparable cycles without accepted progress under [recovery.md](recovery.md); repair missing task preparation before escalating worker effort.

Record declared routes. When native evidence exposes model and effort, require an exact match. Positive evidence of either a wrong model or wrong effort pauses that actor without substitution. Prompt text, title, or the requested route is not observation. Otherwise continue and note once per run that the route is declared, not provable here, recording the note on the first affected receipt or owning task. Missing route metadata never makes a review fail or become `INFEASIBLE`.

## Native tasks and delegation

Reuse a session for another role only when its route matches the saved role route under the observation rule above; a prompt cannot switch its model. Otherwise create a matching session. Use a fresh supervisor after a heavy planning pass, when another Goal is active, or when isolation requires it. If runtime reports context use at 75%, prepare a safe-boundary handoff before verification capacity is lost. Create the Goal only after the supervisor is chosen and delivery is authorized.

Use a spawned worker only when isolation, specialization, independent parallelism, or context reduction is worth the handoff. Keep a small sequential task inline only when the session matches its exact saved worker route under the observation rule above; otherwise dispatch the matching worker. Treat a creation as successful only after its call returns or the authoritative target confirms it. Before any retry or replacement, inspect that target; never recreate work merely because one response field is missing.

Every worker works only its task; its `**Octopad**` line says whether it opens Octopad. The supervisor alone closes tasks, advances the graph, validates checkpoints, and creates actors. Route a user's “continue” to that recorded owner; another thread or reviewer never acquires ownership from the message. A replacement confirms its predecessor stopped before acting.

Parallelize only tasks whose real write surfaces and outputs are independent. Never parallelize migrations, shared generated artifacts, or siblings where one shapes the other's contract.

## Delivery review and protected effects

Apply the review floor, protected-effect definition, and interruption behavior from [SKILL.md](../SKILL.md). Keep effects and gates on the owning task, not as fake delivery tasks; effective rules may add stricter waits or reviewers.
