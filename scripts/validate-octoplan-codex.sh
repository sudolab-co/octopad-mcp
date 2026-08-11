#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
skill="$root/plugins/octoplan-codex/skills/octoplan"
planning="$skill/references/planning.md"
state="$skill/references/state-and-recovery.md"
runtime="$skill/references/codex-runtime.md"
supervision="$skill/references/codex-supervision.md"
compatibility="$skill/references/octoplan-contract-v3.md"
roles="$skill/roles"
manifest="$root/plugins/octoplan-codex/.codex-plugin/plugin.json"
agent_manifest="$skill/agents/openai.yaml"
changelog="$root/CHANGELOG.md"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

require_file() {
  [ -f "$1" ] || fail "missing file: $1"
}

require_text() {
  grep -Fq -- "$2" "$1" || fail "missing contract text in $(basename "$1"): $2"
}

for file in "$skill/SKILL.md" "$planning" "$state" "$runtime" "$supervision" "$compatibility" "$manifest" "$agent_manifest"; do
  require_file "$file"
done
for role in planner plan-reviewer supervisor executor reviewer specialist-reviewer recovery follow-up; do
  require_file "$roles/$role.md"
done

grep -q '^Version: 13\.1\.0$' "$skill/SKILL.md" || fail 'Codex SKILL.md is not 13.1.0'
grep -q '"version": "13\.1\.0"' "$manifest" || fail 'Codex plugin is not 13.1.0'
grep -Fq '| [`octoplan-codex`](plugins/octoplan-codex/skills/octoplan/SKILL.md) | Codex | 13.1.0 |' "$root/README.md" || fail 'README Codex version is stale'

expected_refs='codex-runtime.md
codex-supervision.md
octoplan-contract-v3.md
planning.md
state-and-recovery.md'
actual_refs=$(find "$skill/references" -maxdepth 1 -type f -name '*.md' -exec basename '{}' \; | sort)
[ "$actual_refs" = "$expected_refs" ] || fail 'unexpected Codex reference set'
require_text "$compatibility" '# Octoplan v3 compatibility'
require_text "$compatibility" 'Do not translate old fingerprints'
require_text "$compatibility" 'compatible skill version is adopted at the next safe actor boundary'
require_text "$compatibility" 'Installing v13 does not retroactively change an already-running v2 task.'
require_text "$compatibility" 'Version 13.1 is compatible with every valid v3 plan.'

active_docs="$skill/SKILL.md $planning $state $runtime $supervision"
for forbidden in 'octoplan-supervision-v6' 'octoplan-fingerprint-v' 'octopad-direct-readback-v1' 'canonical review-subject' 'saved-state equality' 'byte-deterministic' 'plan_hash' 'record Octopad `waiting-human`' 'update Octopad to `waiting-human`' 'writes Octopad `completed`'; do
  if grep -Fq "$forbidden" $active_docs; then
    fail "retired blocking contract remains active: $forbidden"
  fi
done
require_text "$skill/SKILL.md" 'references/octoplan-contract-v3.md'
require_text "$planning" '[octoplan-contract-v3.md](octoplan-contract-v3.md)'

skill_lines=$(wc -l < "$skill/SKILL.md" | tr -d ' ')
planning_lines=$(wc -l < "$planning" | tr -d ' ')
state_lines=$(wc -l < "$state" | tr -d ' ')
runtime_lines=$(wc -l < "$runtime" | tr -d ' ')
supervision_lines=$(wc -l < "$supervision" | tr -d ' ')
[ "$skill_lines" -le 45 ] || fail "SKILL.md exceeds 45 lines: $skill_lines"
[ "$planning_lines" -le 120 ] || fail "planning.md exceeds 120 lines: $planning_lines"
[ "$state_lines" -le 180 ] || fail "state-and-recovery.md exceeds 180 lines: $state_lines"
[ "$runtime_lines" -le 110 ] || fail "codex-runtime.md exceeds 110 lines: $runtime_lines"
[ "$supervision_lines" -le 140 ] || fail "codex-supervision.md exceeds 140 lines: $supervision_lines"
active_lines=$((skill_lines + planning_lines + state_lines + runtime_lines + supervision_lines))
active_words=$(wc -w $active_docs | awk 'END {print $1}')
[ "$active_lines" -le 520 ] || fail "active skill documents exceed 520 lines: $active_lines"
[ "$active_words" -le 8000 ] || fail "active skill documents exceed 8000 words: $active_words"

for toc_file in "$planning" "$state" "$runtime" "$supervision"; do
  require_text "$toc_file" '## Contents'
done
require_text "$skill/SKILL.md" 'Only `octoplan-plan-v3` is supported.'
require_text "$skill/SKILL.md" '**brief de création**'
require_text "$skill/SKILL.md" '`progressive` review or `final` review'
require_text "$skill/SKILL.md" 'Do not create a Page merely to store the brief.'
require_text "$skill/SKILL.md" 'During interactive clarification and planning, the current user task follows `planning.md` directly'
require_text "$skill/SKILL.md" 'The current user task becomes supervisor by default'
require_text "$skill/SKILL.md" '`projectId=null`'
require_text "$skill/SKILL.md" 'each top-level task one independently reviewable delivery/rollback unit'
require_text "$skill/SKILL.md" 'Use a native Goal only for authorized delivery.'
require_text "$skill/SKILL.md" '`waiting-human` and `paused` are coordination states, never Octopad task statuses'
require_text "$skill/SKILL.md" '`eligible_safe_ready`'
require_text "$skill/SKILL.md" 'labels and content in the user'
require_text "$planning" 'Before any Octopad write, show one **brief de création**'
require_text "$planning" '`roles/planner.md` is only for a delegated diagnostic planner that cannot ask the user'
require_text "$planning" 'Inspect `get_goal` before recommending the native route.'
require_text "$planning" 'exact Octopad write classes/effects and native create/message/archive actions'
require_text "$planning" '`progressive` or `final`'
require_text "$planning" 'subject, timing, why human judgment is needed, owner, blocked descendants, safe work that can continue, expected decision, and exact resume evidence'
require_text "$planning" 'Do not expose command syntax.'
require_text "$planning" 'Do not create a Page merely to preserve it'
require_text "$planning" 'scale its presentation to material complexity without dropping any required fact'
require_text "$planning" 'Compact example:'
require_text "$planning" 'persist a source-bound migration notice'
require_text "$planning" 'Never assume installation propagated the correction'
require_text "$planning" 'Never retry blindly'
require_text "$planning" '`bootstrap-dispatch-ambiguous`'
require_text "$planning" '`projectId=null` is incomplete evidence, not a blocker'
require_text "$planning" 'Octoplan operation key:'
require_text "$planning" 'depends_on_refs'
require_text "$planning" 'streamed tasks use `work_stream_id` and omit `goal_id`'
require_text "$planning" 'page links use `{page_id, rationale}`'
require_text "$planning" 'It never requires exhaustive readback or byte equality.'
require_text "$planning" 'first integrated demonstrable candidate'
require_text "$planning" 'one coherent, independently acceptable, reviewable, and reversible delivery unit'
require_text "$planning" 'one PR per task'
require_text "$planning" 'Green CI is evidence only for covered paths.'
require_text "$planning" 'A material resolved choice affecting outcome, scope, architecture, route, checkpoint, or acceptance becomes one Octopad Decision'
require_text "$planning" 'a material unresolved item becomes one Question'
require_text "$planning" 'never require all-ready activation'
require_text "$planning" 'backfill'
require_text "$planning" 'authoritative telemetry is observable'
require_text "$planning" 'Follow the effective `AGENTS.md`, organization policy, and repository workflow'
require_text "$planning" 'stop without a Goal or executor'
require_text "$planning" 'current user task remains the supervisor'
require_text "$planning" 'Post-creation Goal transfer is prohibited'
require_text "$planning" 'never set `token_budget` unless the user explicitly requested one'
require_text "$state" 'Use `expected_updated_at` on every state-changing update.'
require_text "$state" 'one UUID `idempotency_key` per logical event'
require_text "$state" '"schema": "octoplan-plan-v3"'
require_text "$state" '"proposed_review": null'
require_text "$state" '"status": "planning|planned|active|replanning|waiting-human|paused|completed|superseded"'
require_text "$state" '"review_cadence": "progressive|final"'
require_text "$state" '"execution_scope": "plan-only|deliver-authorized"'
require_text "$state" '"octopad_write_classes": ['
require_text "$state" '"native_actions": ['
require_text "$state" '"child_route": "native-task/worktree"'
require_text "$state" '"brief_records": {'
require_text "$state" '"minimum_version": "13.1.0"'
require_text "$state" '"intent": {"revision": 1'
require_text "$state" '"human_checkpoints": ['
require_text "$state" 'methodology|secret|access-grant|external-spend|destructive-effect|review|merge|migration-application|deployment|publication|acceptance'
require_text "$state" '"heartbeat": null'
require_text "$state" '"actions": ["create", "message", "archive"]'
require_text "$state" '`active -> awaiting-review -> correction-needed | handoff-pending -> terminal-reconciled -> archived`'
require_text "$state" '`archive_receipt`'
require_text "$state" 'first increment `intent.revision` under `expected_updated_at`'
require_text "$state" 'compatible installed v3 update'
require_text "$state" 'OCTOPLAN_WRITE_INTENT <operation-key>'
require_text "$state" '`structuredContent` is useful when present but never mandatory.'
require_text "$state" 'Never replay the whole batch because one item is unclear.'
require_text "$state" 'Before every create, message, or archive, persist one intent'
require_text "$state" 'Every effective receipt joins exactly one intent'
require_text "$state" 'Never message an actor about a revised instruction before the durable intent revision exists.'
require_text "$state" 'never blind replay'
require_text "$state" '"native_action_receipts": []'
require_text "$state" '"mode": "current-task|dedicated-handoff|recovery-successor"'
require_text "$state" '"predecessor": null'
require_text "$state" '"supersedes_goal_ref": null'
require_text "$state" '"effects_quiescent_ref":"..."'
require_text "$state" '"fence_key":"<plan_id>:takeover:epoch:2"'
require_text "$state" 'OCTOPLAN_TAKEOVER_INTENT'
require_text "$state" 'derive `fence_key` exactly as `<plan_id>:takeover:epoch:<predecessor_epoch+1>`'
require_text "$state" 'atomically sets owner, `recovery-successor` mode, incremented epoch, predecessor, coordination `paused`, and successor Goal `pending`'
require_text "$state" 'reread it before Goal creation'
require_text "$state" 'The predecessor Goal stays historical and is never falsely completed or blocked.'
require_text "$state" 'Targeted recovery'
require_text "$state" '`projectId=null`'
require_text "$runtime" 'A Goal never grants broader sandbox, approval, or external-effect authority.'
require_text "$runtime" 'Persisted authority must match that disclosure.'
require_text "$runtime" 'The current user task remains on its selected model as supervisor'
require_text "$runtime" 'Treat `clientThreadId` as pending setup'
require_text "$runtime" 'incomplete native metadata is an evidence defect'
require_text "$runtime" 'persisted target/receipt'
require_text "$runtime" 'metadata-only anomaly does not block'
require_text "$runtime" '`projectId=null`'
require_text "$runtime" 'Use native subagents for bounded planning/review analysis'
require_text "$runtime" 'Before `create_thread`, refresh `list_projects`'
require_text "$runtime" 'isolated worktrees for durable delivery units and PRs'
require_text "$runtime" 'cursor-based `wait_threads`'
require_text "$runtime" 'Use `update_plan` only for the current task'
require_text "$runtime" 'call `get_goal` first'
require_text "$runtime" 'minimum Octoplan version'
require_text "$runtime" 'Product, code, security, privacy, data, migration, and materially public changes require `independent`.'
require_text "$runtime" 'one additional fresh reviewer only for a second material and orthogonal failure domain'
require_text "$supervision" "Use Octopad's graph/statuses directly"
require_text "$supervision" 'Never send `waiting-human` or `paused` as an Octopad task status.'
require_text "$supervision" 'A delivery task is `todo` until claimed, `in_progress` from claim through review and embedded checkpoints'
require_text "$supervision" '`eligible_safe_ready`'
require_text "$supervision" 'Never require all-ready activation'
require_text "$supervision" 'reread `intent.revision` before the next external effect'
require_text "$supervision" 'compact cursor-based `wait_threads`'
require_text "$supervision" 'at most one heartbeat per plan'
require_text "$supervision" 'never embed a copied blocker'
require_text "$supervision" 'After two `REVISE` with the same key'
require_text "$supervision" 'global integrated-outcome evidence'
require_text "$supervision" 'Never retry create to improve a response'
require_text "$supervision" 'Use $octoplan as <role>'
require_text "$supervision" 'Once an unfinished Goal exists, never claim to transfer or fence it through an unsupported primitive'
require_text "$supervision" 'Silence, timeout, missing checks'
require_text "$supervision" 'Green CI does not cover an omitted path.'
require_text "$supervision" 'Contact the user only for a material choice'
require_text "$supervision" 'at most two distinct safe, reversible remedies'
require_text "$supervision" 'Reuse an existing no-mutation actor'
require_text "$supervision" 'seek new authority only for changed scope, target, risk, or a new protected action'
require_text "$supervision" 'Secrets, access grants, spend, destructive effects, required human review, merge, migration application, deployment, publication, and acceptance'
require_text "$supervision" 'same genuine impasse has recurred for three consecutive Goal turns'
require_text "$supervision" '`update_goal(complete)` only after current global integrated-outcome evidence'
require_text "$supervision" 'labels and content localized to the user'
require_text "$supervision" 'Compact example for an English-speaking user:'
require_text "$supervision" 'Create a `recovery-successor` only when native evidence proves the saved owner terminal or unreachable'
require_text "$supervision" 'an `effects_quiescent_ref` proves no effect remains in flight'
require_text "$supervision" 'First persist `OCTOPLAN_TAKEOVER_INTENT` with the exact predecessor object and `fence_key`'
require_text "$supervision" 'one guarded update atomically rotates owner/mode/epoch and records a pending successor Goal'
require_text "$supervision" 'Create that Goal only after successful readback'
require_text "$supervision" 'The old Goal is historical, never falsely completed or blocked'
require_text "$supervision" 'owning E task'
require_text "$supervision" 'tokens, tool calls, compactions, and retries'
require_text "$manifest" 'show the creation brief and checkpoints'
require_text "$agent_manifest" 'show the creation brief and checkpoints'
require_text "$skill/SKILL.md" 'Use only when a Codex user explicitly invokes $octoplan'
if grep -Fq 'allow_implicit_invocation: false' "$agent_manifest"; then
  fail 'known-bad Codex skill suppression policy is present'
fi
plugin_prompt=$(node -p 'require(process.argv[1]).interface.defaultPrompt[0]' "$manifest")
agent_prompt=$(sed -n 's/^  default_prompt: "\(.*\)"$/\1/p' "$agent_manifest")
[ -n "$plugin_prompt" ] && [ "${#plugin_prompt}" -le 128 ] || fail 'plugin default prompt exceeds 128 characters'
[ "$plugin_prompt" = "$agent_prompt" ] || fail 'plugin and agent default prompts differ'

for role in planner supervisor executor reviewer specialist-reviewer recovery follow-up; do
  require_text "$roles/$role.md" 'role packet'
  require_text "$roles/$role.md" 'Octopad context'
done
require_text "$roles/plan-reviewer.md" 'fresh read-only pre-run subagent'
require_text "$roles/plan-reviewer.md" '`PASS`, `REVISE`, `INFEASIBLE`, or `HUMAN_DECISION`'

[ "$(grep -Fc '| Work profile |' "$runtime")" -eq 1 ] || fail 'capacity ladder is duplicated or missing'
[ "$(grep -Ec '^\| .*`gpt-5\.6-' "$runtime")" -eq 5 ] || fail 'capacity ladder does not have five routes'

changes_file=$(mktemp "${TMPDIR:-/tmp}/octoplan-changes.XXXXXX")
trap 'rm -f "$changes_file"' EXIT HUP INT TERM
{
  git -C "$root" diff --name-only origin/main
  git -C "$root" diff --cached --name-only
  git -C "$root" ls-files --others --exclude-standard
} | sort -u > "$changes_file"

private_material_pattern="/""Users/|[[:alnum:]._%+-]+@[[:alnum:].-]+\.[[:alpha:]]{2,}|BEGIN (RSA |OPENSSH |EC )?PRIVATE KEY"
while IFS= read -r changed; do
  case "$changed" in
    .claude-plugin|.claude-plugin/*|plugins/octoplan-claude|plugins/octoplan-claude/*|docs/clients/claude.md|docs/clients/claude-code.md)
      fail "protected Claude surface changed: $changed"
      ;;
  esac
  if [ -f "$root/$changed" ] && grep -E "$private_material_pattern" "$root/$changed" >/dev/null 2>&1; then
    fail "private or identifying material appears in public file: $changed"
  fi
done < "$changes_file"

origin_claude=$(git -C "$root" show origin/main:CHANGELOG.md | sed -n '/^## octoplan-claude$/,$p')
current_claude=$(sed -n '/^## octoplan-claude$/,$p' "$changelog")
[ "$origin_claude" = "$current_claude" ] || fail 'Claude changelog section changed'

node <<'NODE'
const assert = require('assert');

const materialFields = new Set(['outcome', 'candidate', 'scope', 'success', 'taskMeaning', 'dependencies', 'parallelism', 'budgets', 'humanCheckpoints', 'owner', 'route', 'authority', 'acceptance']);
const pauseReasons = new Set(['wrong-target', 'identity-unresolved', 'unreconcilable-duplicate', 'bootstrap-dispatch-ambiguous', 'creation-dispatch-ambiguous', 'missing-authority', 'proven-missing-write', 'revision-conflict', 'human-checkpoint', 'human-decision']);
const checkpointKinds = new Set(['methodology', 'secret', 'access-grant', 'external-spend', 'destructive-effect', 'review', 'merge', 'migration-application', 'deployment', 'publication', 'acceptance']);
const octopadWriteClasses = new Set(['work-stream', 'tracker', 'task', 'dependency', 'decision', 'question', 'comment', 'coordination-state']);
const runStatuses = new Set(['planning', 'planned', 'active', 'replanning', 'waiting-human', 'paused', 'completed', 'superseded']);
const actorRoles = new Set(['supervisor', 'planner', 'executor', 'reviewer', 'specialist-reviewer', 'recovery', 'follow-up']);
const actorStates = new Set(['active', 'awaiting-review', 'correction-needed', 'handoff-pending', 'terminal-reconciled', 'archived']);

function sameMembers(left, right) {
  return Array.isArray(left) && Array.isArray(right) && left.length === right.length && left.every(value => right.includes(value)) && new Set(left).size === left.length && new Set(right).size === right.length;
}

function validatePlan(plan) {
  assert.strictEqual(plan.schema, 'octoplan-plan-v3');
  assert(typeof plan.plan_id === 'string' && plan.plan_id.length > 0);
  assert(runStatuses.has(plan.status));
  assert(Number.isInteger(plan.revision) && plan.revision > 0);
  assert(plan.proposed_revision === null || (Number.isInteger(plan.proposed_revision) && plan.proposed_revision > 0));
  assert(Object.prototype.hasOwnProperty.call(plan, 'proposed_review'));
  assert(plan.proposed_review === null || (plan.proposed_review && Number.isInteger(plan.proposed_review.revision) && ['PASS', 'REVISE', 'INFEASIBLE', 'HUMAN_DECISION'].includes(plan.proposed_review.verdict)));
  if (plan.status === 'replanning') {
    assert(Number.isInteger(plan.proposed_revision) && plan.proposed_revision > plan.revision);
    if (plan.proposed_review !== null) assert.strictEqual(plan.proposed_review.revision, plan.proposed_revision);
  } else {
    assert.strictEqual(plan.proposed_revision, null);
    assert.strictEqual(plan.proposed_review, null);
  }
  for (const key of ['organization_id', 'workspace_id', 'work_stream_id', 'coordination_task_id']) assert(typeof plan[key] === 'string' && plan[key].length > 0);
  assert(plan.outcome && /^E[0-9]+$/.test(plan.outcome.candidate_ref));
  assert(plan.brief);
  for (const key of ['source_ref', 'approval_ref', 'tracker_ref']) assert(typeof plan.brief[key] === 'string' && plan.brief[key].length > 0);
  assert(['progressive', 'final'].includes(plan.brief.review_cadence));
  assert(['plan-only', 'deliver-authorized'].includes(plan.brief.execution_scope));
  assert(Array.isArray(plan.brief.octopad_write_classes) && plan.brief.octopad_write_classes.length > 0);
  assert(plan.brief.octopad_write_classes.every(writeClass => octopadWriteClasses.has(writeClass)));
  assert(Array.isArray(plan.brief.native_actions) && plan.brief.native_actions.every(action => ['create', 'message', 'archive'].includes(action)));
  assert(Array.isArray(plan.brief.native_roles) && plan.brief.native_roles.every(role => actorRoles.has(role)));
  assert(Array.isArray(plan.brief.native_environments) && plan.brief.native_environments.length > 0);
  assert(['none', 'native-task/local', 'native-task/worktree', 'native-task/projectless'].includes(plan.brief.child_route));
  assert(Array.isArray(plan.brief.effects) && plan.brief.effects.every(effect => typeof effect === 'string' && effect.length > 0));
  assert(plan.review && plan.review.revision === plan.revision && plan.review.verdict === 'PASS');
  assert(typeof plan.review.reviewer_ref === 'string' && plan.review.reviewer_ref.length > 0);
  assert(typeof plan.review.evidence_ref === 'string' && plan.review.evidence_ref.length > 0);
  assert(plan.runtime && /^13\.[0-9]+\.[0-9]+$/.test(plan.runtime.minimum_version));
  for (const key of ['loaded_version', 'installed_version']) assert(/^13\.[0-9]+\.[0-9]+$/.test(plan.runtime[key]));
  assert(plan.intent && Number.isInteger(plan.intent.revision) && plan.intent.revision > 0);
  assert(typeof plan.intent.latest_user_directive_ref === 'string' && Array.isArray(plan.intent.superseded_effect_keys));
  assert(plan.supervisor && typeof plan.supervisor.thread_ref === 'string' && plan.supervisor.thread_ref.length > 0);
  assert(Number.isInteger(plan.supervisor.epoch) && plan.supervisor.epoch > 0);
  assert(['current-task', 'dedicated-handoff', 'recovery-successor'].includes(plan.supervisor.mode));
  if (plan.supervisor.mode === 'dedicated-handoff') assert(typeof plan.supervisor.source_fenced_ref === 'string' && plan.supervisor.source_fenced_ref.length > 0);
  assert(Object.prototype.hasOwnProperty.call(plan.supervisor, 'predecessor'));
  assert(plan.supervisor.goal && typeof plan.supervisor.goal.required === 'boolean');
  assert(Object.prototype.hasOwnProperty.call(plan.supervisor.goal, 'supersedes_goal_ref'));
  if (plan.supervisor.mode === 'recovery-successor') {
    const predecessor = plan.supervisor.predecessor;
    assert(predecessor && Number.isInteger(predecessor.epoch) && predecessor.epoch > 0 && plan.supervisor.epoch > predecessor.epoch);
    for (const key of ['thread_ref', 'goal_evidence_ref', 'revival_ref', 'terminal_or_unreachable_ref', 'effects_quiescent_ref', 'fence_key']) assert(typeof predecessor[key] === 'string' && predecessor[key].length > 0);
    assert.strictEqual(plan.supervisor.goal.supersedes_goal_ref, predecessor.goal_evidence_ref);
  } else {
    assert.strictEqual(plan.supervisor.predecessor, null);
    assert.strictEqual(plan.supervisor.goal.supersedes_goal_ref, null);
  }
  assert.strictEqual(plan.supervisor.goal.required, plan.brief.execution_scope === 'deliver-authorized');
  if (plan.supervisor.goal.required) {
    assert.strictEqual(plan.supervisor.goal.owner_thread_ref, plan.supervisor.thread_ref);
    assert(typeof plan.supervisor.goal.objective_ref === 'string' && plan.supervisor.goal.objective_ref.length > 0);
    assert(['pending', 'active', 'blocked', 'complete'].includes(plan.supervisor.goal.state));
    if (plan.supervisor.goal.state === 'pending') {
      assert.strictEqual(plan.supervisor.goal.origin, null);
      assert.strictEqual(plan.supervisor.goal.evidence_ref, null);
      assert(['planned', 'paused'].includes(plan.status));
    } else {
      assert(['created', 'adopted'].includes(plan.supervisor.goal.origin));
      assert(typeof plan.supervisor.goal.evidence_ref === 'string' && plan.supervisor.goal.evidence_ref.length > 0);
    }
    if (plan.status === 'active') assert.strictEqual(plan.supervisor.goal.state, 'active');
  } else {
    assert.strictEqual(plan.status, 'planned');
    assert.strictEqual(plan.supervisor.goal.origin, null);
    assert.strictEqual(plan.supervisor.goal.evidence_ref, null);
    assert.strictEqual(plan.supervisor.goal.state, null);
  }
  assert(plan.authority && typeof plan.authority.source_ref === 'string' && plan.authority.source_ref.length > 0);
  assert.strictEqual(plan.authority.source_ref, plan.brief.approval_ref);
  assert.strictEqual(plan.authority.delivery, plan.brief.execution_scope === 'deliver-authorized');
  assert(Array.isArray(plan.authority.actions) && plan.authority.actions.every(action => ['create', 'message', 'archive'].includes(action)));
  assert.strictEqual(new Set(plan.authority.actions).size, plan.authority.actions.length);
  assert(Array.isArray(plan.authority.adopted_session_refs));
  assert(Array.isArray(plan.authority.roles) && plan.authority.roles.every(role => actorRoles.has(role)));
  assert.strictEqual(new Set(plan.authority.roles).size, plan.authority.roles.length);
  assert(Array.isArray(plan.authority.environments) && plan.authority.environments.length > 0);
  assert(sameMembers(plan.authority.actions, plan.brief.native_actions));
  assert(sameMembers(plan.authority.roles, plan.brief.native_roles));
  assert(sameMembers(plan.authority.environments, plan.brief.native_environments));
  assert(sameMembers(plan.authority.octopad_write_classes, plan.brief.octopad_write_classes));
  assert.strictEqual(plan.authority.child_route, plan.brief.child_route);
  assert(sameMembers(plan.authority.effects, plan.brief.effects));
  assert.strictEqual(plan.authority.project_id, plan.brief.project_id);
  assert.strictEqual(plan.authority.directory_name, plan.brief.directory_name);
  if (plan.authority.delivery) assert(plan.authority.actions.length > 0 && plan.authority.roles.length > 0);
  else assert(plan.authority.actions.length === 0 && plan.authority.roles.length === 0);
  if (plan.authority.project_id === null) {
    assert(typeof plan.authority.directory_name === 'string' && plan.authority.directory_name.length > 0);
    assert.deepStrictEqual(plan.authority.environments, [null]);
  } else {
    assert(typeof plan.authority.project_id === 'string' && plan.authority.project_id.length > 0);
    assert.strictEqual(plan.authority.directory_name, null);
    assert(plan.authority.environments.every(environment => environment === 'local' || environment === 'worktree'));
    assert.strictEqual(new Set(plan.authority.environments).size, plan.authority.environments.length);
  }
  const refs = new Set(Object.keys(plan.task_ids));
  assert(refs.size > 0);
  assert(Object.values(plan.task_ids).every(id => typeof id === 'string' && id.length > 0));
  assert.strictEqual(new Set(Object.values(plan.task_ids)).size, refs.size);
  assert(plan.brief_records && plan.brief_records.decisions && plan.brief_records.questions);
  const recordIds = new Set();
  for (const [kind, pattern] of [['decisions', /^D[0-9]+$/], ['questions', /^Q[0-9]+$/]]) {
    for (const [ref, record] of Object.entries(plan.brief_records[kind])) {
      assert(pattern.test(ref));
      assert(typeof record.id === 'string' && record.id.length > 0 && !recordIds.has(record.id));
      assert(typeof record.receipt_ref === 'string' && record.receipt_ref.length > 0);
      recordIds.add(record.id);
    }
  }
  const edgeKeys = new Set();
  const dependencyMap = new Map([...refs].map(ref => [ref, []]));
  for (const edge of plan.desired_dependencies) {
    assert(refs.has(edge.task_ref) && refs.has(edge.depends_on_ref));
    assert.notStrictEqual(edge.task_ref, edge.depends_on_ref);
    const edgeKey = `${edge.task_ref}:${edge.depends_on_ref}`;
    assert(!edgeKeys.has(edgeKey));
    assert(typeof edge.rationale === 'string' && edge.rationale.length > 0);
    edgeKeys.add(edgeKey);
    dependencyMap.get(edge.task_ref).push(edge.depends_on_ref);
  }
  const visiting = new Set();
  const visited = new Set();
  function visit(ref) {
    assert(!visiting.has(ref));
    if (visited.has(ref)) return;
    visiting.add(ref);
    dependencyMap.get(ref).forEach(visit);
    visiting.delete(ref);
    visited.add(ref);
  }
  refs.forEach(visit);
  const checkpointKeys = new Set();
  assert(refs.has(plan.outcome.candidate_ref));
  assert(plan.budgets && plan.counters);
  for (const key of ['max_active_child_actors', 'max_wip', 'max_correction_loops', 'max_review_actors', 'max_review_checks', 'batch_size']) assert(Number.isInteger(plan.budgets[key]) && plan.budgets[key] > 0);
  for (const forbidden of ['tokens', 'tool_calls', 'compactions', 'time', 'cost']) assert(!(forbidden in plan.budgets));
  for (const value of Object.values(plan.counters)) {
    if (typeof value === 'object') for (const nested of Object.values(value)) assert(Number.isInteger(nested) && nested >= 0);
    else assert(Number.isInteger(value) && value >= 0);
  }
  assert(plan.counters.active_child_actors <= plan.budgets.max_active_child_actors && plan.counters.wip <= plan.budgets.max_wip);
  assert(plan.counters.review_actors <= plan.budgets.max_review_actors && plan.counters.review_checks <= plan.budgets.max_review_checks);
  if (plan.telemetry_limits) {
    assert.strictEqual(plan.telemetry_observable, true);
    for (const value of Object.values(plan.telemetry_limits)) assert(Number.isInteger(value) && value > 0);
  }
  assert(Array.isArray(plan.human_checkpoints));
  for (const checkpoint of plan.human_checkpoints) {
    assert(checkpointKinds.has(checkpoint.kind));
    assert(typeof checkpoint.checkpoint_key === 'string' && checkpoint.checkpoint_key.length > 0 && !checkpointKeys.has(checkpoint.checkpoint_key));
    assert(['user', 'organization', 'planner-recommendation'].includes(checkpoint.source));
    assert(typeof checkpoint.mandatory === 'boolean');
    assert(['pending', 'satisfied', 'rejected'].includes(checkpoint.state));
    for (const key of ['owner', 'subject', 'timing', 'reason', 'expected_decision', 'resume_predicate']) assert(typeof checkpoint[key] === 'string' && checkpoint[key].length > 0);
    assert(Array.isArray(checkpoint.blocked_task_refs) && checkpoint.blocked_task_refs.every(ref => refs.has(ref)));
    assert(Array.isArray(checkpoint.safe_continuation_refs) && checkpoint.safe_continuation_refs.every(ref => refs.has(ref)));
    const blockedRefs = new Set(checkpoint.blocked_task_refs);
    assert(checkpoint.safe_continuation_refs.every(ref => !blockedRefs.has(ref)));
    assert(checkpoint.evidence_ref === null || (typeof checkpoint.evidence_ref === 'string' && checkpoint.evidence_ref.length > 0));
    checkpointKeys.add(checkpoint.checkpoint_key);
  }
  for (const [actorRef, actor] of Object.entries(plan.actors)) {
    assert.strictEqual(actor.actor_ref, actorRef);
    assert(actorStates.has(actor.state));
    assert(actorRoles.has(actor.role) && /^E[0-9]+$|^PLAN$/.test(actor.task_ref));
    if (actor.project_id === null) {
      assert(typeof actor.directory_name === 'string' && actor.directory_name.length > 0 && actor.environment === null);
    } else {
      assert(typeof actor.project_id === 'string' && actor.project_id.length > 0 && ['local', 'worktree'].includes(actor.environment));
    }
    assert(actor.provenance && typeof actor.provenance.creation_key === 'string' && typeof actor.provenance.authority_source_ref === 'string');
    assert.strictEqual(actor.provenance.authority_source_ref, plan.authority.source_ref);
    assert(['create', 'message', 'archive'].includes(actor.provenance.action));
    assert(actor.provenance.adopted_session_ref === null || plan.authority.adopted_session_refs.includes(actor.provenance.adopted_session_ref));
    assert(authorityCovers(plan.authority, {...actor, adopted_session_ref: actor.provenance.adopted_session_ref}, actor.provenance.action));
    for (const flag of ['pending_correction', 'pending_recheck', 'waiting_human', 'handoff_pending']) assert(typeof actor[flag] === 'boolean');
    if (actor.previous_state === null) assert.strictEqual(actor.state, 'active');
    else {
      assert(actorStates.has(actor.previous_state) && validActorTransition(actor.previous_state, actor.state));
      assert(typeof actor.transition_evidence_ref === 'string' && actor.transition_evidence_ref.length > 0);
    }
    if (['awaiting-review', 'terminal-reconciled', 'archived'].includes(actor.state)) assert(typeof actor.report_ref === 'string' && actor.report_ref.length > 0);
    if (actor.state === 'awaiting-review') assert(actor.pending_recheck && !actor.pending_correction);
    if (actor.state === 'correction-needed') assert(actor.pending_correction && typeof actor.finding_ref === 'string' && actor.finding_ref.length > 0);
    if (actor.state === 'handoff-pending') assert(actor.handoff_pending && typeof actor.report_ref === 'string' && actor.report_ref.length > 0);
    if (['terminal-reconciled', 'archived'].includes(actor.state)) assert(actor.transfer_receipt && actor.reconciliation_receipt);
    if (actor.state === 'archived') {
      assert(actor.terminal_reason && ['PASS', 'abandoned', 'superseded'].includes(actor.terminal_reason));
      assert(actor.transfer_receipt && actor.archive_receipt);
      assert(!actor.pending_correction && !actor.pending_recheck && !actor.waiting_human && !actor.handoff_pending);
      assert(plan.authority.actions.includes('archive'));
    }
  }
  assert(plan.resume && Array.isArray(plan.resume.pending_operation_keys));
  assert(Array.isArray(plan.native_action_intents));
  const intentByKey = new Map();
  for (const intent of plan.native_action_intents) {
    for (const key of ['action_key', 'action', 'target_ref', 'effect_ref', 'authority_source_ref', 'role']) assert(typeof intent[key] === 'string' && intent[key].length > 0);
    if (intent.project_id === null) {
      assert(typeof intent.directory_name === 'string' && intent.directory_name.length > 0);
      assert.strictEqual(intent.environment, null);
    } else {
      assert(typeof intent.project_id === 'string' && intent.project_id.length > 0);
      assert.strictEqual(intent.directory_name, null);
      assert(['local', 'worktree'].includes(intent.environment));
    }
    assert(['create', 'message', 'archive'].includes(intent.action) && plan.authority.actions.includes(intent.action));
    assert.strictEqual(intent.plan_id, plan.plan_id);
    assert.strictEqual(intent.plan_revision, plan.revision);
    assert.strictEqual(intent.intent_revision, plan.intent.revision);
    assert.strictEqual(intent.authority_source_ref, plan.authority.source_ref);
    assert(authorityCovers(plan.authority, {...intent, adopted_session_ref: intent.adopted_session_ref ?? null}, intent.action));
    assert(Number.isInteger(intent.epoch) && intent.epoch > 0);
    assert(['pending', 'confirmed', 'ambiguous', 'failed'].includes(intent.result));
    assert(!intentByKey.has(intent.action_key));
    intentByKey.set(intent.action_key, intent);
  }
  assert(Array.isArray(plan.native_action_receipts));
  const receiptKeys = new Set();
  for (const receipt of plan.native_action_receipts) {
    for (const key of ['action_key', 'target_ref', 'observed_effect_ref', 'authority_source_ref', 'evidence_ref', 'plan_id']) assert(typeof receipt[key] === 'string' && receipt[key].length > 0);
    assert(['create', 'message', 'archive'].includes(receipt.action));
    assert.strictEqual(receipt.plan_id, plan.plan_id);
    assert.strictEqual(receipt.plan_revision, plan.revision);
    assert.strictEqual(receipt.intent_revision, plan.intent.revision);
    assert(Number.isInteger(receipt.epoch) && receipt.epoch > 0);
    assert(['confirmed', 'absent', 'conflict'].includes(receipt.result));
    assert(!receiptKeys.has(receipt.action_key));
    const intent = intentByKey.get(receipt.action_key);
    assert(intent);
    assert.strictEqual(receipt.action, intent.action);
    assert.strictEqual(receipt.target_ref, intent.target_ref);
    assert.strictEqual(receipt.observed_effect_ref, intent.effect_ref);
    assert.strictEqual(receipt.authority_source_ref, intent.authority_source_ref);
    assert.strictEqual(receipt.plan_id, intent.plan_id);
    assert.strictEqual(receipt.plan_revision, intent.plan_revision);
    assert.strictEqual(receipt.intent_revision, intent.intent_revision);
    assert.strictEqual(receipt.epoch, intent.epoch);
    const expectedIntentResult = receipt.result === 'confirmed' ? 'confirmed' : receipt.result === 'conflict' ? 'ambiguous' : 'failed';
    assert.strictEqual(intent.result, expectedIntentResult);
    receiptKeys.add(receipt.action_key);
  }
  if (plan.heartbeat !== null) {
    assert(['ci', 'human-merge', 'deployment'].includes(plan.heartbeat.kind));
    assert(typeof plan.heartbeat.predicate_ref === 'string' && plan.heartbeat.predicate_ref.length > 0);
    assert.strictEqual(plan.heartbeat.intent_revision, plan.intent.revision);
    assert.strictEqual(plan.heartbeat.owner_thread_ref, plan.supervisor.thread_ref);
    assert.strictEqual(plan.heartbeat.refreshes_coordination_state, true);
    assert.strictEqual(plan.heartbeat.watches_native_actor, false);
  }
  if (plan.status === 'completed') {
    assert(typeof plan.outcome.global_evidence_ref === 'string' && plan.outcome.global_evidence_ref.length > 0);
    assert.strictEqual(plan.outcome.global_evidence_revision, plan.revision);
    assert(plan.human_checkpoints.every(checkpoint => checkpoint.state === 'satisfied' && typeof checkpoint.evidence_ref === 'string' && checkpoint.evidence_ref.length > 0));
    assert.strictEqual(plan.supervisor.goal.state, 'complete');
    assert.strictEqual(plan.resume.pending_operation_keys.length, 0);
    assert(Object.values(plan.actors).every(actor => ['terminal-reconciled', 'archived'].includes(actor.state)));
  }
  return true;
}

const plan = {
  schema: 'octoplan-plan-v3', plan_id: 'plan-a', revision: 1, proposed_revision: null, proposed_review: null, status: 'active',
  organization_id: 'org-a', workspace_id: 'workspace-a', work_stream_id: 'stream-a', coordination_task_id: 'task-control',
  brief: {source_ref: 'message-request', approval_ref: 'message-brief-go', tracker_ref: 'tracker-a', review_cadence: 'final', execution_scope: 'deliver-authorized', octopad_write_classes: ['work-stream', 'tracker', 'task', 'dependency', 'decision', 'question', 'comment', 'coordination-state'], native_actions: ['create', 'message', 'archive'], native_roles: ['executor', 'reviewer', 'supervisor'], project_id: 'project-a', directory_name: null, native_environments: ['local', 'worktree'], child_route: 'native-task/worktree', effects: ['bounded delivery']},
  outcome: {candidate_ref: 'E01', global_evidence_ref: null, global_evidence_revision: null},
  task_ids: {E01: 'task-a', E02: 'task-b', E03: 'task-c', H01: 'task-human'},
  brief_records: {decisions: {D01: {id: 'decision-a', receipt_ref: 'receipt-decision-a'}}, questions: {Q01: {id: 'question-a', receipt_ref: 'receipt-question-a'}}},
  desired_dependencies: [{task_ref: 'E02', depends_on_ref: 'E01', rationale: 'needs artifact'}],
  review: {revision: 1, verdict: 'PASS', reviewer_ref: 'reviewer-a', evidence_ref: 'evidence-a'},
  supervisor: {thread_ref: 'thread-user', epoch: 1, mode: 'current-task', predecessor: null, goal: {required: true, owner_thread_ref: 'thread-user', objective_ref: 'message-outcome', origin: 'created', evidence_ref: 'goal-create-a', state: 'active', supersedes_goal_ref: null}},
  runtime: {minimum_version: '13.1.0', loaded_version: '13.1.0', installed_version: '13.1.0', adoption_ref: null},
  authority: {source_ref: 'message-brief-go', delivery: true, project_id: 'project-a', directory_name: null, environments: ['local', 'worktree'], roles: ['executor', 'reviewer', 'supervisor'], actions: ['create', 'message', 'archive'], octopad_write_classes: ['work-stream', 'tracker', 'task', 'dependency', 'decision', 'question', 'comment', 'coordination-state'], child_route: 'native-task/worktree', effects: ['bounded delivery'], adopted_session_refs: []},
  intent: {revision: 1, latest_user_directive_ref: 'message-brief-go', superseded_effect_keys: []},
  budgets: {max_active_child_actors: 2, max_wip: 2, max_correction_loops: 2, max_review_actors: 2, max_review_checks: 8, batch_size: 2},
  counters: {active_child_actors: 0, wip: 0, correction_loops: {}, review_actors: 0, review_checks: 0},
  human_checkpoints: [
    {checkpoint_key: 'review-a', kind: 'review', source: 'organization', mandatory: true, owner: 'maintainer', subject: 'approve exact head', timing: 'after CI', reason: 'required repository review', blocked_task_refs: ['E02'], safe_continuation_refs: ['E03'], expected_decision: 'approve or request changes', evidence_ref: null, state: 'pending', resume_predicate: 'review evidence matches head'},
    {checkpoint_key: 'deploy-a', kind: 'deployment', source: 'organization', mandatory: true, owner: 'operator', subject: 'deploy release', timing: 'after merge', reason: 'protected production effect', blocked_task_refs: ['E02'], safe_continuation_refs: [], expected_decision: 'approve or reject deployment', evidence_ref: null, state: 'pending', resume_predicate: 'deployment receipt exists'}
  ],
  actors: {}, native_action_intents: [], native_action_receipts: [],
  heartbeat: null,
  resume: {last_event_id: null, pending_operation_keys: []}
};
assert(validatePlan(plan));
assert(validatePlan(JSON.parse(JSON.stringify(plan))));
function adoptCompatible13_1(previous) {
  const adopted = JSON.parse(JSON.stringify(previous));
  if (!Object.prototype.hasOwnProperty.call(adopted, 'proposed_review')) adopted.proposed_review = null;
  if (!Object.prototype.hasOwnProperty.call(adopted.supervisor, 'predecessor')) adopted.supervisor.predecessor = null;
  if (!Object.prototype.hasOwnProperty.call(adopted.supervisor.goal, 'supersedes_goal_ref')) adopted.supervisor.goal.supersedes_goal_ref = null;
  adopted.runtime.loaded_version = '13.1.0';
  adopted.runtime.installed_version = '13.1.0';
  adopted.runtime.adoption_ref = 'safe-boundary-adoption-a';
  return adopted;
}
const priorV3 = JSON.parse(JSON.stringify(plan));
delete priorV3.proposed_review;
delete priorV3.supervisor.predecessor;
delete priorV3.supervisor.goal.supersedes_goal_ref;
priorV3.runtime = {minimum_version: '13.0.0', loaded_version: '13.0.0', installed_version: '13.0.0', adoption_ref: null};
assert(validatePlan(adoptCompatible13_1(priorV3)));
for (const kind of checkpointKinds) assert(validatePlan({...plan, human_checkpoints: [{...plan.human_checkpoints[0], kind}]}));
const externalHeartbeat = {kind: 'ci', predicate_ref: 'check-head-a', intent_revision: 1, owner_thread_ref: 'thread-user', refreshes_coordination_state: true, watches_native_actor: false};
assert(validatePlan({...plan, heartbeat: externalHeartbeat}));
assert.throws(() => validatePlan({...plan, heartbeat: {...externalHeartbeat, intent_revision: 0}}));
assert.throws(() => validatePlan({...plan, heartbeat: {...externalHeartbeat, watches_native_actor: true}}));
const planOnly = {
  ...plan,
  status: 'planned',
  brief: {...plan.brief, review_cadence: 'progressive', execution_scope: 'plan-only', native_actions: [], native_roles: [], child_route: 'none', effects: ['plan creation']},
  supervisor: {...plan.supervisor, goal: {required: false, owner_thread_ref: null, objective_ref: null, origin: null, evidence_ref: null, state: null, supersedes_goal_ref: null}},
  authority: {...plan.authority, delivery: false, roles: [], actions: [], child_route: 'none', effects: ['plan creation']}
};
assert(validatePlan(planOnly));
const deliverPlanned = {...plan, status: 'planned', supervisor: {...plan.supervisor, goal: {...plan.supervisor.goal, origin: null, evidence_ref: null, state: 'pending'}}};
assert(validatePlan(deliverPlanned));
assert.throws(() => validatePlan({...deliverPlanned, supervisor: {...deliverPlanned.supervisor, goal: {...deliverPlanned.supervisor.goal, origin: 'created', evidence_ref: 'premature-goal'}}}));
assert.throws(() => validatePlan({...plan, supervisor: {...plan.supervisor, goal: {...plan.supervisor.goal, origin: null, evidence_ref: null, state: 'pending'}}}));
assert(validatePlan({...plan, brief: {...plan.brief, project_id: null, directory_name: 'projectless-output', native_environments: [null], child_route: 'native-task/projectless'}, authority: {...plan.authority, project_id: null, directory_name: 'projectless-output', environments: [null], child_route: 'native-task/projectless'}}));
assert(validatePlan({...plan, supervisor: {...plan.supervisor, mode: 'dedicated-handoff', source_fenced_ref: 'fence-a'}}));
assert.throws(() => validatePlan({...plan, supervisor: {...plan.supervisor, mode: 'dedicated-handoff'}}));
const predecessor = {thread_ref: 'thread-user', epoch: 1, goal_evidence_ref: 'goal-create-a', revival_ref: 'wake-attempt-a', terminal_or_unreachable_ref: 'native-terminal-a', effects_quiescent_ref: 'quiescence-read-a', fence_key: 'plan-a:takeover:epoch:2'};
const recoverySuccessor = {...plan, supervisor: {thread_ref: 'thread-successor', epoch: 2, mode: 'recovery-successor', predecessor, goal: {...plan.supervisor.goal, owner_thread_ref: 'thread-successor', evidence_ref: 'goal-successor-a', supersedes_goal_ref: 'goal-create-a'}}};
assert(validatePlan(recoverySuccessor));
const pendingRecoverySuccessor = {...recoverySuccessor, status: 'paused', supervisor: {...recoverySuccessor.supervisor, goal: {...recoverySuccessor.supervisor.goal, origin: null, evidence_ref: null, state: 'pending'}}};
assert(validatePlan(pendingRecoverySuccessor));
assert.throws(() => validatePlan({...recoverySuccessor, supervisor: {...recoverySuccessor.supervisor, epoch: 1}}));
assert.throws(() => validatePlan({...recoverySuccessor, supervisor: {...recoverySuccessor.supervisor, predecessor: {...predecessor, terminal_or_unreachable_ref: ''}}}));
assert.throws(() => validatePlan({...recoverySuccessor, supervisor: {...recoverySuccessor.supervisor, predecessor: {...predecessor, effects_quiescent_ref: ''}}}));
assert.throws(() => validatePlan({...recoverySuccessor, supervisor: {...recoverySuccessor.supervisor, goal: {...recoverySuccessor.supervisor.goal, supersedes_goal_ref: 'wrong-goal'}}}));
assert.throws(() => validatePlan({...plan, brief: {...plan.brief, review_cadence: 'sometimes'}}));
const {proposed_review: omittedProposedReview, ...withoutProposedReview} = plan;
assert.throws(() => validatePlan(withoutProposedReview));
assert.throws(() => validatePlan({...plan, proposed_review: {revision: 2, verdict: 'UNKNOWN'}}));
assert.throws(() => validatePlan({...plan, proposed_revision: 2}));
assert(validatePlan({...plan, status: 'replanning', proposed_revision: 2, proposed_review: null}));
assert(validatePlan({...plan, status: 'replanning', proposed_revision: 2, proposed_review: {revision: 2, verdict: 'PASS'}}));
assert.throws(() => validatePlan({...plan, status: 'replanning', proposed_revision: 2, proposed_review: {revision: 3, verdict: 'PASS'}}));
assert.throws(() => validatePlan({...plan, brief: {...plan.brief, approval_ref: ''}}));
assert.throws(() => validatePlan({...plan, brief: {...plan.brief, native_actions: ['create', 'message']}}));
assert.throws(() => validatePlan({...plan, runtime: {...plan.runtime, loaded_version: '12.1.0'}}));
assert.throws(() => validatePlan({...plan, intent: {...plan.intent, revision: 0}}));
assert.throws(() => validatePlan({...plan, supervisor: {...plan.supervisor, goal: {...plan.supervisor.goal, required: false}}}));
assert.throws(() => validatePlan({...plan, supervisor: {...plan.supervisor, goal: {...plan.supervisor.goal, state: 'blocked'}}}));
assert.throws(() => validatePlan({...plan, status: 'revoked'}));
assert.throws(() => validatePlan({...plan, task_ids: {E01: 'task-a', E02: 'task-a', E03: 'task-c', H01: 'task-human'}}));
assert.throws(() => validatePlan({...plan, task_ids: {E01: '', E02: 'task-b', E03: 'task-c', H01: 'task-human'}}));
assert.throws(() => validatePlan({...plan, desired_dependencies: [{task_ref: 'E01', depends_on_ref: 'E01', rationale: 'self'}]}));
assert.throws(() => validatePlan({...plan, desired_dependencies: [...plan.desired_dependencies, {...plan.desired_dependencies[0]}]}));
assert.throws(() => validatePlan({...plan, desired_dependencies: [...plan.desired_dependencies, {task_ref: 'E01', depends_on_ref: 'E02', rationale: 'cycle'}]}));
assert.throws(() => validatePlan({...plan, brief_records: {decisions: {D01: {id: 'decision-a', receipt_ref: ''}}, questions: {}}}));
assert.throws(() => validatePlan({...plan, human_checkpoints: [...plan.human_checkpoints, {...plan.human_checkpoints[0]}]}));
assert.throws(() => validatePlan({...plan, human_checkpoints: [{...plan.human_checkpoints[0], blocked_task_refs: ['E99']}]}));
assert.throws(() => validatePlan({...plan, human_checkpoints: [{...plan.human_checkpoints[0], safe_continuation_refs: ['E02']}]}));
assert.throws(() => validatePlan({...plan, human_checkpoints: [{checkpoint_key: 'review-a', kind: 'review'}]}));
assert.throws(() => validatePlan({...plan, authority: {roles: ['executor']}}));
assert.throws(() => validatePlan({...plan, authority: {...plan.authority, project_id: null, directory_name: null, environments: [null]}}));
assert.throws(() => validatePlan({...plan, authority: {...plan.authority, environments: [null]}}));
assert.throws(() => validatePlan({...plan, authority: {...plan.authority, actions: ['create', 'delete']}}));
assert.throws(() => validatePlan({...plan, budgets: {...plan.budgets, tokens: 1000}}));
assert.throws(() => validatePlan({...plan, counters: {...plan.counters, wip: -1}}));
assert.throws(() => validatePlan({...plan, counters: {...plan.counters, review_checks: 9}}));
assert.throws(() => validatePlan({...plan, telemetry_limits: {tokens: 1000}, telemetry_observable: false}));
assert(validatePlan({...plan, telemetry_limits: {tool_calls: 20}, telemetry_observable: true}));
assert.throws(() => validatePlan({...plan, review: {revision: 1, verdict: 'PASS'}}));
assert.throws(() => validatePlan({...plan, resume: {last_event_id: null}}));
const actorBase = {actor_ref: 'executorA', role: 'executor', task_ref: 'E01', project_id: 'project-a', environment: 'local', provenance: {creation_key: 'create-a', authority_source_ref: 'message-brief-go', action: 'create', adopted_session_ref: null}, pending_correction: false, pending_recheck: false, waiting_human: false, handoff_pending: false};
const awaitingActor = {...actorBase, state: 'awaiting-review', previous_state: 'active', transition_evidence_ref: 'transition-review', report_ref: 'report-review', pending_recheck: true};
const archivedActor = {...actorBase, state: 'archived', previous_state: 'terminal-reconciled', transition_evidence_ref: 'transition-a', report_ref: 'report-a', terminal_reason: 'PASS', transfer_receipt: 'transfer-a', reconciliation_receipt: 'reconcile-a', archive_receipt: 'archive-a'};
assert(validatePlan({...plan, actors: {executorA: awaitingActor}}));
assert.throws(() => validatePlan({...plan, actors: {executorA: {...awaitingActor, pending_recheck: false}}}));
assert(validatePlan({...plan, actors: {executorA: archivedActor}}));
assert.throws(() => validatePlan({...plan, actors: {executorA: {...archivedActor, transfer_receipt: null}}}));
assert.throws(() => validatePlan({...plan, actors: {executorA: {...archivedActor, waiting_human: true}}}));
assert.throws(() => validatePlan({...plan, authority: {...plan.authority, actions: ['create', 'message']}, actors: {executorA: archivedActor}}));
assert.throws(() => validatePlan({...plan, actors: {executorA: {...archivedActor, role: 'unknown'}}}));
assert.throws(() => validatePlan({...plan, actors: {executorA: {...archivedActor, previous_state: 'active'}}}));
assert.throws(() => validatePlan({...plan, actors: {executorA: {...archivedActor, transition_evidence_ref: null}}}));

const satisfiedCheckpoints = plan.human_checkpoints.map(checkpoint => ({...checkpoint, state: 'satisfied', evidence_ref: `${checkpoint.checkpoint_key}-evidence`}));
const completedPlan = {...plan, status: 'completed', supervisor: {...plan.supervisor, goal: {...plan.supervisor.goal, state: 'complete'}}, outcome: {...plan.outcome, global_evidence_ref: 'integration-proof-a', global_evidence_revision: 1}, human_checkpoints: satisfiedCheckpoints, actors: {executorA: archivedActor}};
assert(validatePlan(completedPlan));
assert.throws(() => validatePlan({...completedPlan, outcome: {...completedPlan.outcome, global_evidence_ref: null}}));
assert.throws(() => validatePlan({...completedPlan, outcome: {...completedPlan.outcome, global_evidence_revision: 2}}));
assert.throws(() => validatePlan({...completedPlan, human_checkpoints: plan.human_checkpoints}));
assert.throws(() => validatePlan({...completedPlan, resume: {last_event_id: null, pending_operation_keys: ['pending-a']}}));
assert.throws(() => validatePlan({...completedPlan, actors: {executorA: {...actorBase, state: 'active', previous_state: null}}}));

function validActorTransition(from, to) {
  const allowed = {
    active: ['awaiting-review', 'handoff-pending'],
    'awaiting-review': ['correction-needed', 'handoff-pending', 'terminal-reconciled'],
    'correction-needed': ['active', 'handoff-pending'],
    'handoff-pending': ['active', 'terminal-reconciled'],
    'terminal-reconciled': ['archived'],
    archived: []
  };
  return allowed[from]?.includes(to) === true;
}
assert(validActorTransition('active', 'awaiting-review'));
assert(validActorTransition('awaiting-review', 'correction-needed'));
assert(validActorTransition('terminal-reconciled', 'archived'));
assert(!validActorTransition('active', 'archived'));
assert(!validActorTransition('handoff-pending', 'archived'));

function changeNeedsRevision(changes) {
  return changes.some(change => materialFields.has(change));
}
assert(changeNeedsRevision(['dependencies']));
assert(changeNeedsRevision(['authority']));
assert(!changeNeedsRevision(['displayName', 'descriptionFormatting', 'responseShape', 'links', 'status', 'receipt']));

function applyDirective(previous, expectedUpdatedAt, actualUpdatedAt, sourceRef, supersededEffectKeys = []) {
  assert.strictEqual(expectedUpdatedAt, actualUpdatedAt);
  assert(typeof sourceRef === 'string' && sourceRef.length > 0);
  return {...previous, intent: {revision: previous.intent.revision + 1, latest_user_directive_ref: sourceRef, superseded_effect_keys: supersededEffectKeys}};
}
const redirected = applyDirective(plan, 'u1', 'u1', 'message-do-not-send', ['send:campaign-a']);
assert.strictEqual(redirected.intent.revision, 2);
assert.deepStrictEqual(redirected.intent.superseded_effect_keys, ['send:campaign-a']);
assert.throws(() => applyDirective(plan, 'u1', 'u2', 'message-do-not-send'));

function recommendCadence(work) {
  return work.downstreamMethodChange || work.materialRework || work.sharedRuleGovernsBatch || work.irreversibleExternal || work.unsafeToInfer ? 'progressive' : 'final';
}
assert.strictEqual(recommendCadence({independentArticles: 10}), 'final');
assert.strictEqual(recommendCadence({independentArticles: 10, sharedRuleGovernsBatch: true}), 'progressive');
assert.strictEqual(recommendCadence({irreversibleExternal: true}), 'progressive');

function briefPresentation({materialBranches = 0, protectedEffects = 0, irreversible = false}) {
  return materialBranches > 1 || protectedEffects > 1 || irreversible ? 'EXPANDED' : 'COMPACT_COMPLETE';
}
assert.strictEqual(briefPresentation({materialBranches: 0, protectedEffects: 1}), 'COMPACT_COMPLETE');
assert.strictEqual(briefPresentation({materialBranches: 3}), 'EXPANDED');

function rolePackFor({currentTask, phase, delegatedRole = null}) {
  if (!currentTask) return delegatedRole;
  return phase === 'active' ? 'supervisor' : null;
}
assert.strictEqual(rolePackFor({currentTask: true, phase: 'planning'}), null);
assert.strictEqual(rolePackFor({currentTask: true, phase: 'active'}), 'supervisor');
assert.strictEqual(rolePackFor({currentTask: false, phase: 'planning', delegatedRole: 'planner'}), 'planner');

function versionDecision({schema, minimum, loaded, installed, safeBoundary}) {
  if (schema !== 'octoplan-plan-v3') return 'REPLAN_SCHEMA';
  const parse = value => value.split('.').map(Number);
  const [minimumMajor] = parse(minimum);
  const [installedMajor] = parse(installed);
  if (minimumMajor !== 13 || installedMajor !== 13) return 'REPLAN_BREAKING';
  const compare = (a, b) => parse(a).reduce((result, value, index) => result || value - parse(b)[index], 0);
  if (compare(installed, minimum) < 0) return 'PAUSE_INCOMPATIBLE';
  if (loaded === installed) return 'CONTINUE';
  return safeBoundary ? 'ADOPT_COMPATIBLE' : 'FINISH_SAFE_BOUNDARY';
}
assert.strictEqual(versionDecision({schema: 'octoplan-plan-v3', minimum: '13.0.0', loaded: '13.0.0', installed: '13.1.0', safeBoundary: true}), 'ADOPT_COMPATIBLE');
assert.strictEqual(versionDecision({schema: 'octoplan-plan-v3', minimum: '13.0.0', loaded: '13.0.0', installed: '13.1.0', safeBoundary: false}), 'FINISH_SAFE_BOUNDARY');
assert.strictEqual(versionDecision({schema: 'octoplan-plan-v3', minimum: '13.0.0', loaded: '13.0.0', installed: '14.0.0', safeBoundary: true}), 'REPLAN_BREAKING');
assert.strictEqual(versionDecision({schema: 'octoplan-plan-v2', minimum: '12.1.0', loaded: '12.1.0', installed: '13.0.0', safeBoundary: true}), 'REPLAN_SCHEMA');

function goalActivationDecision({existingStatus = 'none', exactMatch = false, dedicatedDisclosed = false, goalAlreadyCreated = false}) {
  if (goalAlreadyCreated && dedicatedDisclosed) return 'PROHIBIT_POST_CREATION_TRANSFER';
  if (existingStatus === 'none' || existingStatus === 'complete') return 'CREATE_OR_REPLACE';
  if (existingStatus === 'active' && exactMatch) return 'ADOPT_EXACT';
  if (existingStatus === 'active' && dedicatedDisclosed) return 'USE_DISCLOSED_DEDICATED_BEFORE_GOAL';
  return 'HUMAN_DECISION';
}
assert.strictEqual(goalActivationDecision({existingStatus: 'active', exactMatch: true}), 'ADOPT_EXACT');
assert.strictEqual(goalActivationDecision({existingStatus: 'active', exactMatch: false}), 'HUMAN_DECISION');
assert.strictEqual(goalActivationDecision({existingStatus: 'complete'}), 'CREATE_OR_REPLACE');
assert.strictEqual(goalActivationDecision({existingStatus: 'active', dedicatedDisclosed: true}), 'USE_DISCLOSED_DEDICATED_BEFORE_GOAL');
assert.strictEqual(goalActivationDecision({existingStatus: 'active', dedicatedDisclosed: true, goalAlreadyCreated: true}), 'PROHIBIT_POST_CREATION_TRANSFER');

function exactTakeoverIntent(value, {planId, predecessorEpoch, effectsQuiescentRef}) {
  const predecessorKeys = ['thread_ref', 'goal_evidence_ref', 'revival_ref', 'terminal_or_unreachable_ref', 'effects_quiescent_ref', 'fence_key'];
  if (!value || value.type !== 'OCTOPLAN_TAKEOVER_INTENT' || !value.predecessor) return false;
  const predecessor = value.predecessor;
  const expectedFenceKey = `${planId}:takeover:epoch:${predecessorEpoch + 1}`;
  return typeof planId === 'string' && planId.length > 0 && Number.isInteger(predecessorEpoch) && predecessorEpoch > 0 && predecessor.epoch === predecessorEpoch && predecessorKeys.every(key => typeof predecessor[key] === 'string' && predecessor[key].length > 0) && predecessor.effects_quiescent_ref === effectsQuiescentRef && predecessor.fence_key === expectedFenceKey && value.fence_key === expectedFenceKey;
}
function supervisorRecoveryDecision({planId = 'plan-a', predecessorEpoch = 1, revivalAttempted = false, savedOwnerReachable = false, archived = false, lifecycleAuthority = false, terminalOrUnreachableProved = false, effectsQuiescentRef = null, takeoverIntent = null, guardedRotationReadback = false, successorGoalReceipt = null}) {
  if (!revivalAttempted && archived) return lifecycleAuthority ? 'UNARCHIVE_AND_WAKE_SAVED_OWNER' : 'RECOVER_LIFECYCLE_AUTHORITY';
  if (!revivalAttempted) return 'WAKE_SAVED_OWNER';
  if (savedOwnerReachable) return 'RESUME_SAVED_OWNER';
  if (!terminalOrUnreachableProved) return 'RECONCILE_NO_SUCCESSOR';
  if (typeof effectsQuiescentRef !== 'string' || effectsQuiescentRef.length === 0) return 'FENCE_OR_WAIT_FOR_QUIESCENCE';
  if (!exactTakeoverIntent(takeoverIntent, {planId, predecessorEpoch, effectsQuiescentRef})) return 'PERSIST_TAKEOVER_INTENT';
  if (!guardedRotationReadback) return 'ROTATE_OWNER_MODE_EPOCH_ATOMICALLY';
  return successorGoalReceipt ? 'ACTIVATE_SUCCESSOR' : 'CREATE_ONE_RECOVERY_SUCCESSOR';
}
const takeoverIntent = {type: 'OCTOPLAN_TAKEOVER_INTENT', predecessor, fence_key: predecessor.fence_key};
const {epoch: omittedEpoch, ...predecessorWithoutEpoch} = predecessor;
const missingEpochIntent = {...takeoverIntent, predecessor: predecessorWithoutEpoch};
const wrongFencePredecessor = {...predecessor, fence_key: 'plan-a:takeover:epoch:99'};
const wrongFenceIntent = {...takeoverIntent, predecessor: wrongFencePredecessor, fence_key: wrongFencePredecessor.fence_key};
assert.strictEqual(supervisorRecoveryDecision({}), 'WAKE_SAVED_OWNER');
assert.strictEqual(supervisorRecoveryDecision({archived: true, lifecycleAuthority: true}), 'UNARCHIVE_AND_WAKE_SAVED_OWNER');
assert.strictEqual(supervisorRecoveryDecision({archived: true}), 'RECOVER_LIFECYCLE_AUTHORITY');
assert.strictEqual(supervisorRecoveryDecision({revivalAttempted: true}), 'RECONCILE_NO_SUCCESSOR');
assert.strictEqual(supervisorRecoveryDecision({revivalAttempted: true, terminalOrUnreachableProved: true}), 'FENCE_OR_WAIT_FOR_QUIESCENCE');
assert.strictEqual(supervisorRecoveryDecision({revivalAttempted: true, terminalOrUnreachableProved: true, effectsQuiescentRef: 'quiescence-read-a'}), 'PERSIST_TAKEOVER_INTENT');
assert.strictEqual(supervisorRecoveryDecision({revivalAttempted: true, terminalOrUnreachableProved: true, effectsQuiescentRef: 'quiescence-read-a', takeoverIntent: missingEpochIntent}), 'PERSIST_TAKEOVER_INTENT');
assert.strictEqual(supervisorRecoveryDecision({revivalAttempted: true, terminalOrUnreachableProved: true, effectsQuiescentRef: 'quiescence-read-a', takeoverIntent: wrongFenceIntent}), 'PERSIST_TAKEOVER_INTENT');
assert.strictEqual(supervisorRecoveryDecision({revivalAttempted: true, terminalOrUnreachableProved: true, effectsQuiescentRef: 'quiescence-read-stale', takeoverIntent}), 'PERSIST_TAKEOVER_INTENT');
assert.strictEqual(supervisorRecoveryDecision({revivalAttempted: true, terminalOrUnreachableProved: true, effectsQuiescentRef: 'quiescence-read-a', takeoverIntent}), 'ROTATE_OWNER_MODE_EPOCH_ATOMICALLY');
assert.strictEqual(supervisorRecoveryDecision({revivalAttempted: true, terminalOrUnreachableProved: true, effectsQuiescentRef: 'quiescence-read-a', takeoverIntent, guardedRotationReadback: true}), 'CREATE_ONE_RECOVERY_SUCCESSOR');
assert.strictEqual(supervisorRecoveryDecision({revivalAttempted: true, terminalOrUnreachableProved: true, effectsQuiescentRef: 'quiescence-read-a', takeoverIntent, guardedRotationReadback: true, successorGoalReceipt: 'goal-successor-a'}), 'ACTIVATE_SUCCESSOR');

const octopadTaskStatuses = new Set(['todo', 'in_progress', 'done', 'blocked']);
function octopadTaskStatus({kind = 'delivery', claimed = false, accepted = false, finalGatesSatisfied = false, evidencedBlocker = false, terminal = false}) {
  if (kind === 'coordination') return terminal ? 'done' : 'in_progress';
  if (accepted && finalGatesSatisfied) return 'done';
  if (evidencedBlocker) return 'blocked';
  return claimed ? 'in_progress' : 'todo';
}
assert.strictEqual(octopadTaskStatus({kind: 'coordination'}), 'in_progress');
assert.strictEqual(octopadTaskStatus({claimed: true}), 'in_progress');
assert.strictEqual(octopadTaskStatus({claimed: true, accepted: true, finalGatesSatisfied: false}), 'in_progress');
assert.strictEqual(octopadTaskStatus({claimed: true, accepted: true, finalGatesSatisfied: true}), 'done');
assert.strictEqual(octopadTaskStatus({evidencedBlocker: true}), 'blocked');
assert(!octopadTaskStatuses.has('waiting-human') && !octopadTaskStatuses.has('paused'));

function goalDisposition({outcomeProved = false, pendingOperations = 0, checkpointsSatisfied = false, sameImpassTurns = 0, meaningfulProgressRoute = true}) {
  if (outcomeProved && pendingOperations === 0 && checkpointsSatisfied) return 'COMPLETE';
  if (sameImpassTurns >= 3 && !meaningfulProgressRoute) return 'BLOCKED';
  return 'ACTIVE';
}
assert.strictEqual(goalDisposition({sameImpassTurns: 1, meaningfulProgressRoute: false}), 'ACTIVE');
assert.strictEqual(goalDisposition({sameImpassTurns: 3, meaningfulProgressRoute: true}), 'ACTIVE');
assert.strictEqual(goalDisposition({sameImpassTurns: 3, meaningfulProgressRoute: false}), 'BLOCKED');
assert.strictEqual(goalDisposition({outcomeProved: true, pendingOperations: 0, checkpointsSatisfied: true}), 'COMPLETE');

function heartbeatDecision({nativeActorActive = false, externalTimedPredicate = false, predicateResolved = false, intentChanged = false, exists = false}) {
  if (nativeActorActive) return 'NONE';
  if (predicateResolved) return exists ? 'DELETE' : 'NONE';
  if (!externalTimedPredicate) return 'NONE';
  if (intentChanged && exists) return 'UPDATE';
  return exists ? 'KEEP' : 'CREATE';
}
assert.strictEqual(heartbeatDecision({nativeActorActive: true, externalTimedPredicate: true}), 'NONE');
assert.strictEqual(heartbeatDecision({externalTimedPredicate: true}), 'CREATE');
assert.strictEqual(heartbeatDecision({externalTimedPredicate: true, intentChanged: true, exists: true}), 'UPDATE');
assert.strictEqual(heartbeatDecision({predicateResolved: true, exists: true}), 'DELETE');

function deliveryUnitDecision(surfaces, onePrPerTask) {
  const independentlyAcceptable = surfaces.filter(surface => surface.independentlyAcceptable).length;
  return onePrPerTask && independentlyAcceptable > 1 ? 'SPLIT_TOP_LEVEL_TASKS' : 'COHERENT_UNIT';
}
const stackedSurfaces = ['database', 'api', 'dashboard'].map(name => ({name, independentlyAcceptable: true}));
assert.strictEqual(deliveryUnitDecision(stackedSurfaces, true), 'SPLIT_TOP_LEVEL_TASKS');
assert.strictEqual(deliveryUnitDecision([{name: 'single-artifact', independentlyAcceptable: true}], true), 'COHERENT_UNIT');

function verifierCoverage(changedSurfaces, verifiers) {
  const covered = new Set(verifiers.flatMap(verifier => verifier.coveredSurfaces));
  return changedSurfaces.every(surface => covered.has(surface)) ? 'COVERED' : 'UNCOVERED';
}
assert.strictEqual(verifierCoverage(['api', 'monitoring'], [{coveredSurfaces: ['api']}]), 'UNCOVERED');
assert.strictEqual(verifierCoverage(['api', 'monitoring'], [{coveredSurfaces: ['api', 'monitoring']}]), 'COVERED');

function reconcileWrites(expected, responseItems, observations) {
  return expected.map(operation => {
    const response = responseItems.find(item => item.operation_key === operation.operation_key && item.id && item.success === true);
    if (response) return {operation_key: operation.operation_key, action: 'CONFIRMED', id: response.id, evidence: 'write-response'};
    const observed = observations.filter(item => item.operation_key === operation.operation_key);
    if (observed.length === 1 && observed[0].id) return {operation_key: operation.operation_key, action: 'CONFIRMED', id: observed[0].id, evidence: 'targeted-read'};
    if (observed.length === 0 && operation.absence_proven === true) return {operation_key: operation.operation_key, action: 'RETRY_ITEM'};
    return {operation_key: operation.operation_key, action: 'PENDING'};
  });
}
const writes = [
  {operation_key: 'plan-a:r1:task:E01'},
  {operation_key: 'plan-a:r1:task:E02'},
  {operation_key: 'plan-a:r1:task:E03', absence_proven: true}
];
assert.deepStrictEqual(reconcileWrites(writes, [{operation_key: writes[0].operation_key, id: 'task-a', success: true}], [{operation_key: writes[1].operation_key, id: 'task-b'}]).map(x => x.action), ['CONFIRMED', 'CONFIRMED', 'RETRY_ITEM']);
assert.deepStrictEqual(reconcileWrites([{operation_key: 'unclear'}], [], []).map(x => x.action), ['PENDING']);
assert.deepStrictEqual(reconcileWrites([{operation_key: 'no-structured-content'}], [{operation_key: 'no-structured-content', id: 'task-x', success: true}], []).map(x => x.action), ['CONFIRMED']);

function projectIdentityDecision(evidence, recoveryAttempts = 0) {
  if (evidence.directProject === 'expected') return 'CONFIRMED_DIRECT';
  if (evidence.directProject && evidence.directProject !== 'expected') return 'STOP_WRONG_TARGET';
  if (evidence.remoteKnown === false || evidence.actualMismatch === true || evidence.candidates > 1 || evidence.mutated === true) return 'STOP_UNSAFE_OR_CONFLICTING';
  const alternate = ['targetedReceipt', 'returnedTask', 'creationKey', 'rolePacket', 'savedProjectMapping', 'cwdAndToplevel', 'normalizedRemote', 'branchAndHeadRecorded', 'noMutation']
    .every(key => evidence[key] === true);
  if (alternate && evidence.candidates === 1) return 'CONFIRMED_ALTERNATE';
  return recoveryAttempts >= 2 ? 'PAUSE_IDENTITY_UNRESOLVED' : 'RECOVER_IDENTITY';
}
const alternateIdentity = {directProject: null, candidates: 1, targetedReceipt: true, returnedTask: true, creationKey: true, rolePacket: true, savedProjectMapping: true, cwdAndToplevel: true, normalizedRemote: true, branchAndHeadRecorded: true, noMutation: true};
assert.strictEqual(projectIdentityDecision({directProject: 'expected'}), 'CONFIRMED_DIRECT');
assert.strictEqual(projectIdentityDecision(alternateIdentity), 'CONFIRMED_ALTERNATE');
assert.strictEqual(projectIdentityDecision({...alternateIdentity, normalizedRemote: false}), 'RECOVER_IDENTITY');
assert.strictEqual(projectIdentityDecision({...alternateIdentity, normalizedRemote: false}, 2), 'PAUSE_IDENTITY_UNRESOLVED');
assert.strictEqual(projectIdentityDecision({...alternateIdentity, directProject: 'wrong'}), 'STOP_WRONG_TARGET');
assert.strictEqual(projectIdentityDecision({...alternateIdentity, candidates: 2}), 'STOP_UNSAFE_OR_CONFLICTING');
assert.strictEqual(projectIdentityDecision({...alternateIdentity, mutated: true}), 'STOP_UNSAFE_OR_CONFLICTING');

function creationDecision(intentExists, observed, boundedReconciliationComplete = false) {
  const exact = observed.filter(item => item === 'exact' || item === 'alternate');
  if (intentExists && observed.length === 1 && exact.length === 1) return 'ADOPT_EXISTING';
  if (observed.length > 0) return 'PAUSE_UNPROVEN_OR_CONFLICTING';
  if (!intentExists) return 'WRITE_INTENT_AND_CREATE_ONCE';
  return boundedReconciliationComplete ? 'PAUSE_CREATION_DISPATCH_AMBIGUOUS' : 'PENDING';
}
assert.strictEqual(creationDecision(false, []), 'WRITE_INTENT_AND_CREATE_ONCE');
assert.strictEqual(creationDecision(false, ['exact']), 'PAUSE_UNPROVEN_OR_CONFLICTING');
assert.strictEqual(creationDecision(true, ['alternate']), 'ADOPT_EXISTING');
assert.strictEqual(creationDecision(false, ['wrong-project']), 'PAUSE_UNPROVEN_OR_CONFLICTING');
assert.strictEqual(creationDecision(true, []), 'PENDING');
assert.strictEqual(creationDecision(true, [], true), 'PAUSE_CREATION_DISPATCH_AMBIGUOUS');
assert.strictEqual(creationDecision(true, ['exact']), 'ADOPT_EXISTING');
assert.strictEqual(creationDecision(true, ['exact', 'exact']), 'PAUSE_UNPROVEN_OR_CONFLICTING');
assert.strictEqual(creationDecision(true, ['wrong-project']), 'PAUSE_UNPROVEN_OR_CONFLICTING');

function nativeActionDecision(action, intentExists, observations, absenceProven = false) {
  assert(['create', 'message', 'archive'].includes(action));
  const exact = observations.filter(item => item === 'exact-effect');
  if (observations.length === 1 && exact.length === 1) return 'CONFIRM_RECEIPT';
  if (observations.length > 0) return 'PAUSE_CONFLICT';
  if (!intentExists) return 'PERSIST_INTENT_THEN_CALL_ONCE';
  return absenceProven ? 'RETRY_SAME_ACTION_KEY' : 'RECONCILE_NO_REPLAY';
}
function childPromptLoadsOctoplan(prompt, role) {
  return prompt.includes('$octoplan') && prompt.includes(`roles/${role}.md`);
}
assert(childPromptLoadsOctoplan('Use $octoplan as executor. Load roles/executor.md.', 'executor'));
assert(childPromptLoadsOctoplan('Use $octoplan as reviewer. Load roles/reviewer.md.', 'reviewer'));
assert(!childPromptLoadsOctoplan('Execute E01 with the supplied packet.', 'executor'));
for (const action of ['create', 'message', 'archive']) {
  assert.strictEqual(nativeActionDecision(action, false, []), 'PERSIST_INTENT_THEN_CALL_ONCE');
  assert.strictEqual(nativeActionDecision(action, true, ['exact-effect']), 'CONFIRM_RECEIPT');
  assert.strictEqual(nativeActionDecision(action, true, []), 'RECONCILE_NO_REPLAY');
  assert.strictEqual(nativeActionDecision(action, true, [], true), 'RETRY_SAME_ACTION_KEY');
  assert.strictEqual(nativeActionDecision(action, true, ['wrong-effect']), 'PAUSE_CONFLICT');
}
const actionIntent = {action_key: 'plan-a:r1:i1:message:E01:1', action: 'message', target_ref: 'executorA', effect_ref: 'handoff-a', authority_source_ref: 'message-brief-go', role: 'executor', project_id: 'project-a', directory_name: null, environment: 'local', adopted_session_ref: null, plan_id: 'plan-a', plan_revision: 1, intent_revision: 1, epoch: 1, result: 'pending'};
assert(validatePlan({...plan, native_action_intents: [actionIntent]}));
assert.throws(() => validatePlan({...redirected, native_action_intents: [actionIntent]}));
assert.throws(() => validatePlan({...plan, native_action_intents: [{...actionIntent, effect_ref: ''}]}));
assert.throws(() => validatePlan({...plan, native_action_intents: [{...actionIntent, action: 'delete'}]}));
assert.throws(() => validatePlan({...plan, native_action_intents: [actionIntent, {...actionIntent}]}));
const projectlessPlan = {...plan, brief: {...plan.brief, project_id: null, directory_name: 'projectless-output', native_environments: [null], child_route: 'native-task/projectless'}, authority: {...plan.authority, project_id: null, directory_name: 'projectless-output', environments: [null], child_route: 'native-task/projectless'}};
const projectlessIntent = {...actionIntent, project_id: null, directory_name: 'projectless-output', environment: null};
assert(validatePlan({...projectlessPlan, native_action_intents: [projectlessIntent]}));
assert.throws(() => validatePlan({...projectlessPlan, native_action_intents: [{...projectlessIntent, directory_name: null}]}));
const confirmedIntent = {...actionIntent, result: 'confirmed'};
const actionReceipt = {action_key: actionIntent.action_key, action: 'message', target_ref: 'executorA', observed_effect_ref: 'handoff-a', authority_source_ref: 'message-brief-go', plan_id: 'plan-a', plan_revision: 1, intent_revision: 1, epoch: 1, result: 'confirmed', evidence_ref: 'thread-read-a'};
assert(validatePlan({...plan, native_action_intents: [confirmedIntent], native_action_receipts: [actionReceipt]}));
assert.throws(() => validatePlan({...plan, native_action_intents: [actionIntent], native_action_receipts: [actionReceipt]}));
assert.throws(() => validatePlan({...plan, native_action_receipts: [actionReceipt]}));
assert.throws(() => validatePlan({...plan, native_action_intents: [confirmedIntent], native_action_receipts: [{...actionReceipt, epoch: 2}]}));
assert.throws(() => validatePlan({...plan, native_action_intents: [confirmedIntent], native_action_receipts: [{...actionReceipt, intent_revision: 2}]}));
assert.throws(() => validatePlan({...plan, native_action_intents: [confirmedIntent], native_action_receipts: [{...actionReceipt, observed_effect_ref: 'wrong-effect'}]}));
assert.throws(() => validatePlan({...plan, native_action_intents: [confirmedIntent], native_action_receipts: [actionReceipt, {...actionReceipt}]}));
assert.throws(() => validatePlan({...plan, native_action_intents: [confirmedIntent], native_action_receipts: [{...actionReceipt, evidence_ref: ''}]}));

function bootstrapDecision(intentExists, observed, boundedReconciliationComplete = false) {
  const exact = observed.filter(item => item === 'exact-destination' || item === 'alternate-destination');
  if (intentExists && observed.length === 1 && exact.length === 1) return 'ADOPT';
  if (observed.length > 0) return 'PAUSE_UNPROVEN_OR_CONFLICTING';
  if (!intentExists) return 'WRITE_BOOTSTRAP_INTENT_AND_CREATE_ONCE';
  return boundedReconciliationComplete ? 'PAUSE_BOOTSTRAP_DISPATCH_AMBIGUOUS' : 'PENDING';
}
assert.strictEqual(bootstrapDecision(false, []), 'WRITE_BOOTSTRAP_INTENT_AND_CREATE_ONCE');
assert.strictEqual(bootstrapDecision(false, ['exact-destination']), 'PAUSE_UNPROVEN_OR_CONFLICTING');
assert.strictEqual(bootstrapDecision(true, []), 'PENDING');
assert.strictEqual(bootstrapDecision(true, [], true), 'PAUSE_BOOTSTRAP_DISPATCH_AMBIGUOUS');
assert.strictEqual(bootstrapDecision(true, ['exact-destination']), 'ADOPT');
assert.strictEqual(bootstrapDecision(true, ['alternate-destination']), 'ADOPT');
assert.strictEqual(bootstrapDecision(true, ['exact-destination', 'alternate-destination']), 'PAUSE_UNPROVEN_OR_CONFLICTING');
assert.strictEqual(bootstrapDecision(true, ['wrong-project']), 'PAUSE_UNPROVEN_OR_CONFLICTING');

function reviewClass(effect, secondOrthogonalDomain = false) {
  const material = new Set(['product', 'code', 'security', 'privacy', 'data', 'migration', 'public']);
  if (secondOrthogonalDomain) return 'specialist';
  return material.has(effect) ? 'independent' : 'targeted';
}
assert.strictEqual(reviewClass('code'), 'independent');
assert.strictEqual(reviewClass('security'), 'independent');
assert.strictEqual(reviewClass('documentation'), 'targeted');
assert.strictEqual(reviewClass('code', true), 'specialist');

function mustPause(reason) { return pauseReasons.has(reason); }
for (const reason of pauseReasons) assert(mustPause(reason));
for (const warning of ['missing-structured-content', 'incomplete-response', 'display-drift', 'tool-incident', 'recoverable-write']) assert(!mustPause(warning));

function authorityCovers(authority, actor, action) {
  const identity = authority.project_id === null ? actor.project_id === null && authority.directory_name === actor.directory_name : authority.project_id === actor.project_id;
  const provenance = actor.adopted_session_ref === null || authority.adopted_session_refs.includes(actor.adopted_session_ref);
  return authority.delivery && authority.actions.includes(action) && identity && authority.environments.includes(actor.environment) && authority.roles.includes(actor.role) && provenance;
}
const authorityActor = {project_id: 'project-a', directory_name: null, environment: 'local', role: 'executor', adopted_session_ref: null};
assert(authorityCovers(plan.authority, authorityActor, 'message'));
assert(!authorityCovers(plan.authority, authorityActor, 'delete'));
assert(!authorityCovers(plan.authority, {...authorityActor, project_id: 'project-b'}, 'message'));
assert(!authorityCovers(plan.authority, {...authorityActor, role: 'planner'}, 'message'));
assert(!authorityCovers(plan.authority, {...authorityActor, adopted_session_ref: 'adopted-a'}, 'message'));
assert(authorityCovers({...plan.authority, adopted_session_refs: ['adopted-a']}, {...authorityActor, adopted_session_ref: 'adopted-a'}, 'message'));
assert(!authorityCovers({...plan.authority, delivery: false}, authorityActor, 'message'));

function beginReplan(previous) {
  return {...previous, status: 'replanning', proposed_revision: previous.revision + 1, proposed_review: null, acceptedPasses: []};
}
const replanned = beginReplan({...plan, acceptedPasses: ['pass-a']});
assert.strictEqual(replanned.revision, 1);
assert.strictEqual(replanned.proposed_revision, 2);
assert.deepStrictEqual(replanned.acceptedPasses, []);
assert.strictEqual(replanned.proposed_review, null);

function eligibleSafeReady(tasks, capacity, active = []) {
  const occupied = new Set(active.flatMap(task => task.conflicts));
  const eligible = tasks
    .filter(task => task.ready && task.authorized && task.routeAvailable && task.withinBudget && !task.checkpointBlocked)
    .sort((a, b) => a.criticalRank - b.criticalRank);
  const selected = [];
  for (const task of eligible) {
    if (selected.length >= capacity) break;
    if (task.conflicts.some(key => occupied.has(key))) continue;
    selected.push(task);
    task.conflicts.forEach(key => occupied.add(key));
  }
  return selected.map(task => task.ref);
}
const frontier = [
  {ref: 'E01', criticalRank: 1, ready: true, authorized: true, routeAvailable: true, withinBudget: true, checkpointBlocked: false, conflicts: ['file:a']},
  {ref: 'E02', criticalRank: 2, ready: true, authorized: true, routeAvailable: true, withinBudget: true, checkpointBlocked: false, conflicts: ['file:b']},
  {ref: 'E03', criticalRank: 3, ready: true, authorized: true, routeAvailable: true, withinBudget: true, checkpointBlocked: false, conflicts: ['file:c']},
  {ref: 'E04', criticalRank: 4, ready: true, authorized: true, routeAvailable: true, withinBudget: true, checkpointBlocked: false, conflicts: ['file:a']},
  {ref: 'E05', criticalRank: 5, ready: true, authorized: true, routeAvailable: true, withinBudget: true, checkpointBlocked: true, conflicts: ['file:d']}
];
assert.deepStrictEqual(eligibleSafeReady(frontier, 2), ['E01', 'E02']);
assert.deepStrictEqual(eligibleSafeReady(frontier.slice(2), 1), ['E03']);
assert.deepStrictEqual(eligibleSafeReady(frontier, 2, [{conflicts: ['file:a']}]), ['E02', 'E03']);

function correctionDecision(history, findingKey) {
  const repeats = history.filter(item => item.verdict === 'REVISE' && item.findingKey === findingKey).length;
  return repeats >= 2 ? 'DIAGNOSE_PLAN_TOOL_VERIFIER_ROUTE' : 'TARGETED_CORRECTION';
}
assert.strictEqual(correctionDecision([{verdict: 'REVISE', findingKey: 'stable-a'}], 'stable-a'), 'TARGETED_CORRECTION');
assert.strictEqual(correctionDecision([{verdict: 'REVISE', findingKey: 'stable-a'}, {verdict: 'REVISE', findingKey: 'stable-a'}], 'stable-a'), 'DIAGNOSE_PLAN_TOOL_VERIFIER_ROUTE');

function observableBudgets(telemetry) {
  const result = {};
  for (const key of ['tokens', 'tool_calls', 'compactions']) if (telemetry[key] === true) result[key] = 1;
  return result;
}
assert.deepStrictEqual(observableBudgets({tokens: false, tool_calls: true, compactions: false}), {tool_calls: 1});
assert.deepStrictEqual(observableBudgets({}), {});

function needsNewHumanGo(change) {
  return ['scope', 'target', 'risk', 'newProtectedAction'].some(key => change[key] === true);
}
assert.strictEqual(needsNewHumanGo({technicalHeadChanged: true, content: true, effectiveDiff: true, blockingReview: true, requiredValidation: true}), false);
assert.strictEqual(needsNewHumanGo({scope: true}), true);
assert.strictEqual(needsNewHumanGo({target: true}), true);
assert.strictEqual(needsNewHumanGo({risk: true}), true);
assert.strictEqual(needsNewHumanGo({newProtectedAction: true}), true);

function recoveryDecision(incident, proposedRemedy = null) {
  assert(typeof incident.key === 'string' && incident.key.length > 0);
  if (incident.previousKey && incident.previousKey !== incident.key) return 'REJECT_KEY_RESET';
  if (incident.unsafe || incident.protectedAction || incident.scopeChanged || incident.targetChanged || incident.riskChanged) return 'STOP_IMMEDIATELY';
  const attempts = new Set((incident.attempts || []).map(item => item.remedyKey));
  if ((incident.receipts || []).some(item => item.result === 'confirmed')) return 'RESUME';
  if (!proposedRemedy) return attempts.size >= 2 ? 'PAUSE_EXHAUSTED' : 'PROPOSE_SAFE_REMEDY';
  if (attempts.has(proposedRemedy)) return 'NO_REPLAY_OR_RESET';
  return attempts.size >= 2 ? 'PAUSE_EXHAUSTED' : 'TRY_AND_RECEIPT';
}
const incident = {key: 'incident-a', attempts: []};
assert.strictEqual(recoveryDecision(incident), 'PROPOSE_SAFE_REMEDY');
assert.strictEqual(recoveryDecision(incident, 'repair-a'), 'TRY_AND_RECEIPT');
const once = {...incident, attempts: [{remedyKey: 'repair-a'}]};
assert.strictEqual(recoveryDecision({...once, wake: true, wording: 'changed'}, 'repair-a'), 'NO_REPLAY_OR_RESET');
assert.strictEqual(recoveryDecision(once, 'repair-b'), 'TRY_AND_RECEIPT');
const exhausted = {...incident, attempts: [{remedyKey: 'repair-a'}, {remedyKey: 'repair-b'}]};
assert.strictEqual(recoveryDecision(exhausted), 'PAUSE_EXHAUSTED');
assert.strictEqual(recoveryDecision(exhausted, 'repair-c'), 'PAUSE_EXHAUSTED');
assert.strictEqual(recoveryDecision({...once, receipts: [{result: 'confirmed'}]}), 'RESUME');
assert.strictEqual(recoveryDecision({...once, unsafe: true}), 'STOP_IMMEDIATELY');
assert.strictEqual(recoveryDecision({...once, protectedAction: true}), 'STOP_IMMEDIATELY');
assert.strictEqual(recoveryDecision({...once, previousKey: 'incident-original', key: 'incident-reworded'}), 'REJECT_KEY_RESET');

console.log('PASS: Octoplan 13.1 Fable-alignment fixtures');
NODE

grep -q '^### 13\.1\.0 — 2026-08-11$' "$changelog" || fail 'Codex changelog lacks 13.1.0'

printf 'PASS: Octoplan Codex 13.1.0 contract\n'
