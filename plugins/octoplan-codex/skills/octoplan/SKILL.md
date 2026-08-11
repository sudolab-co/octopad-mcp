---
name: octoplan
description: Use only when a Codex user explicitly invokes $octoplan, asks Octoplan to turn an idea into a governed Octopad plan, or explicitly asks to plan, replan, flesh out, or resume a governed work stream or task. Do not use for generic Octopad actions, onboarding, or unapproved execution.
---
Version: 13.1.0

# Octoplan for Codex

Turn a natural-language request into an outcome-first Octopad task graph, expose the useful human checkpoints before creation, and supervise authorized delivery until the integrated result is proved or a protected checkpoint needs its owner. Planning creates no deliverable. Octopad holds the shared plan; native Codex Goals and tasks hold the live execution loop.

Only `octoplan-plan-v3` is supported. Replan v1, v2, 10.x, or unknown saved plans from the confirmed mandate; never inherit PASS, authority, creation intents, or launch state. A v3 actor adopts compatible installed updates at its next safe boundary.

## Loading order

Read [references/planning.md](references/planning.md) for planning or replanning and [references/octoplan-contract-v3.md](references/octoplan-contract-v3.md) when legacy state or a breaking version is found. Read [references/state-and-recovery.md](references/state-and-recovery.md) before the first Octopad write or any resume. Read [references/codex-runtime.md](references/codex-runtime.md) before choosing routes, asking for authority, or creating a native task. Read [references/codex-supervision.md](references/codex-supervision.md) before launch or resume.

## Role packs

Role packs are role contracts, not initial interview prompts. During interactive clarification and planning, the current user task follows `planning.md` directly without a planner pack; after activation it follows `codex-supervision.md` and loads supervisor. Each child loads one matching pack.

One fresh read-only `plan-reviewer` reviews the draft before activation but cannot persist, claim, or launch. The current user task becomes supervisor by default; an environment-driven exception needs a fenced handoff and one effective Goal owner.

## Invariants

- Before the first Octopad write, ask only material questions and show one **brief de création**: outcome, scope, evidence, route, review cadence, and every human checkpoint with subject, timing, reason, owner, blocked descendants, safe parallel work, expected decision, and resume evidence.
- Recommend either `progressive` review or `final` review. Add an optional intermediate checkpoint only when human judgment changes downstream method, prevents material rework, governs repeated artifacts, controls an irreversible/external effect, or is unsafe to infer. Organization and repository rules always overlay that cadence.
- Do not create a Page merely to store the brief. The tracker, delivery tasks, dependencies, Decisions, and Questions must embody it; the tracker describes outcome, scope, order, checkpoints, and completion without copying task state.
- Understand user updates as natural language, persist a new intent revision before messaging actors, and make every actor reread live coordination state at a safe boundary. Never expose a command grammar or let a stale instruction keep acting.
- Prove the exact organization, workspace, work stream, and Codex project before writes or native creation. Missing metadata such as `projectId=null` is incomplete evidence, not a blocker or permission to duplicate; reconcile it with bounded alternative evidence.
- Persist delivery tasks with literal **Why**, **What**, and top-level **Done when**, required impact fields, real test/CI coverage, and adjacent-risk checks where relevant. Make each top-level task one independently reviewable delivery/rollback unit; under one-PR-per-task rules, independent surfaces become separate tasks and PRs.
- Bind execution to plan ID, integer revision, and `intent_revision`. Material outcome, graph, checkpoint, route, authority, or acceptance changes create a reviewed revision; operational instructions still propagate immediately when safely applicable.
- Use a native Goal only for authorized delivery. The current supervisor owns it until outcome proof; `waiting-human` and `paused` are coordination states, never Octopad task statuses, and Goal `blocked` is reserved for the native three-turn genuine-impasse rule.
- Plan the first integrated demonstrable candidate, bound WIP/review/retry/batches, launch from `eligible_safe_ready`, and use native waits for active tasks. Heartbeats only watch timed external predicates from refreshed shared state.
- Scale review to effect, map every changed surface to an actually running verifier, and never treat silence, timeout, green but irrelevant CI, or an unexecuted check as PASS.
- The supervisor owns ordinary in-envelope failures through bounded diagnosis and recovery. Pause only for proven wrong identity, unresolved identity after recovery, unreconcilable duplicate, missing authority, proven missing write, conflicting revision, or the affected protected checkpoint.
- Secrets, access grants, destructive effects, merge, migration application, deployment, publication, spend, and acceptance remain separately gated.

Keep opaque identifiers out of visible prose and titles. At artifact handoff, human/handoff wait, or an unrecovered incident, executors publish the six fixed semantics—state, done, blocked, decision expected, to unblock, next step—with labels and content in the user's language. Only the supervisor validates advancement and durable authority.

## Changing this skill

Edit and release [sudolab-co/octopad-mcp](https://github.com/sudolab-co/octopad-mcp), never an installed copy.
