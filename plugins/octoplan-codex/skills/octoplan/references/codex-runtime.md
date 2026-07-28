# Codex routing and autonomous execution

## Route after decomposition

Choose by consequence, openness, ambiguity, coupling, verification strength, and retry cost. File count alone never chooses a model. Split an oversized task before raising its model.

Apply these rows in order:

| Observable task profile | Exec stamp |
|---|---|
| Open investigation or architecture decision | `gpt-5.6-sol · effort max` |
| Bounded authentication, permissions, payments, private data, data integrity, concurrency, destructive migration, or other costly-to-reverse implementation | `gpt-5.6-sol · effort xhigh` |
| Bounded non-sensitive synthesis with genuinely independent partitions and a real parallel gain | `gpt-5.6-sol · effort ultra`, with user opt-in |
| Public, brand-defining, persuasion-critical, legal, compliance, or other costly-to-reverse non-code work | `gpt-5.6-sol · effort xhigh` |
| Difficult bounded logic, bounded ambiguity, unusual integration, or weak verification | `gpt-5.6-sol · effort high` |
| Mechanical exact copy, rename, text, or safe configuration with no design choice | `gpt-5.6-luna · effort medium` |
| Routine low-consequence work with an exact pattern, deterministic checks, and cheap retry | `gpt-5.6-luna · effort high` |
| Routine non-code work with a verified governing template | `gpt-5.6-luna · effort high` |
| Novel but bounded internal analysis or document with verified sources and ordinary consequences | `gpt-5.6-terra · effort high` |
| Bounded work with moderate coupling or a materially costly failed first pass | `gpt-5.6-sol · effort medium` |
| Other standard bounded autonomous work with clear acceptance and strong deterministic verification | `gpt-5.6-terra · effort high` |

Terra `high` is the ordinary fallback. Luna `medium` requires an exact result, no judgment, low consequence, reversibility, deterministic failure-catching proof, and no sensitive system. Ultra means parallel delegation, not "very hard".

Optimize cost per accepted task: include retries, review corrections, delay, and scope drift. Do not silently change model or effort mid-session. If the profile changes, stop, save the evidence, re-route, and create a fresh session.

## Review routing

`Review: required` for behavioral changes, material judgment, unfamiliar integrations, ambiguous diagnoses, weak verification, or costly mistakes. `skip` is limited to the same mechanical conditions that permit Luna `medium`.

| Review target | Review route |
|---|---|
| Standard deterministic behavior or bounded internal judgment | `gpt-5.6-sol · effort medium` |
| Difficult logic, bounded ambiguity, unfamiliar integration, weak verification, or Ultra synthesis | `gpt-5.6-sol · effort high` |
| Sensitive, destructive, private-data, permission, payment, concurrency, public persuasion, legal, or compliance work | `gpt-5.6-sol · effort xhigh` |
| Open investigation or architecture decision | `gpt-5.6-sol · effort max` |

Use a fresh reviewer with no authoring history. The orchestration owner creates and monitors that review session at the saved Review route; the executor does not review its own work. Resolve or explicitly surface every material finding and rerun affected verification before completion.

## Execution consent

Completing a plan never authorizes execution. End the planning response in the conversation language with this meaning, adapted only for natural grammar:

> The plan is complete and verified. Would you like me to start execution now?
>
> If you accept, Codex will execute the plan in its defined order by automatically creating the required sessions, using the planned model and reasoning effort for each task. It will run only tasks that the plan explicitly declares independent in parallel. It will stop at human gates, material plan changes, or failures that need your decision.

Then stop. Do not call `list_projects`, `create_thread`, or any executor tool while waiting.

A clear yes authorizes only:

- the current saved plan and its verified scope;
- creation and monitoring of its executor sessions;
- the exact saved model and reasoning effort for each task;
- saved parallel groups that still pass preflight.

It does not authorize a protected external action, a human-only task, a materially revised plan, or a model substitution.

## Orchestration loop after approval

The planning session becomes the single orchestration owner:

1. Re-read the current Octopad plan. Treat dependencies as authority and `#N` only as a label.
2. Resolve the next ready executable task. If the plan explicitly records a parallel group, preflight every member and every pair before creating any session.
3. Reject placeholders, unmet Preconditions, foreign assignments, missing routing, asymmetric parallel links, and tasks already owned by another live execution.
4. Claim the complete selected set before launch. Prefer one atomic batch when Octopad offers it. Otherwise set members to `in_progress` sequentially with each current value passed as `expected_updated_at`; if any claim fails before launch, release only the untouched claims acquired by this attempt with the same concurrency guard, then re-read the group. Never launch or leave a partial claimed group.
5. Use `list_projects` to resolve the saved repository. For a Git repository, create a fresh worktree task; otherwise use the saved local project. Never fork the planning conversation.
6. Call `create_thread` once per selected top-level task with its exact saved model and reasoning effort. Do not use a cheaper fallback.
7. Keep executor prompts minimal and task-specific:

   ```text
   Execute Octopad task "<immutable task ID>" — <plain stream> #N - <task title>.
   Octopad · Organisation: <organisation> · Workspace: <workspace>.
   This is one task in an approved Octoplan run. Brief yourself from Octopad and the repository, start immediately, and complete the saved implementation and verification. If Review is required, produce a reviewable branch, pull request, document, or artifact only as permitted by the active rules, and leave the task in progress; a separate routed reviewer will gate completion. Do not create or emit a successor; the orchestration task owns continuation.
   Plan approval does not authorize human-only gates or any merge, publication, message, permission, payment, destructive change, or other action that the current user or repository rules reserve for separate approval. Stop before that action and report the exact gate to the orchestration task.
   ```

8. Persist every creation result in Octopad immediately. When `create_thread` returns `threadId` and `hostId`, save both. When worktree setup returns only `clientThreadId`, save it as pending, do not pass it to thread tools, and do not relaunch. Resolve the finished setup with `list_threads`, matching the saved project and the immutable Octopad task ID at the start of the executor prompt; then save the real `threadId` and `hostId`. If that unique match cannot be proven, pause with the pending client ID instead of guessing.
9. Use `wait_threads` only after a real `threadId` exists, for bounded progress snapshots. A created or exited thread proves neither delivery nor completion.
10. For `Review: required`, create one fresh review thread with the exact saved Review route after the executor has produced a reviewable branch, pull request, document, or other durable artifact. For code, start the reviewer from the published branch when available and give it the task ID plus branch or pull-request pointer. For shared non-code work, give it the task ID plus the system-of-record pointer. Never pass authoring history or a summary in place of the saved task.
11. Persist the review thread ID. Send confirmed findings to the original executor with `send_message_to_thread`, wait for fixes and rerun verification, then ask the same reviewer thread to verify the corrected artifact. Do not create duplicate implementers or reviewers for the same attempt.
12. Mark a task done only after its saved `Done when`, verification, and required review are durably satisfied. A protected merge, publication, approval, or other human action remains a gate.
13. When every member of the active group is durably complete, re-read Octopad and repeat from step 2.
14. Finish only when final validation and the plan's definition of success are complete.

## Stops and recovery

- **Human gate:** pause, name the required human action, and wait. Never perform or approve it.
- **Material replan:** update the plan, show the change, ask the execution-consent question again, and wait.
- **Thread creation failure:** report the exact task, project, model, effort, and error. Do not downgrade or paste the whole task into the orchestration session.
- **Partial parallel launch:** record exactly which sessions exist, do not duplicate them, and recover only the missing members after re-reading current state.
- **Review failure:** keep the task `in_progress`, preserve the implementer and reviewer thread IDs, and report the exact finding or reviewer error. Never waive a saved required review.
- **Interrupted orchestration:** Octopad remains authoritative. On a later explicit "resume execution", re-read claims, saved thread identifiers, task state, branches, and pull requests before deciding what remains.
- **Protected external action:** follow the active repository and user approval rules even when autonomous execution was approved.

The orchestration owner may wait and monitor; executor sessions remain one-shot and sterile.
