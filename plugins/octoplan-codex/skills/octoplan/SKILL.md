---
name: octoplan
description: Use only when a Codex user explicitly invokes $octoplan, asks Octoplan to turn an outcome into a governed Octopad plan, or explicitly asks to plan, replan, flesh out, resume, or supervise a governed work stream or task. Do not use for generic Octopad actions, onboarding, or execution the user did not authorize.
---
Version: 18.1.0

# Octoplan for Codex

Turn a confirmed outcome into the smallest useful Octopad work graph, then advance every safe ready branch until the outcome is proved or a real human consequence decision is required. Octopad is the control plane. Codex supplies live planning, routing, delegation, review, and supervision.

## One visible program

Every user-facing Octoplan message starts with exactly one applicable Markdown banner as its first line. Do not rename, decorate, combine, or skip these byte-identical banners:

```markdown
**Octoplan · Step 1 of 3 — Brief**
**Octoplan · Step 2 of 3 — Plan**
**Octoplan · Step 3 of 3 — Delivery**
```

The six internal phases are: confirm the Brief; compose the Plan; challenge and activate it; advance Delivery; reconcile change; prove closure or hand off. Internal runtime mechanics never create another user-facing stage.

## Load only what the active phase needs

- Read [references/planning.md](references/planning.md) for Brief, Plan, plan review, and activation.
- Read [references/codex-supervision.md](references/codex-supervision.md) before Delivery or resume.
- Read [references/codex-runtime.md](references/codex-runtime.md) only when choosing or checking a route, delegating, creating a Goal, or interpreting runtime authority.
- Read [references/multi-stream.md](references/multi-stream.md) only when topology selects more than one work stream.
- Read [references/recovery.md](references/recovery.md) before a duplicable or hard-to-undo effect, on shared-infrastructure distress, after two comparable cycles without accepted progress, or for ambiguity, actor failure, takeover, replan, legacy state, or handoff.

## Shared foundation

- **F1, control plane.** Read current Octopad and target state before planning or resuming. Every record uses quotes read this session, numbers re-derived when written, source identity, revision or hash, and read time; moving values become pointers, and secrets or unnecessary private text are never copied. Persist in Octopad; keep no shadow control plane.
- **F2, adaptive topology.** Reuse work that owns the outcome. Use the fewest streams, tasks, and edges that expose independent deliverables and real waits.
- **F3, progressive complexity.** Do not load or report coordination, routing, or recovery mechanics the work does not need.
- **F4, confirmed intent.** Every new or materially changed outcome receives a scaled Brief playback and explicit confirmation. Replay its persisted interpretation every session. Resume the same Brief without asking again.
- **F5, falsifiable plan.** Verify material premises, record what would kill the run, and challenge the complete artifact graph before activation.
- **F6, state-bound review.** Reviews name exact task revisions. Never carry PASS across affected drift or erase the receipt it supersedes.
- **F7, ready work moves.** Advance every safe ready branch inside the mandate. A wait or failure blocks only descendants that need it.
- **F8, invariant safety.** Interruption level changes when the user hears from Octoplan, never the applicable rules, verification, review, persistence, or evidence floor.
- **F9, recoverable ownership.** Keep one supervisor at a time and record it as a stream Decision. Before retry or replacement, inspect the authoritative target. A successor confirms that its predecessor stopped before acting. Guard Octopad updates with `expected_updated_at`.
- **F10, integrated closure.** Close only from current integrated evidence, using supported shared states (`built`, `reviewed`, `merged`, `applied`, `verified`, `released`, `accepted`) or a domain equivalent where a shared state has no meaning. Silence, timeout, irrelevant green checks, and unrun checks are not PASS.
- **F11, consequence language.** Ask only about a consequence the user owns, in words a non-expert can answer. Never ask the user to certify technical correctness.
- **F12, one program.** Brief, Plan, and Delivery use the fixed banners above across implementations; model-specific phases and agents remain invisible product mechanics.
- **F13, protected effects.** Any step that bills money to any party, or has another consequence that cannot be undone, is a protected effect and must be disclosed at Plan even when no house rule mentions it.

## Interruption levels

The reviewed Plan ends with one choice:

- **Full autonomy.** The go authorizes every disclosed effect and Delivery runs uninterrupted. Authority is monotonic: once granted, a go persists through internal corrections; replanning and re-review do not revoke it. A new go is required only when the outcome, authority, a protected effect, a user-owned consequence, or the substance of a user gate changes. Dependency order or gate placement alone is not such a change. The initial go must postdate and name the Plan handoff it answers.
- **Checkpoints.** Apply Full autonomy and pause at the checkpoints selected from the Plan's default marked set.
- **Step-by-step.** Pause after every agreed step.

House rules are not a level. When the effective rules route an action to a named person or require exact later evidence, show that wait and owner in the Plan and honor it. Octoplan adds no such wait for a user whose rules do not require one. Persist progress and evidence immediately in every level.

## Review floors

Before activation, every Plan gets at least one fresh independent review. Use at least two independent judgments with distinct primary lenses when the Plan has eight or more tasks or touches schema, permissions, money, privacy, or destructive operations. Internal, reversible work with deterministic proof may reduce that two-review floor to one, never below one or below stricter effective rules. Every material executable change gets at least one fresh independent review; use a second focused independent lens for a one-way-door surface. Low-risk non-material work may close on machine checks plus supervisor verification. Use staging before production where available. Disposition every finding as fixed, deferred with authority and rationale, or dismissed with evidence.

## Shared/runtime boundary

Shared semantics decide what persists, topology, authority, review invalidation, safe continuation, human need, and closure proof. Codex-specific mechanics decide native tasks and Goals, model and effort routing, concurrency, worktrees, handoff, and recovery implementation. Current Octopad schemas and effective target, repository, permission, privacy, legal, publication, and runtime rules remain the floor.

## Changing this skill

Edit and release [sudolab-co/octopad-mcp](https://github.com/sudolab-co/octopad-mcp), never an installed copy. Use [CONFORMANCE.md](../../CONFORMANCE.md) to verify that v18 retains the shared core and every v17.2 guarantee.
