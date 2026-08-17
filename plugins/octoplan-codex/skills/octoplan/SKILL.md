---
name: octoplan
description: Use only when a Codex user explicitly invokes $octoplan, asks Octoplan to turn an idea into a governed Octopad plan, or explicitly asks to plan, replan, flesh out, resume, or supervise a governed work stream or task. Do not use for generic Octopad actions, onboarding, or execution the user did not authorize.
---
Version: 17.2.0

# Octoplan for Codex

Turn a request into the smallest useful Octopad plan, challenge that plan once, and supervise only the delivery the user authorized. Octopad owns durable project truth; Codex owns live reasoning, tools, agents, and execution.

## The simple contract

Store the plan where the team already works: tasks, dependencies, Decisions, Questions, and task comments. Use a native Codex Goal only as the active supervisor's continuity handle. Do not mirror the plan into a private JSON control object, universal actor registry, per-task generation/manifest system, or artifact ledger.

A later supervisor must be able to resume by reading the work stream's Decisions, open tasks, latest task comments, supervisor lease, current Goal, target rules, and real artifact state. If those sources cannot establish authority, unique ownership, or what an unfinished effect did, pause only the affected branch and reconcile it.

## Loading order

Read [references/planning.md](references/planning.md) to capture, challenge, and persist a plan. Read [references/codex-runtime.md](references/codex-runtime.md) before choosing a model, delegating, or asking for authority. Read [references/codex-supervision.md](references/codex-supervision.md) before delivery or resume.

## Roles

The current user task plans interactively and becomes supervisor by default. Use one fresh read-only reviewer for the plan. During delivery, work inline when the task is small and sequential; spawn a worker or reviewer only when isolation, specialization, parallelism, independence, or context reduction is worth the handoff.

## Invariants

- Capture outcome and proof, in/out of scope, constraints and sources, uncertainties, ownership, authorized effects, and protected checkpoints before writes.
- Show one localized creation brief. If it faithfully restates an explicit plan-and-deliver mandate without adding a material choice or effect, proceed after showing it; otherwise wait for approval. Planning-only permission never authorizes delivery.
- Read live Octopad methodology, current tool schemas, and the target's effective rules. They are the floor; a delivery mandate never lowers them.
- Create the fewest coherent tasks that deliver the first integrated result. Keep approvals, reviews, merges, and status relays as checkpoints or steps unless a human owns a distinct deliverable.
- Run exactly one fresh plan challenge for each new or materially changed plan. Stable corrections return to the same reviewer; delivery review remains separate.
- Bind plan review to a canonical plan fingerprint, distinct reviewer identity, source/rules snapshot, checks, findings, and verdict. Recompute the fingerprint before activation.
- Preserve the exact Luna/Sol route table and verify a spawned task's observed route. Unknown, unavailable, or mismatched routes pause without substitution.
- Treat secrets, access grants, spend, destructive actions, required human review, merge, migration application, deployment, publication, and acceptance as protected checkpoints.
- Bind each checkpoint clearance to its exact subject/version, owner, evidence, and invalidation rule; changed artifacts reopen stale clearance.
- Close work only from current artifact evidence and executed checks. Silence, timeout, irrelevant green CI, or an unrun check is never PASS.
- Before a non-idempotent external effect, record one stable operation key on the owning task. After ambiguous output, inspect the target and retry only an effect proven absent.
- Before spawning, record one stable dispatch key. Reconcile ambiguous creation through native task reads; a replacement waits for predecessor stop and effect quiescence.
- A checkpoint blocks only its dependent branch. Continue every independent safe branch.
- Choose a fresh supervisor before Goal creation after a heavy planning pass. A later takeover uses a guarded supervisor-lease rotation and quiescence proof; Goals never transfer.
- At a human wait, artifact handoff, unrecovered incident, or completion, report six localized fields: state, done, blocked, decision expected, to unblock, next step.

## Older Octoplan plans

Do not execute private Octoplan v3-v6 control objects. Treat them only as historical evidence: stop or reconcile any actor or effect that may still be live, reread the current mandate and real task graph, then make a fresh reviewed v17 plan. Never transfer an old PASS, authority claim, pending action, supervisor ownership, or Goal state.

## Changing this skill

Edit and release [sudolab-co/octopad-mcp](https://github.com/sudolab-co/octopad-mcp), never an installed copy.
