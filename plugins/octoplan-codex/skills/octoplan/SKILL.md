---
name: octoplan
description: Use only when a Codex user explicitly invokes $octoplan, asks Octoplan to turn an idea into a governed Octopad plan, or explicitly asks to plan, replan, flesh out, or resume a governed work stream or task. Do not use for generic Octopad actions, onboarding, or unapproved execution.
---
Version: 12.1.0

# Octoplan for Codex

Turn a brainstorm into an outcome-first Octopad task graph, obtain useful human choices once, and supervise authorized delivery until the integrated result is proved or a real protected gate needs the user. Planning creates no deliverable. Octopad holds the plan and recovery state; native Codex holds working sessions.

Only `octoplan-plan-v2` is supported. Replan v1, 10.x, or unknown saved plans from the confirmed mandate; never inherit PASS, authority, creation intents, or launch state.

## Loading order

Read [references/planning.md](references/planning.md) for planning or replanning. Read [references/state-and-recovery.md](references/state-and-recovery.md) before the first Octopad write or any resume. Read [references/codex-runtime.md](references/codex-runtime.md) before choosing routes, asking for authority, or creating a native task. Read [references/codex-supervision.md](references/codex-supervision.md) before launch or resume.

## Role packs

Load only the matching compact pack from `roles/`: planner, plan-reviewer, supervisor, executor, reviewer, specialist-reviewer, recovery, or follow-up.

One fresh read-only subagent using `plan-reviewer` reviews a complete draft before activation. It is not an Octoplan actor and cannot persist, claim, or launch. Every launched plan gets one dedicated native supervisor; the planner hands off, stops its loop, and stays visible.

## Invariants

- Prove the exact organization, workspace, work stream, and Codex project before planning writes or native creation. Keep one durable, reconcilable bootstrap and one creation intent per actor; pending setup never authorizes a duplicate.
- Ask one source-bound, plan-scoped native grant enumerating create/message/archive actions, finite roles, project, and environments. It never covers the user's task or an adopted task without matching provenance.
- Persist tasks with the live Octopad write shapes and literal **Why**, **What**, and top-level **Done when**, plus required impact fields. Keep probes and status relays out of the task graph.
- Treat missing `structuredContent`, presentation drift, incomplete MCP prose, or absent exhaustive readback as warnings. Record one receipt per item and verify only uncertain writes by ID, stable task key, or exact edge.
- Bind execution to a plan ID and approved integer revision. Material outcome, graph, gate, route, authority, or acceptance changes create a reviewed revision; display names, links, and response formatting do not.
- Plan for the first integrated demonstrable candidate on the critical path before non-essential external gates. Bound WIP, actor/review/retry capacity, and batches; launch from `eligible_safe_ready` and backfill after reconciliation.
- Scale review to effect. Never treat silence, timeout, or an unexecuted check as PASS, and recheck only the changed surface unless scope or contract changed.
- The supervisor owns ordinary in-envelope operational failures through bounded diagnosis and safe recovery. Pause only for proven wrong identity, identity still unresolved after that recovery, unreconcilable duplicate, missing authority, proven missing write, conflicting revision, or the affected protected gate.
- Secrets, access grants, destructive effects, merge, migration application, deployment, publication, spend, and acceptance remain separately gated.

Keep opaque identifiers out of visible prose and titles. Executors publish exactly `État`, `Fait`, `Bloqué`, `Décision attendue`, `Pour débloquer`, and `Prochaine étape` at artifact handoff, human/handoff wait, or an unrecovered incident. Only the supervisor validates advancement and durable authority.

## Changing this skill

Edit and release [sudolab-co/octopad-mcp](https://github.com/sudolab-co/octopad-mcp), never an installed copy.
