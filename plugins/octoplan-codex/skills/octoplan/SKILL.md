---
name: octoplan
description: Use only when a Codex user explicitly invokes $octoplan, asks Octoplan to turn an idea into a governed Octopad plan, or explicitly asks to plan, replan, flesh out, or resume a governed work stream or task. Do not use for generic Octopad actions, onboarding, or unapproved execution.
---
Version: 11.0.0

# Octoplan for Codex

Turn a brainstorm into a detailed Octopad task graph, obtain the useful human choices once, and supervise authorized delivery until a real decision, risk, or protected gate needs the user. Planning creates no deliverable. Octopad holds the plan and recovery state; native Codex holds the working sessions.

Only `octoplan-plan-v1` is supported. Replan older or unknown saved plans from the confirmed mandate; never inherit their PASS, digest, fingerprint, or launch state.

## Loading order

Read [references/planning.md](references/planning.md) for planning or replanning. Read [references/state-and-recovery.md](references/state-and-recovery.md) before the first Octopad write or any resume. Read [references/codex-runtime.md](references/codex-runtime.md) before choosing routes, asking for authority, or creating a native task. Read [references/codex-supervision.md](references/codex-supervision.md) before launch or resume.

## Role packs

Load only the matching compact pack from `roles/`: planner, plan-reviewer, supervisor, executor, reviewer, specialist-reviewer, recovery, or follow-up.

One fresh read-only subagent using `plan-reviewer` reviews a complete draft before activation. It is not an Octoplan actor and cannot persist, claim, or launch. Only the active supervisor creates execution actors or records accepted review outcomes.

## Invariants

- Prove the exact organization, workspace, work stream, and Codex project before planning writes or native creation. Keep one durable, reconcilable bootstrap and one creation intent per actor; pending setup never authorizes a duplicate.
- Ask one plan-scoped native-creation grant for the finite roles and environments. Never infer it from Delivery mode, plan approval, or execution consent.
- Persist tasks with the live Octopad write shapes and literal **Why**, **What**, and top-level **Done when**, plus required impact fields. Keep probes and status relays out of the task graph.
- Treat missing `structuredContent`, presentation drift, incomplete MCP prose, or absent exhaustive readback as warnings. Record one receipt per item and verify only uncertain writes by ID, stable task key, or exact edge.
- Bind execution to a plan ID and approved integer revision, not canonical bytes. Material scope, graph, gate, route, authority, or acceptance changes create a new reviewed revision; display names, descriptions, links, and response formatting do not.
- Scale review to effect. Never treat silence, timeout, or an unexecuted check as PASS, and recheck only the changed surface unless scope or contract changed.
- The supervisor reconciles and repairs inside the approved envelope. Pause strictly for a wrong project/workspace, an unreconcilable duplicate, missing real authority, a write proven missing after targeted recovery, a conflicting approved plan, or a protected gate.
- Secrets, access grants, destructive effects, merge, migration application, deployment, publication, spend, and acceptance remain separately gated.

Keep opaque identifiers out of visible prose and titles. Before any user-attention wait and in the final recap, publish `État`, `Fait`, `Bloqué`, `Décision attendue`, `Pour débloquer`, and `Prochaine étape`.

## Changing this skill

Edit and release [sudolab-co/octopad-mcp](https://github.com/sudolab-co/octopad-mcp), never an installed copy.
