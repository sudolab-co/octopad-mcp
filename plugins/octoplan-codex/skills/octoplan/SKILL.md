---
name: octoplan
description: Use only when a Codex user explicitly invokes $octoplan, asks Octoplan to turn an idea into a governed Octopad plan, or explicitly asks to plan, replan, flesh out, or resume a governed work stream or task. Do not use for generic Octopad actions, onboarding, or unapproved execution.
---
Version: 16.0.0

# Octoplan for Codex

Turn a request into the smallest useful governed plan, challenge it once, persist it in Octopad, and supervise authorized delivery until the integrated outcome is proved or a protected decision needs its owner. Octopad owns shared project truth; Codex owns live reasoning, agents, tools, and execution.

Only `octoplan-plan-v6` is supported. Reject any other control schema; never migrate or translate it. Start a new v6 plan from the live mandate.

## Loading order

Read [references/planning.md](references/planning.md) for capture, calibration, planning, and plan review. Read [references/state-and-recovery.md](references/state-and-recovery.md) before the first Octopad write or any resume. Read [references/codex-runtime.md](references/codex-runtime.md) before choosing a route or spawning an agent. Read [references/codex-supervision.md](references/codex-supervision.md) before authorized delivery.

## Roles

The current user task plans interactively and becomes supervisor by default. Spawn a role only when isolation, specialization, parallelism, or context reduction is worth its handoff cost. Every spawned agent loads one matching role pack and enters the exact production Octopad context before work; read-only roles never write.

Role packs: [planner](roles/planner.md), [plan reviewer](roles/plan-reviewer.md), [supervisor](roles/supervisor.md), [executor](roles/executor.md), [reviewer](roles/reviewer.md), [specialist reviewer](roles/specialist-reviewer.md), [recovery](roles/recovery.md), and [follow-up](roles/follow-up.md).

Use one fresh `plan-reviewer` for each plan revision. Corrections to stable findings return to that same session. A material replan gets one new fresh reviewer. Delivery reviews required by the artifact, organization, or repository remain separate from this plan review.

## Invariants

- Before writing, capture the project contract: outcome and proof, scope and non-goals, constraints, sources, uncertainties, ownership, authority, and protected effects.
- Calibrate two independent axes: `shape = simple|structured|adaptive` controls plan and actor topology; `consequence = reversible|material|protected` controls review and human gates. Explain both and escalate uncertainty upward.
- Show one localized **brief de création** whose detail follows that calibration. It names the proposed graph, artifact profiles and verifiers, review cadence, delivery authority, and every human checkpoint with owner and resume evidence.
- Do not write outside an explicit user mandate. When the brief faithfully restates an already explicit plan-and-deliver request without adding a material choice or effect, proceed under that mandate after showing it; otherwise wait for approval. Planning-only permission never authorizes delivery, and protected effects remain separately gated.
- Use live Octopad methodology and current tool schemas rather than restating or caching them. Keep integration invariants here: exact identity, stable operation keys, guarded updates, targeted reconciliation, and no blind replay.
- Persist coherent top-level tasks with the server-required **Why**, **What**, **Done when**, impact rationale, and dependency rationale. Do not create tasks for reads, logins, tool calls, status relays, approvals, reviews, or merges; keep those as steps or checkpoints unless a human owns a distinct deliverable.
- Plan the first integrated demonstrable result. Parallelize only independent work, cap active work, and keep safe branches moving while another branch waits.
- Preserve the documented Luna/Sol model-effort router exactly. Save and verify the planned and observed pair; unavailable, unknown, or mismatched routes pause without substitution.
- Bind each active agent to the current plan revision, intent revision, task generation, manifest hash, authority, Octopad context, observed route, and artifact versions.
- Use a native Goal only for delivery the user authorized. The current supervisor owns it through integrated proof; native `blocked` keeps its platform meaning.
- Scale task review to consequence and changed surface. Silence, timeout, irrelevant green CI, or an unexecuted check is never PASS.
- Recover transient and in-envelope obstacles within bounded attempts. Material change creates a new revision; protected change creates or resumes the named human checkpoint.
- Track every artifact through a strict generic core plus exactly one profile: `repository`, `content`, `research`, or `operations`. One coherent task may own several artifacts and profiles. Never require Git evidence for a non-repository artifact or weaken profile-specific proof.
- Complete only on current integrated outcome evidence, satisfied protected checkpoints, terminal artifact dispositions, reconciled actions, and no active delivery actor.

Keep opaque identifiers out of visible prose and titles. At artifact handoff, human/handoff wait, or an unrecovered incident, executors publish the six fixed semantics—state, done, blocked, decision expected, to unblock, next step—with labels and content in the user's language. Only the supervisor validates advancement and durable authority.

## Changing this skill

Edit and release [sudolab-co/octopad-mcp](https://github.com/sudolab-co/octopad-mcp), never an installed copy.
