#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
codex_only=${OCTOPLAN_CODEX_ONLY:-false}
codex_shared_reviewed=" ${OCTOPLAN_CODEX_SHARED_REVIEWED:-} "
skill="$root/plugins/octoplan-codex/skills/octoplan"
planning="$skill/references/planning.md"
state="$skill/references/state-and-recovery.md"
runtime="$skill/references/codex-runtime.md"
supervision="$skill/references/codex-supervision.md"
compatibility="$skill/references/octoplan-contract-v5.md"
roles="$skill/roles"
manifest="$root/plugins/octoplan-codex/.codex-plugin/plugin.json"
agent_manifest="$skill/agents/openai.yaml"
changelog="$root/CHANGELOG.md"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

case "$codex_only" in
  true|false) ;;
  *) fail 'OCTOPLAN_CODEX_ONLY must be true or false' ;;
esac

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

grep -q '^Version: 15\.0\.0$' "$skill/SKILL.md" || fail 'Codex SKILL.md is not 15.0.0'
grep -q '"version": "15\.0\.0"' "$manifest" || fail 'Codex plugin is not 15.0.0'
if [ "$codex_only" = false ]; then
  grep -Fq '| [`octoplan-codex`](plugins/octoplan-codex/skills/octoplan/SKILL.md) | Codex | 15.0.0 |' "$root/README.md" || fail 'README Codex version is stale'
fi

expected_refs='codex-runtime.md
codex-supervision.md
octoplan-contract-v3.md
octoplan-contract-v4.md
octoplan-contract-v5.md
planning.md
state-and-recovery.md'
actual_refs=$(find "$skill/references" -maxdepth 1 -type f -name '*.md' -exec basename '{}' \; | sort)
[ "$actual_refs" = "$expected_refs" ] || fail 'unexpected Codex reference set'
require_text "$compatibility" '# Octoplan v5 compatibility'
require_text "$compatibility" 'Do not translate old fingerprints'
require_text "$compatibility" 'adopt a compatible installed update only at a safe boundary'
require_text "$compatibility" 'Installing v15 does not change a running legacy task.'
require_text "$compatibility" 'Version 15.0 is breaking'

active_docs="$skill/SKILL.md $planning $state $runtime $supervision"
for forbidden in 'octoplan-supervision-v6' 'octoplan-fingerprint-v' 'octopad-direct-readback-v1' 'canonical review-subject' 'saved-state equality' 'byte-deterministic' 'plan_hash' 'record Octopad `waiting-human`' 'update Octopad to `waiting-human`' 'writes Octopad `completed`'; do
  if grep -Fq "$forbidden" $active_docs; then
    fail "retired blocking contract remains active: $forbidden"
  fi
done
require_text "$skill/SKILL.md" 'references/octoplan-contract-v5.md'
require_text "$planning" '[octoplan-contract-v5.md](octoplan-contract-v5.md)'

skill_lines=$(wc -l < "$skill/SKILL.md" | tr -d ' ')
planning_lines=$(wc -l < "$planning" | tr -d ' ')
state_lines=$(wc -l < "$state" | tr -d ' ')
runtime_lines=$(wc -l < "$runtime" | tr -d ' ')
supervision_lines=$(wc -l < "$supervision" | tr -d ' ')
[ "$skill_lines" -le 45 ] || fail "SKILL.md exceeds 45 lines: $skill_lines"
[ "$planning_lines" -le 125 ] || fail "planning.md exceeds 125 lines: $planning_lines"
[ "$state_lines" -le 195 ] || fail "state-and-recovery.md exceeds 195 lines: $state_lines"
[ "$runtime_lines" -le 110 ] || fail "codex-runtime.md exceeds 110 lines: $runtime_lines"
[ "$supervision_lines" -le 150 ] || fail "codex-supervision.md exceeds 150 lines: $supervision_lines"
active_lines=$((skill_lines + planning_lines + state_lines + runtime_lines + supervision_lines))
active_words=$(wc -w $active_docs | awk 'END {print $1}')
[ "$active_lines" -le 565 ] || fail "active skill documents exceed 565 lines: $active_lines"
[ "$active_words" -le 9300 ] || fail "active skill documents exceed 9300 words: $active_words"

for toc_file in "$planning" "$state" "$runtime" "$supervision"; do
  require_text "$toc_file" '## Contents'
done
require_text "$skill/SKILL.md" 'Only `octoplan-plan-v5` is supported.'
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
require_text "$planning" '`roles/planner.md` is for a delegated planner that cannot ask the user'
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
require_text "$state" '"schema": "octoplan-plan-v5"'
require_text "$state" '"proposed_review": null'
require_text "$state" '"status": "planning|planned|active|replanning|waiting-human|paused|completed|superseded"'
require_text "$state" '"review_cadence": "progressive|final"'
require_text "$state" '"execution_scope": "plan-only|deliver-authorized"'
require_text "$state" '"octopad_write_classes": ['
require_text "$state" '"native_actions": ['
require_text "$state" '"child_route": "native-task/worktree"'
require_text "$state" '"brief_records": {'
require_text "$state" '"minimum_version": "15.0.0"'
require_text "$state" '"legacy_migration": null'
require_text "$state" '"task_generation": 1'
require_text "$state" '"manifest_hash"'
require_text "$state" '`actor_binding_readback`'
require_text "$state" '"full_independent_fresh|targeted_recheck"'
require_text "$state" '"intent": {"revision": 1'
require_text "$state" '"human_checkpoints": ['
require_text "$state" 'methodology|secret|access-grant|external-spend|destructive-effect|review|merge|migration-application|deployment|publication|acceptance'
require_text "$state" '"heartbeat": null'
require_text "$state" '"actions": ["create", "message", "archive"]'
require_text "$state" '`active -> fence-pending -> fenced -> terminal-reconciled -> archived|archive-pending`'
require_text "$state" '`archive_receipt`'
require_text "$state" '`archive_incident_ref`'
require_text "$state" 'final success waits'
require_text "$state" 'first increment `intent.revision` under `expected_updated_at`'
require_text "$state" 'compatible installed v5 update'
require_text "$state" 'OCTOPLAN_WRITE_INTENT <operation-key>'
require_text "$state" '`structuredContent` is useful when present but never mandatory.'
require_text "$state" 'Never replay the whole batch because one item is unclear.'
require_text "$state" 'Before every create, work-message, source effect, or archive'
require_text "$state" "receipts match the actor's historical binding tuple"
require_text "$state" 'message revised work before durable intent/generation state exists.'
require_text "$state" 'never blind replay'
require_text "$state" '"native_action_receipts": []'
require_text "$state" '"mode": "current-task|dedicated-handoff|recovery-successor"'
require_text "$state" '"predecessor": null'
require_text "$state" '"supersedes_goal_ref": null'
require_text "$state" '"effects_quiescent_ref":"<post-fence evidence>"'
require_text "$state" '"fence_key":"<plan_id>:takeover:epoch:2"'
require_text "$state" 'OCTOPLAN_TAKEOVER_INTENT'
require_text "$state" 'derive `fence_key` exactly as `<plan_id>:takeover:epoch:<predecessor_epoch+1>`'
require_text "$state" 'atomically fences the predecessor by setting owner, recovery mode, incremented epoch, predecessor, `paused`, and successor Goal `pending`'
require_text "$state" 'Reread it, then obtain fresh post-fence quiescence before Goal creation.'
require_text "$state" 'The predecessor Goal stays historical.'
require_text "$state" 'Targeted recovery'
require_text "$state" '`projectId=null`'
require_text "$state" '"active_lease_ref": "planner-lease-1"'
require_text "$state" '"context_admissions": {}'
require_text "$state" '"context_admission": {"plan_revision": 1'
require_text "$state" '"delegation_boundaries": []'
require_text "$state" '"delivery_artifacts": {'
require_text "$state" '"baseline_leases": {'
require_text "$state" '"efficiency": {'
require_text "$state" 'a third comparable resume without accepted progress cannot reuse'
require_text "$state" 'an unhealthy Goal owner pauses substantive analysis/effects'
require_text "$state" 'A draft is valid only with exact base/head, owner, next transition, blocker/resume predicate, disposition, and readback.'
require_text "$runtime" 'A Goal never grants broader sandbox, approval, or external-effect authority.'
require_text "$runtime" 'Persisted authority must match that disclosure.'
require_text "$runtime" 'The only valid automatic routes are Luna `max` and Sol `high|xhigh|max`'
require_text "$runtime" 'A supervisor needs observed Sol `high` or above'
require_text "$runtime" 'Terra, Luna below `max`, Sol below `high`, unknown, and unavailable pairs pause'
require_text "$runtime" '`actor_binding_readback`'
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
require_text "$runtime" 'minimum version'
require_text "$runtime" 'Product, code, security, privacy, data, migration, and materially public changes require `independent`.'
require_text "$runtime" 'one additional fresh reviewer only for a second material and orthogonal failure domain'
require_text "$runtime" 'Material replanning and volumetric diagnosis always use a fresh PLN lease'
require_text "$runtime" 'non-overlapping drift alone never invalidates accepted work or forces a treadmill'
require_text "$supervision" "Use Octopad's graph/statuses directly"
require_text "$supervision" 'Never send `waiting-human` or `paused` as an Octopad task status.'
require_text "$supervision" 'A delivery task is `todo` until claimed, `in_progress` from claim through review and embedded checkpoints'
require_text "$supervision" '`parallel_safe_now`'
require_text "$supervision" 'reread `intent.revision` before the next external effect'
require_text "$supervision" 'compact cursor-based `wait_threads`'
require_text "$supervision" 'at most one heartbeat per plan'
require_text "$supervision" 'never embed a copied blocker'
require_text "$supervision" 'After two `REVISE` with the same key'
require_text "$supervision" 'global integrated-outcome evidence'
require_text "$supervision" 'never retry to improve a response'
require_text "$supervision" '`<PREFIX>-<short-work-stream-name>-<short-task-name>`'
require_text "$supervision" '`SUP` supervisor'
require_text "$supervision" '`EX` executor/follow-up'
require_text "$supervision" '`PLN` planner/recovery'
require_text "$supervision" '`REV` plan/lead/specialist reviewer'
require_text "$supervision" 'every completed executor is archived'
require_text "$supervision" 'Use $octoplan as <role>'
require_text "$supervision" 'Once an unfinished Goal exists, never claim to transfer or fence it through an unsupported primitive'
require_text "$supervision" 'Accept only explicit verdicts with typed review evidence.'
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
require_text "$supervision" 'fresh post-fence `effects_quiescent_ref`'
require_text "$supervision" 'First persist `OCTOPLAN_TAKEOVER_INTENT`'
require_text "$supervision" 'one guarded update then fences the predecessor by rotating owner/mode/epoch and records a pending successor Goal'
require_text "$supervision" 'After successful readback, obtain a fresh post-fence `effects_quiescent_ref`; only then create'
require_text "$supervision" 'The old Goal is historical, never falsely completed or blocked'
require_text "$supervision" 'owning E task'
require_text "$supervision" 'reviewer sessions versus passes'
require_text "$supervision" 'Keep the supervisor thin'
require_text "$supervision" 'a third such resume must replace or pause rather than reuse'
require_text "$supervision" 'open a structured `replan|efficiency` incident'
require_text "$supervision" 'A draft without this record is orphan debt'
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
require_text "$roles/plan-reviewer.md" 'typed verdict'
require_text "$roles/plan-reviewer.md" 'Only Luna `max` or Sol `high|xhigh|max` is admissible'
require_text "$roles/plan-reviewer.md" 'unavailable, or unobserved routes pause'
require_text "$roles/planner.md" 'planner lease'
require_text "$roles/planner.md" 'Never read predecessor conversation or unbounded raw history.'
require_text "$roles/supervisor.md" 'Stay thin'

[ "$(grep -Fc '| Work profile |' "$runtime")" -eq 1 ] || fail 'capacity ladder is duplicated or missing'
[ "$(grep -Ec '^\| .*`gpt-5\.6-' "$runtime")" -eq 4 ] || fail 'capacity ladder does not have four routes'

changes_file=$(mktemp "${TMPDIR:-/tmp}/octoplan-changes.XXXXXX")
trap 'rm -f "$changes_file"' EXIT HUP INT TERM
{
  git -C "$root" diff --no-renames --no-ext-diff --no-textconv --name-only origin/main
  git -C "$root" diff --no-renames --no-ext-diff --no-textconv --cached --name-only
  git -C "$root" ls-files --others --exclude-standard
} | sort -u > "$changes_file"

private_material_pattern="/""Users/|[[:alnum:]._%+-]+@[[:alnum:].-]+\.[[:alpha:]]{2,}|BEGIN (RSA |OPENSSH |EC )?PRIVATE KEY"
shared_release=false
if [ "$codex_only" = false ]; then
  origin_claude_version=$(git -C "$root" show origin/main:plugins/octoplan-claude/skills/octoplan/SKILL.md | sed -n 's/^Version: //p')
  current_claude_version=$(sed -n 's/^Version: //p' "$root/plugins/octoplan-claude/skills/octoplan/SKILL.md")
  if [ "$origin_claude_version" != "$current_claude_version" ] && [ "$current_claude_version" = "2.0.0" ]; then
    shared_release=true
  fi
fi
while IFS= read -r changed; do
  skip_content_audit=false
  case "$changed" in
    plugins/octoplan-claude/.claude-plugin/plugin.json|plugins/octoplan-claude/skills/octoplan/SKILL.md)
      [ "$shared_release" = true ] || fail "protected Claude surface changed without a versioned shared release: $changed"
      ;;
    .claude-plugin|.claude-plugin/*|plugins/octoplan-claude|plugins/octoplan-claude/*|docs/clients/claude.md|docs/clients/claude-code.md)
      fail "protected Claude surface changed: $changed"
      ;;
  esac
  if [ "$codex_only" = true ]; then
    case "$changed" in
      CHANGELOG.md|README.md|INSTALL.md|CONTRIBUTING.md|scripts/validate-repository.sh|docs/clients/*)
        staged_entry=$(git -C "$root" ls-files --stage -- "$changed")
        staged_oid=$(printf '%s\n' "$staged_entry" | awk '$3 == "0" {print $2}')
        base_oid=$(git -C "$root" ls-tree origin/main -- "$changed" | awk '{print $3}')
        [ -n "$staged_oid" ] && [ "$staged_oid" != "$base_oid" ] || fail "shared surface is not staged as a reviewed change: $changed"
        case "$codex_shared_reviewed" in
          *" $changed=$staged_oid "*) skip_content_audit=true ;;
          *) fail "shared surface lacks an exact staged-blob review receipt: $changed=$staged_oid" ;;
        esac
        ;;
    esac
  fi
  if [ "$skip_content_audit" = false ] && [ -f "$root/$changed" ] && grep -E "$private_material_pattern" "$root/$changed" >/dev/null 2>&1; then
    fail "private or identifying material appears in public file: $changed"
  fi
done < "$changes_file"

if [ "$codex_only" = false ]; then
  origin_claude=$(git -C "$root" show origin/main:CHANGELOG.md | sed -n '/^## octoplan-claude$/,$p')
  current_claude=$(sed -n '/^## octoplan-claude$/,$p' "$changelog")
  if [ "$shared_release" = false ]; then
    [ "$origin_claude" = "$current_claude" ] || fail 'Claude changelog section changed without a versioned shared release'
  else
    grep -q '"version": "2\.0\.0"' "$root/plugins/octoplan-claude/.claude-plugin/plugin.json" || fail 'shared Claude manifest is not 2.0.0'
    grep -Fq 'EX-<short-work-stream-name>-<short-task-name>' "$root/plugins/octoplan-claude/skills/octoplan/SKILL.md" || fail 'shared Claude title contract is missing'
    grep -Fq 'archive pending' "$root/plugins/octoplan-claude/skills/octoplan/SKILL.md" || fail 'shared Claude archive recovery contract is missing'
  fi
fi

node <<'NODE'
const assert = require('assert');

const materialFields = new Set(['outcome', 'candidate', 'scope', 'success', 'taskMeaning', 'splitMerge', 'outputs', 'dependencies', 'parallelism', 'budgets', 'humanCheckpoints', 'owner', 'route', 'authority', 'acceptance', 'artifactContract']);
const pauseReasons = new Set(['wrong-target', 'identity-unresolved', 'unreconcilable-duplicate', 'bootstrap-dispatch-ambiguous', 'creation-dispatch-ambiguous', 'missing-authority', 'proven-missing-write', 'revision-conflict', 'human-checkpoint', 'human-decision']);
const checkpointKinds = new Set(['methodology', 'secret', 'access-grant', 'external-spend', 'destructive-effect', 'review', 'merge', 'migration-application', 'deployment', 'publication', 'acceptance']);
const octopadWriteClasses = new Set(['work-stream', 'tracker', 'task', 'dependency', 'decision', 'question', 'comment', 'coordination-state']);
const runStatuses = new Set(['planning', 'planned', 'active', 'replanning', 'waiting-human', 'paused', 'completed', 'superseded']);
const actorRoles = new Set(['supervisor', 'planner', 'executor', 'reviewer', 'specialist-reviewer', 'recovery', 'follow-up']);
const actorStates = new Set(['created-pending', 'active', 'awaiting-review', 'correction-needed', 'handoff-pending', 'fence-pending', 'fenced', 'terminal-reconciled', 'archive-pending', 'archived']);
const allowedEfforts = new Set(['low', 'medium', 'high', 'xhigh', 'max']);

function validChildRoute(model, effort) {
  if (!allowedEfforts.has(effort)) return false;
  return (model === 'gpt-5.6-luna' && effort === 'max') || (model === 'gpt-5.6-sol' && ['high', 'xhigh', 'max'].includes(effort));
}
function childRouteDecision(model, effort, available = true) {
  if (!validChildRoute(model, effort) || !available) return 'PAUSE_CORRECT_OR_REPLAN';
  return 'USE_EXACT';
}
assert.strictEqual(childRouteDecision('gpt-5.6-luna', 'max'), 'USE_EXACT');
for (const effort of ['low', 'medium', 'high', 'xhigh']) assert.strictEqual(childRouteDecision('gpt-5.6-luna', effort), 'PAUSE_CORRECT_OR_REPLAN');
for (const effort of allowedEfforts) assert.strictEqual(childRouteDecision('gpt-5.6-terra', effort), 'PAUSE_CORRECT_OR_REPLAN');
for (const effort of ['low', 'medium']) assert.strictEqual(childRouteDecision('gpt-5.6-sol', effort), 'PAUSE_CORRECT_OR_REPLAN');
for (const effort of ['high', 'xhigh', 'max']) assert.strictEqual(childRouteDecision('gpt-5.6-sol', effort), 'USE_EXACT');
assert.strictEqual(childRouteDecision('gpt-5.6-unknown', 'max'), 'PAUSE_CORRECT_OR_REPLAN');
assert.strictEqual(childRouteDecision('gpt-5.6-sol', 'high', false), 'PAUSE_CORRECT_OR_REPLAN');

function sameMembers(left, right) {
  return Array.isArray(left) && Array.isArray(right) && left.length === right.length && left.every(value => right.includes(value)) && new Set(left).size === left.length && new Set(right).size === right.length;
}

function validatePlan(plan) {
  assert.strictEqual(plan.schema, 'octoplan-plan-v5');
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
  assert(['full_independent_fresh', 'targeted_recheck'].includes(plan.review.review_type));
  assert(typeof plan.review.reviewer_session_ref === 'string' && plan.review.reviewer_session_ref.length > 0);
  assert(plan.review.task_generations && Object.entries(plan.review.task_generations).every(([ref, generation]) => /^E[0-9]+$/.test(ref) && Number.isInteger(generation) && generation > 0));
  assert(typeof plan.review.planned_route === 'string' && plan.review.planned_route === plan.review.observed_route);
  const [reviewModel, reviewEffort] = plan.review.observed_route.split('/');
  assert(validChildRoute(reviewModel, reviewEffort));
  assert(typeof plan.review.route_evidence_ref === 'string' && plan.review.route_evidence_ref.length > 0);
  assert(typeof plan.review.artifact_hash === 'string' && plan.review.artifact_hash.length > 0);
  assert(Array.isArray(plan.review.finding_keys) && Array.isArray(plan.review.executed_checks) && plan.review.executed_checks.length > 0);
  assert(typeof plan.review.evidence_ref === 'string' && plan.review.evidence_ref.length > 0);
  assert(plan.planning && typeof plan.planning.candidate_hash === 'string' && plan.planning.candidate_hash === plan.review.artifact_hash);
  assert(typeof plan.planning.source_snapshot_hash === 'string' && plan.planning.source_snapshot_hash.length > 0);
  assert(typeof plan.planning.active_lease_ref === 'string' && Array.isArray(plan.planning.leases) && plan.planning.leases.length > 0);
  const plannerLeaseRefs = new Set();
  const plannerSessionRefs = new Set();
  const plannerFreshSessionReceipts = new Set();
  for (const lease of plan.planning.leases) {
    for (const key of ['lease_ref', 'session_ref', 'fresh_session_receipt', 'candidate_hash', 'input_snapshot_hash', 'planned_route', 'observed_route', 'route_evidence_ref', 'binding_readback_ref', 'prior_artifact_disposition_ref']) assert(typeof lease[key] === 'string' && lease[key].length > 0);
    assert(!plannerLeaseRefs.has(lease.lease_ref));
    assert(!plannerSessionRefs.has(lease.session_ref));
    assert(!plannerFreshSessionReceipts.has(lease.fresh_session_receipt));
    plannerLeaseRefs.add(lease.lease_ref);
    plannerSessionRefs.add(lease.session_ref);
    plannerFreshSessionReceipts.add(lease.fresh_session_receipt);
    assert(Number.isInteger(lease.plan_revision) && lease.plan_revision > 0 && lease.plan_revision <= (plan.proposed_revision ?? plan.revision));
    assert(Number.isInteger(lease.intent_revision) && lease.intent_revision > 0 && lease.intent_revision <= plan.intent.revision);
    assert(lease.planned_route === lease.observed_route);
    const [plannerModel, plannerEffort] = lease.observed_route.split('/');
    assert(plannerModel === 'gpt-5.6-sol' && ['xhigh', 'max'].includes(plannerEffort));
    assert(['active', 'adopted', 'rejected', 'expired'].includes(lease.status));
    if (lease.status === 'active') assert.strictEqual(lease.output_hash, null);
    else if (lease.status === 'adopted') assert.strictEqual(lease.output_hash, lease.candidate_hash);
    else assert(lease.output_hash === null || (typeof lease.output_hash === 'string' && lease.output_hash.length > 0));
  }
  const selectedPlannerLease = plan.planning.leases.find(lease => lease.lease_ref === plan.planning.active_lease_ref);
  assert(selectedPlannerLease);
  assert.strictEqual(selectedPlannerLease.candidate_hash, plan.planning.candidate_hash);
  assert(selectedPlannerLease.input_snapshot_hash === plan.planning.source_snapshot_hash);
  assert.strictEqual(selectedPlannerLease.intent_revision, plan.intent.revision);
  if (plan.status === 'replanning') {
    assert.strictEqual(selectedPlannerLease.status, 'active');
    assert.strictEqual(selectedPlannerLease.plan_revision, plan.proposed_revision);
  } else {
    assert.strictEqual(selectedPlannerLease.status, 'adopted');
    assert.strictEqual(selectedPlannerLease.plan_revision, plan.revision);
  }
  assert(plan.planning.leases.filter(lease => lease.status === 'active').length <= 1);
  assert(plan.runtime && /^15\.[0-9]+\.[0-9]+$/.test(plan.runtime.minimum_version));
  for (const key of ['loaded_version', 'installed_version']) assert(/^15\.[0-9]+\.[0-9]+$/.test(plan.runtime[key]));
  assert(Number.isFinite(Date.parse(plan.runtime.admission_checked_at)));
  assert(plan.runtime.supervisor_route && plan.runtime.supervisor_route.admission === 'PASS');
  assert(plan.runtime.supervisor_route.planned === plan.runtime.supervisor_route.observed);
  assert(typeof plan.runtime.supervisor_route.evidence_ref === 'string' && plan.runtime.supervisor_route.evidence_ref.length > 0);
  const [supervisorModel, supervisorEffort] = plan.runtime.supervisor_route.observed.split('/');
  assert(supervisorModel === 'gpt-5.6-sol' && ['high', 'xhigh', 'max'].includes(supervisorEffort));
  assert(Object.prototype.hasOwnProperty.call(plan, 'legacy_migration'));
  assert(plan.intent && Number.isInteger(plan.intent.revision) && plan.intent.revision > 0);
  assert(typeof plan.intent.latest_user_directive_ref === 'string' && Array.isArray(plan.intent.superseded_effect_keys));
  assert(plan.supervisor && typeof plan.supervisor.thread_ref === 'string' && plan.supervisor.thread_ref.length > 0);
  assert(Number.isInteger(plan.supervisor.epoch) && plan.supervisor.epoch > 0);
  assert(['current-task', 'dedicated-handoff', 'recovery-successor'].includes(plan.supervisor.mode));
  if (plan.supervisor.mode === 'dedicated-handoff') assert(typeof plan.supervisor.source_fenced_ref === 'string' && plan.supervisor.source_fenced_ref.length > 0);
  assert(Object.prototype.hasOwnProperty.call(plan.supervisor, 'predecessor'));
  const supervisorAdmission = plan.supervisor.context_admission;
  assert(supervisorAdmission && ['REUSE', 'REPLACE', 'PAUSE'].includes(supervisorAdmission.decision));
  assert.strictEqual(supervisorAdmission.plan_revision, plan.revision);
  assert.strictEqual(supervisorAdmission.intent_revision, plan.intent.revision);
  assert.strictEqual(supervisorAdmission.supervisor_epoch, plan.supervisor.epoch);
  assert(typeof supervisorAdmission.state_hash === 'string' && supervisorAdmission.state_hash.length > 0);
  for (const key of ['state_readback_ref', 'intent_readback_ref', 'evidence_ref']) assert(typeof supervisorAdmission[key] === 'string' && supervisorAdmission[key].length > 0);
  for (const key of ['accepted_progress_ref', 'compaction_ref']) assert(supervisorAdmission[key] === null || (typeof supervisorAdmission[key] === 'string' && supervisorAdmission[key].length > 0));
  assert(Number.isInteger(supervisorAdmission.resumes_since_progress) && supervisorAdmission.resumes_since_progress >= 0);
  if (supervisorAdmission.resumes_since_progress >= 3) assert.notStrictEqual(supervisorAdmission.decision, 'REUSE');
  if (['active', 'replanning'].includes(plan.status)) assert(['REUSE', 'PAUSE'].includes(supervisorAdmission.decision));
  if (supervisorAdmission.decision === 'REPLACE') assert(plan.status === 'paused' && plan.supervisor.mode === 'recovery-successor' && plan.supervisor.predecessor);
  assert(plan.supervisor.goal && typeof plan.supervisor.goal.required === 'boolean');
  assert(Object.prototype.hasOwnProperty.call(plan.supervisor.goal, 'supersedes_goal_ref'));
  if (plan.supervisor.mode === 'recovery-successor') {
    const predecessor = plan.supervisor.predecessor;
    assert(predecessor && Number.isInteger(predecessor.epoch) && predecessor.epoch > 0 && plan.supervisor.epoch > predecessor.epoch);
    for (const key of ['thread_ref', 'goal_evidence_ref', 'revival_ref', 'terminal_or_unreachable_ref', 'fence_key', 'fence_readback_ref', 'effects_quiescent_ref']) assert(typeof predecessor[key] === 'string' && predecessor[key].length > 0);
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
  if (plan.legacy_migration !== null) {
    const migration = plan.legacy_migration;
    assert(['octoplan-plan-v1', 'octoplan-plan-v2', 'octoplan-plan-v3', 'octoplan-plan-v4'].includes(migration.source_schema));
    for (const key of ['legacy_goal_ref', 'inventory_ref', 'fence_ref', 'quiescence_ref']) assert(typeof migration[key] === 'string' && migration[key].length > 0);
    assert(['active', 'blocked', 'complete'].includes(migration.legacy_goal_state));
    assert(['waiting-owner', 'human-decision', 'resolved'].includes(migration.route));
    if (migration.legacy_goal_state === 'complete') {
      assert.strictEqual(migration.route, 'resolved');
    } else {
      assert.strictEqual(plan.status, 'paused');
      assert.strictEqual(plan.supervisor.goal.state, 'pending');
      assert.strictEqual(plan.supervisor.goal.origin, null);
      assert.strictEqual(plan.supervisor.goal.evidence_ref, null);
      assert.notStrictEqual(migration.route, 'resolved');
    }
    if (migration.route === 'human-decision') assert(typeof migration.decision_ref === 'string' && migration.decision_ref.length > 0);
    else assert(migration.decision_ref === null || (typeof migration.decision_ref === 'string' && migration.decision_ref.length > 0));
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
  assert(plan.task_contracts && sameMembers(Object.keys(plan.task_contracts), [...refs].filter(ref => /^E/.test(ref))));
  for (const [ref, contract] of Object.entries(plan.task_contracts)) {
    assert(/^E[0-9]+$/.test(ref) && Number.isInteger(contract.task_generation) && contract.task_generation > 0);
    for (const key of ['contract_hash', 'manifest_ref', 'manifest_hash', 'base_stack_ref']) assert(typeof contract[key] === 'string' && contract[key].length > 0);
    assert(typeof contract.new_context_required === 'boolean');
    assert(['adopt', 'reject', 'rewrite'].includes(contract.artifact_disposition));
  }
  assert(sameMembers(Object.keys(plan.review.task_generations), Object.keys(plan.task_contracts)));
  assert(Object.entries(plan.review.task_generations).every(([ref, generation]) => plan.task_contracts[ref]?.task_generation === generation));
  assert(plan.stack_snapshots && typeof plan.stack_snapshots === 'object');
  for (const contract of Object.values(plan.task_contracts)) assert(plan.stack_snapshots[contract.base_stack_ref]);
  for (const snapshot of Object.values(plan.stack_snapshots)) {
    for (const key of ['main_sha', 'ancestry_ref', 'effective_diffs_ref', 'migration_registry_ref', 'checks_ref', 'verifier_coverage_ref', 'checked_at', 'fresh_until', 'admission_ref']) assert(typeof snapshot[key] === 'string' && snapshot[key].length > 0);
    assert(Array.isArray(snapshot.base_shas) && snapshot.base_shas.length > 0 && snapshot.base_shas.every(Boolean));
    assert(Array.isArray(snapshot.head_shas) && snapshot.head_shas.length > 0 && snapshot.head_shas.every(Boolean));
    assert(Number.isInteger(snapshot.ttl_seconds) && snapshot.ttl_seconds > 0);
    assert.strictEqual(snapshot.admission, 'PASS');
    const checkedAt = Date.parse(snapshot.checked_at);
    const freshUntil = Date.parse(snapshot.fresh_until);
    assert(Number.isFinite(checkedAt) && Number.isFinite(freshUntil) && checkedAt < freshUntil);
    const admissionCheckedAt = Date.parse(plan.runtime.admission_checked_at);
    assert(checkedAt <= admissionCheckedAt && freshUntil >= admissionCheckedAt);
    assert.strictEqual(freshUntil, checkedAt + snapshot.ttl_seconds * 1000);
  }
  assert(plan.baseline_leases && typeof plan.baseline_leases === 'object' && Object.keys(plan.baseline_leases).length > 0);
  for (const [leaseRef, lease] of Object.entries(plan.baseline_leases)) {
    assert.strictEqual(lease.lease_ref, leaseRef);
    assert(plan.task_contracts[lease.task_ref]);
    assert(Number.isInteger(lease.task_generation) && lease.task_generation > 0 && lease.task_generation <= plan.task_contracts[lease.task_ref].task_generation);
    assert(lease.actor_ref === null || (typeof lease.actor_ref === 'string' && lease.actor_ref.length > 0));
    assert(plan.stack_snapshots[lease.stack_snapshot_ref]);
    if (lease.task_generation === plan.task_contracts[lease.task_ref].task_generation) assert.strictEqual(lease.stack_snapshot_ref, plan.task_contracts[lease.task_ref].base_stack_ref);
    assert(['active', 'expired'].includes(lease.status));
    assert(['dispatch', 'first-effect', 'push', 'review', 'handoff', 'collision'].includes(lease.last_refresh_reason));
    assert(typeof lease.refresh_receipt_ref === 'string' && lease.refresh_receipt_ref.length > 0);
  }
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
    assert(validChildRoute(actor.model, actor.effort));
    const contract = plan.task_contracts[actor.task_ref];
    const actionable = !['fenced', 'terminal-reconciled', 'archive-pending', 'archived'].includes(actor.state);
    const contextAdmission = plan.context_admissions?.[actorRef];
    assert(contextAdmission && contextAdmission.actor_ref === actorRef);
    for (const key of ['binding_readback_ref', 'manifest_readback_ref', 'intent_readback_ref', 'evidence_ref']) assert(typeof contextAdmission[key] === 'string' && contextAdmission[key].length > 0);
    assert(['REUSE', 'REPLACE', 'PAUSE'].includes(contextAdmission.decision));
    assert(Number.isInteger(contextAdmission.resumes_since_progress) && contextAdmission.resumes_since_progress >= 0);
    for (const key of ['accepted_progress_ref', 'compaction_ref']) assert(contextAdmission[key] === null || (typeof contextAdmission[key] === 'string' && contextAdmission[key].length > 0));
    if (actionable) assert(contextAdmission.decision === 'REUSE' && contextAdmission.resumes_since_progress <= 2);
    assert(contract && actor.binding && actor.binding.plan_id === plan.plan_id && actor.binding.plan_revision <= plan.revision && actor.binding.intent_revision <= plan.intent.revision);
    assert(actor.binding.supervisor_epoch <= plan.supervisor.epoch && typeof actor.binding.authority_source_ref === 'string' && actor.binding.authority_source_ref.length > 0);
    assert(actor.binding.organization_id === plan.organization_id && actor.binding.workspace_id === plan.workspace_id && actor.binding.role === actor.role);
    assert(actor.binding.task_id === plan.task_ids[actor.task_ref] && actor.binding.task_generation <= contract.task_generation);
    if (actionable) {
      assert(actor.binding.plan_revision === plan.revision && actor.binding.intent_revision === plan.intent.revision && actor.binding.supervisor_epoch === plan.supervisor.epoch);
      assert(actor.binding.task_generation === contract.task_generation && actor.binding.contract_hash === contract.contract_hash && actor.binding.manifest_hash === contract.manifest_hash);
      assert(actor.binding.authority_source_ref === plan.authority.source_ref);
    }
    assert(actor.binding.model === actor.model && actor.binding.effort === actor.effort && actor.binding.observed_model === actor.model && actor.binding.observed_effort === actor.effort);
    assert(typeof actor.binding.readback_ref === 'string' && actor.binding.readback_ref.length > 0 && typeof actor.binding.route_evidence_ref === 'string' && actor.binding.route_evidence_ref.length > 0);
    const baselineLease = plan.baseline_leases[actor.binding.baseline_lease_ref];
    assert(baselineLease && baselineLease.actor_ref === actorRef && baselineLease.task_ref === actor.task_ref && baselineLease.task_generation === actor.binding.task_generation);
    assert.strictEqual(baselineLease.stack_snapshot_ref, actor.stack_snapshot_ref);
    assert(actor.manifest_ack_ref && typeof actor.stack_snapshot_ref === 'string' && actor.stack_snapshot_ref.length > 0);
    if (actionable) {
      assert(actor.stack_snapshot_ref === contract.base_stack_ref);
      assert.strictEqual(baselineLease.status, 'active');
    }
    if (contract.new_context_required) assert(typeof actor.fresh_session_receipt === 'string' && actor.fresh_session_receipt.length > 0);
    if (actionable) assert.strictEqual(actor.provenance.authority_source_ref, plan.authority.source_ref);
    assert(['create', 'message', 'archive'].includes(actor.provenance.action));
    if (actionable) assert(actor.provenance.adopted_session_ref === null || plan.authority.adopted_session_refs.includes(actor.provenance.adopted_session_ref));
    if (actionable) assert(authorityCovers(plan.authority, {...actor, adopted_session_ref: actor.provenance.adopted_session_ref}, actor.provenance.action));
    for (const flag of ['pending_correction', 'pending_recheck', 'waiting_human', 'handoff_pending']) assert(typeof actor[flag] === 'boolean');
    if (actor.previous_state === null) assert(['created-pending', 'active'].includes(actor.state));
    else {
      assert(actorStates.has(actor.previous_state) && validActorTransition(actor.previous_state, actor.state));
      assert(typeof actor.transition_evidence_ref === 'string' && actor.transition_evidence_ref.length > 0);
    }
    if (['awaiting-review', 'terminal-reconciled', 'archive-pending', 'archived'].includes(actor.state)) assert(typeof actor.report_ref === 'string' && actor.report_ref.length > 0);
    if (actor.state === 'awaiting-review') assert(actor.pending_recheck && !actor.pending_correction);
    if (actor.state === 'correction-needed') assert(actor.pending_correction && typeof actor.finding_ref === 'string' && actor.finding_ref.length > 0);
    if (actor.state === 'handoff-pending') assert(actor.handoff_pending && typeof actor.report_ref === 'string' && actor.report_ref.length > 0);
    if (actor.state === 'fence-pending') assert(typeof actor.stop_intent_ref === 'string' && actor.stop_intent_ref.length > 0);
    if (actor.state === 'fenced') assert(actor.stop_ack_ref && actor.effects_quiescent_ref);
    if (['terminal-reconciled', 'archive-pending', 'archived'].includes(actor.state)) assert(actor.transfer_receipt && actor.reconciliation_receipt);
    if (actor.state === 'archive-pending') {
      assert(actor.role === 'executor' && actor.terminal_reason === 'PASS');
      assert(typeof actor.archive_incident_ref === 'string' && actor.archive_incident_ref.length > 0);
      assert(Number.isInteger(actor.archive_attempts) && actor.archive_attempts > 0 && actor.archive_attempts <= 2);
      assert(!actor.archive_receipt && !actor.pending_correction && !actor.pending_recheck && !actor.waiting_human && !actor.handoff_pending);
    }
    if (actor.state === 'archived') {
      assert(actor.terminal_reason && ['PASS', 'abandoned', 'superseded'].includes(actor.terminal_reason));
      assert(actor.transfer_receipt && actor.archive_receipt);
      assert(!actor.pending_correction && !actor.pending_recheck && !actor.waiting_human && !actor.handoff_pending);
    }
  }
  assert(plan.context_admissions && sameMembers(Object.keys(plan.context_admissions), Object.keys(plan.actors)));
  assert(Array.isArray(plan.delegation_boundaries));
  for (const boundary of plan.delegation_boundaries) {
    for (const key of ['purpose', 'input_refs', 'max_report_shape', 'planned_route', 'observed_route', 'route_evidence_ref', 'binding_readback_ref', 'output_ref']) assert(typeof boundary[key] === 'string' && boundary[key].length > 0);
    assert(boundary.planned_route === boundary.observed_route);
    const [boundaryModel, boundaryEffort] = boundary.observed_route.split('/');
    assert(validChildRoute(boundaryModel, boundaryEffort));
  }
  const actionableActors = Object.values(plan.actors).filter(actor => !['fenced', 'terminal-reconciled', 'archive-pending', 'archived'].includes(actor.state));
  if (supervisorAdmission.decision === 'PAUSE' && ['active', 'replanning'].includes(plan.status)) {
    assert(plan.delegation_boundaries.length > 0);
    assert.strictEqual(actionableActors.length, 0);
  }
  assert(plan.delivery_artifacts && typeof plan.delivery_artifacts === 'object');
  const artifactRefs = new Set();
  for (const [taskRef, artifacts] of Object.entries(plan.delivery_artifacts)) {
    assert(plan.task_contracts[taskRef] && Array.isArray(artifacts));
    for (const artifact of artifacts) {
      assert(['branch', 'pull-request', 'document', 'other'].includes(artifact.kind));
      for (const key of ['artifact_ref', 'base_ref', 'head_ref', 'owner_actor_ref', 'next_transition', 'resume_predicate', 'evidence_ref']) assert(typeof artifact[key] === 'string' && artifact[key].length > 0);
      assert(!artifactRefs.has(artifact.artifact_ref));
      artifactRefs.add(artifact.artifact_ref);
      assert(artifact.repository_ref === null || (typeof artifact.repository_ref === 'string' && artifact.repository_ref.length > 0));
      assert(['branch-only', 'draft', 'ready-for-review', 'waiting-human', 'merged', 'closed', 'superseded'].includes(artifact.state));
      assert(['active', 'adopt', 'reject', 'rewrite', 'historical'].includes(artifact.disposition));
      assert(artifact.blocker === null || (typeof artifact.blocker === 'string' && artifact.blocker.length > 0));
      const artifactTerminal = ['merged', 'closed', 'superseded'].includes(artifact.state);
      if (artifactTerminal) assert.notStrictEqual(artifact.disposition, 'active');
      else {
        const owner = plan.actors[artifact.owner_actor_ref];
        assert(owner && owner.task_ref === taskRef);
        assert(!['fenced', 'terminal-reconciled', 'archive-pending', 'archived'].includes(owner.state));
        if (artifact.state === 'waiting-human') assert.strictEqual(owner.waiting_human, true);
      }
    }
  }
  assert(plan.resume && Array.isArray(plan.resume.pending_operation_keys));
  assert(plan.frontier && Array.isArray(plan.frontier.parallel_safe_now) && plan.frontier.parallel_safe_now.every(ref => refs.has(ref)));
  assert(plan.frontier.blocked_on_artifact_refs && plan.frontier.write_conflict_set);
  assert(plan.telemetry && Array.isArray(plan.telemetry.snapshot_refs) && Array.isArray(plan.telemetry.metrics));
  for (const metric of plan.telemetry.metrics) {
    for (const key of ['metric', 'source', 'population', 'window_start', 'window_end']) assert(typeof metric[key] === 'string' && metric[key].length > 0);
    assert(metric.value === 'unavailable' || typeof metric.value === 'number');
  }
  assert(plan.efficiency && Number.isInteger(plan.efficiency.comparable_cycles_without_progress) && plan.efficiency.comparable_cycles_without_progress >= 0);
  assert(Number.isInteger(plan.efficiency.material_replan_streak) && plan.efficiency.material_replan_streak >= 0);
  assert(Array.isArray(plan.efficiency.graph_hash_history) && plan.efficiency.graph_hash_history.length > 0 && plan.efficiency.graph_hash_history.every(Boolean));
  assert((plan.efficiency.accepted_progress_ref === null) === (plan.efficiency.accepted_progress_kind === null));
  if (plan.efficiency.accepted_progress_ref !== null) {
    assert(typeof plan.efficiency.accepted_progress_ref === 'string' && plan.efficiency.accepted_progress_ref.length > 0);
    assert(['artifact', 'review', 'integrated-evidence'].includes(plan.efficiency.accepted_progress_kind));
    assert.strictEqual(plan.efficiency.comparable_cycles_without_progress, 0);
    assert.strictEqual(plan.efficiency.material_replan_streak, 0);
    assert.strictEqual(new Set(plan.efficiency.graph_hash_history).size, plan.efficiency.graph_hash_history.length);
  }
  const repeatedGraph = new Set(plan.efficiency.graph_hash_history).size !== plan.efficiency.graph_hash_history.length;
  const efficiencyTriggered = plan.efficiency.comparable_cycles_without_progress >= 2 || plan.efficiency.material_replan_streak >= 2 || repeatedGraph;
  const efficiencyIncident = plan.efficiency.incident;
  if (efficiencyTriggered) assert(efficiencyIncident);
  if (efficiencyIncident !== null) {
    assert(typeof efficiencyIncident.incident_ref === 'string' && efficiencyIncident.incident_ref.length > 0);
    assert(['replan', 'efficiency'].includes(efficiencyIncident.kind));
    assert(['opened', 'diagnosed', 'adopted'].includes(efficiencyIncident.state));
    if (efficiencyIncident.state === 'opened') {
      assert.strictEqual(efficiencyIncident.diagnosis_ref, null);
      assert.strictEqual(efficiencyIncident.disposition_ref, null);
    } else {
      assert(typeof efficiencyIncident.diagnosis_ref === 'string' && efficiencyIncident.diagnosis_ref.length > 0);
      if (efficiencyIncident.state === 'diagnosed') assert.strictEqual(efficiencyIncident.disposition_ref, null);
      else assert(typeof efficiencyIncident.disposition_ref === 'string' && efficiencyIncident.disposition_ref.length > 0);
    }
  }
  const incidentBlocksWork = efficiencyIncident !== null && efficiencyIncident.state !== 'adopted';
  if (incidentBlocksWork) assert.strictEqual(actionableActors.length, 0);
  assert(plan.compaction && Number.isInteger(plan.compaction.size_budget) && plan.compaction.size_budget > 0 && Array.isArray(plan.compaction.detail_ledger_refs));
  if (plan.compaction.last_receipt !== null) for (const key of ['pre_hash', 'post_hash', 'essential_fields_ref', 'readback_ref', 'no_loss_ref']) assert(typeof plan.compaction.last_receipt[key] === 'string' && plan.compaction.last_receipt[key].length > 0);
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
    assert(['create', 'message', 'archive'].includes(intent.action));
    if (supervisorAdmission.decision === 'PAUSE' && ['create', 'message'].includes(intent.action) && intent.result === 'pending') assert.fail('paused supervisor context blocks create/work intents');
    if (incidentBlocksWork && ['create', 'message'].includes(intent.action) && intent.result === 'pending') assert.fail('unadopted efficiency incident blocks create/work intents');
    assert.strictEqual(intent.plan_id, plan.plan_id);
    assert(Number.isInteger(intent.plan_revision) && intent.plan_revision > 0 && intent.plan_revision <= plan.revision);
    assert(Number.isInteger(intent.intent_revision) && intent.intent_revision > 0 && intent.intent_revision <= plan.intent.revision);
    assert(typeof intent.authority_source_ref === 'string' && intent.authority_source_ref.length > 0);
    assert(Number.isInteger(intent.epoch) && intent.epoch > 0 && intent.epoch <= plan.supervisor.epoch);
    const contract = plan.task_contracts[intent.task_ref];
    assert(contract && Number.isInteger(intent.task_generation) && intent.task_generation > 0 && intent.task_generation <= contract.task_generation);
    assert(typeof intent.contract_hash === 'string' && intent.contract_hash.length > 0 && typeof intent.manifest_hash === 'string' && intent.manifest_hash.length > 0);
    assert(typeof intent.planned_route === 'string' && intent.planned_route.length > 0);
    if (intent.action === 'create' && intent.result === 'pending') {
      assert.strictEqual(intent.observed_route, null);
      assert.strictEqual(intent.route_evidence_ref, null);
    } else {
      assert(intent.planned_route === intent.observed_route && typeof intent.route_evidence_ref === 'string' && intent.route_evidence_ref.length > 0);
    }
    assert(typeof intent.stack_snapshot_ref === 'string' && intent.stack_snapshot_ref.length > 0);
    if (['pending', 'ambiguous'].includes(intent.result)) {
      assert(plan.authority.actions.includes(intent.action));
      assert(intent.plan_revision === plan.revision && intent.intent_revision === plan.intent.revision && intent.epoch === plan.supervisor.epoch);
      assert(intent.authority_source_ref === plan.authority.source_ref && intent.task_generation === contract.task_generation);
      assert(intent.contract_hash === contract.contract_hash && intent.manifest_hash === contract.manifest_hash && intent.stack_snapshot_ref === contract.base_stack_ref);
      assert(authorityCovers(plan.authority, {...intent, adopted_session_ref: intent.adopted_session_ref ?? null}, intent.action));
    }
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
    assert(Number.isInteger(receipt.plan_revision) && receipt.plan_revision > 0 && receipt.plan_revision <= plan.revision);
    assert(Number.isInteger(receipt.intent_revision) && receipt.intent_revision > 0 && receipt.intent_revision <= plan.intent.revision);
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
    assert.strictEqual(receipt.task_generation, intent.task_generation);
    assert.strictEqual(receipt.manifest_hash, intent.manifest_hash);
    assert.strictEqual(receipt.observed_route, intent.observed_route);
    assert.strictEqual(receipt.stack_snapshot_ref, intent.stack_snapshot_ref);
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
  if (['completed', 'superseded'].includes(plan.status)) {
    assert(Object.values(plan.delivery_artifacts).flat().every(artifact => ['merged', 'closed', 'superseded'].includes(artifact.state) && artifact.disposition !== 'active'));
  }
  if (plan.status === 'completed') {
    assert(typeof plan.outcome.global_evidence_ref === 'string' && plan.outcome.global_evidence_ref.length > 0);
    assert.strictEqual(plan.outcome.global_evidence_revision, plan.revision);
    assert(plan.human_checkpoints.every(checkpoint => checkpoint.state === 'satisfied' && typeof checkpoint.evidence_ref === 'string' && checkpoint.evidence_ref.length > 0));
    assert.strictEqual(plan.supervisor.goal.state, 'complete');
    assert.strictEqual(plan.resume.pending_operation_keys.length, 0);
    assert(Object.values(plan.actors).every(actor => actor.state === 'archived' || (actor.role !== 'executor' && actor.state === 'terminal-reconciled')));
  }
  return true;
}

const plan = {
  schema: 'octoplan-plan-v5', plan_id: 'plan-a', revision: 1, proposed_revision: null, proposed_review: null, status: 'active',
  organization_id: 'org-a', workspace_id: 'workspace-a', work_stream_id: 'stream-a', coordination_task_id: 'task-control',
  brief: {source_ref: 'message-request', approval_ref: 'message-brief-go', tracker_ref: 'tracker-a', review_cadence: 'final', execution_scope: 'deliver-authorized', octopad_write_classes: ['work-stream', 'tracker', 'task', 'dependency', 'decision', 'question', 'comment', 'coordination-state'], native_actions: ['create', 'message', 'archive'], native_roles: ['planner', 'executor', 'reviewer', 'supervisor'], project_id: 'project-a', directory_name: null, native_environments: ['local', 'worktree'], child_route: 'native-task/worktree', effects: ['bounded delivery']},
  outcome: {candidate_ref: 'E01', global_evidence_ref: null, global_evidence_revision: null},
  task_ids: {E01: 'task-a', E02: 'task-b', E03: 'task-c', H01: 'task-human'},
  task_contracts: {
    E01: {task_generation: 1, contract_hash: 'contract-e01-g1', manifest_ref: 'manifest-e01-g1', manifest_hash: 'manifest-hash-e01-g1', new_context_required: true, artifact_disposition: 'rewrite', base_stack_ref: 'stack-a'},
    E02: {task_generation: 1, contract_hash: 'contract-e02-g1', manifest_ref: 'manifest-e02-g1', manifest_hash: 'manifest-hash-e02-g1', new_context_required: true, artifact_disposition: 'rewrite', base_stack_ref: 'stack-a'},
    E03: {task_generation: 1, contract_hash: 'contract-e03-g1', manifest_ref: 'manifest-e03-g1', manifest_hash: 'manifest-hash-e03-g1', new_context_required: true, artifact_disposition: 'rewrite', base_stack_ref: 'stack-a'}
  },
  brief_records: {decisions: {D01: {id: 'decision-a', receipt_ref: 'receipt-decision-a'}}, questions: {Q01: {id: 'question-a', receipt_ref: 'receipt-question-a'}}},
  desired_dependencies: [{task_ref: 'E02', depends_on_ref: 'E01', rationale: 'needs artifact'}],
  review: {revision: 1, task_generations: {E01: 1, E02: 1, E03: 1}, review_type: 'full_independent_fresh', reviewer_session_ref: 'reviewer-a', planned_route: 'gpt-5.6-luna/max', observed_route: 'gpt-5.6-luna/max', route_evidence_ref: 'review-turn-context', artifact_hash: 'plan-artifact-a', finding_keys: [], executed_checks: ['plan-contract'], verdict: 'PASS', evidence_ref: 'evidence-a'},
  planning: {candidate_hash: 'plan-artifact-a', source_snapshot_hash: 'source-snapshot-a', active_lease_ref: 'planner-lease-a', leases: [{lease_ref: 'planner-lease-a', session_ref: 'planner-a', fresh_session_receipt: 'planner-fresh-a', plan_revision: 1, intent_revision: 1, candidate_hash: 'plan-artifact-a', input_snapshot_hash: 'source-snapshot-a', planned_route: 'gpt-5.6-sol/xhigh', observed_route: 'gpt-5.6-sol/xhigh', route_evidence_ref: 'planner-turn-context-a', binding_readback_ref: 'planner-binding-a', status: 'adopted', output_hash: 'plan-artifact-a', prior_artifact_disposition_ref: 'artifact-dispositions-a'}]},
  supervisor: {thread_ref: 'thread-user', epoch: 1, mode: 'current-task', predecessor: null, context_admission: {plan_revision: 1, intent_revision: 1, supervisor_epoch: 1, state_hash: 'supervisor-state-hash-a', decision: 'REUSE', state_readback_ref: 'supervisor-state-a', intent_readback_ref: 'supervisor-intent-a', accepted_progress_ref: null, compaction_ref: null, resumes_since_progress: 0, evidence_ref: 'supervisor-context-a'}, goal: {required: true, owner_thread_ref: 'thread-user', objective_ref: 'message-outcome', origin: 'created', evidence_ref: 'goal-create-a', state: 'active', supersedes_goal_ref: null}},
  runtime: {minimum_version: '15.0.0', loaded_version: '15.0.0', installed_version: '15.0.0', adoption_ref: null, admission_checked_at: '2026-08-12T08:04:00Z', supervisor_route: {planned: 'gpt-5.6-sol/high', observed: 'gpt-5.6-sol/high', evidence_ref: 'turn-context-supervisor', admission: 'PASS'}},
  legacy_migration: null,
  authority: {source_ref: 'message-brief-go', delivery: true, project_id: 'project-a', directory_name: null, environments: ['local', 'worktree'], roles: ['planner', 'executor', 'reviewer', 'supervisor'], actions: ['create', 'message', 'archive'], octopad_write_classes: ['work-stream', 'tracker', 'task', 'dependency', 'decision', 'question', 'comment', 'coordination-state'], child_route: 'native-task/worktree', effects: ['bounded delivery'], adopted_session_refs: []},
  intent: {revision: 1, latest_user_directive_ref: 'message-brief-go', superseded_effect_keys: []},
  budgets: {max_active_child_actors: 2, max_wip: 2, max_correction_loops: 2, max_review_actors: 2, max_review_checks: 8, batch_size: 2},
  counters: {active_child_actors: 0, wip: 0, correction_loops: {}, review_actors: 0, review_checks: 0},
  human_checkpoints: [
    {checkpoint_key: 'review-a', kind: 'review', source: 'organization', mandatory: true, owner: 'maintainer', subject: 'approve exact head', timing: 'after CI', reason: 'required repository review', blocked_task_refs: ['E02'], safe_continuation_refs: ['E03'], expected_decision: 'approve or request changes', evidence_ref: null, state: 'pending', resume_predicate: 'review evidence matches head'},
    {checkpoint_key: 'deploy-a', kind: 'deployment', source: 'organization', mandatory: true, owner: 'operator', subject: 'deploy release', timing: 'after merge', reason: 'protected production effect', blocked_task_refs: ['E02'], safe_continuation_refs: [], expected_decision: 'approve or reject deployment', evidence_ref: null, state: 'pending', resume_predicate: 'deployment receipt exists'}
  ],
  actors: {}, context_admissions: {}, delegation_boundaries: [], native_action_intents: [], native_action_receipts: [],
  delivery_artifacts: {},
  stack_snapshots: {'stack-a': {main_sha: 'main-a', base_shas: ['base-a'], head_shas: ['head-a'], ancestry_ref: 'ancestry-a', effective_diffs_ref: 'diffs-a', migration_registry_ref: 'migrations-a', checks_ref: 'checks-a', verifier_coverage_ref: 'coverage-a', checked_at: '2026-08-12T08:00:00Z', ttl_seconds: 300, fresh_until: '2026-08-12T08:05:00Z', admission: 'PASS', admission_ref: 'stack-admission-a'}},
  baseline_leases: {'baseline-e01-g1': {lease_ref: 'baseline-e01-g1', task_ref: 'E01', task_generation: 1, actor_ref: null, stack_snapshot_ref: 'stack-a', status: 'active', last_refresh_reason: 'dispatch', refresh_receipt_ref: 'baseline-refresh-a'}},
  frontier: {parallel_safe_now: ['E01', 'E03'], blocked_on_artifact_refs: {E02: ['artifact-e01']}, write_conflict_set: {E01: ['file:a'], E03: ['file:c']}},
  telemetry: {snapshot_refs: [], metrics: []},
  efficiency: {accepted_progress_ref: null, accepted_progress_kind: null, comparable_cycles_without_progress: 0, material_replan_streak: 0, graph_hash_history: ['graph-a'], incident: null},
  compaction: {size_budget: 32000, detail_ledger_refs: [], last_receipt: null},
  heartbeat: null,
  resume: {last_event_id: null, pending_operation_keys: []}
};
assert(validatePlan(plan));
assert(validatePlan(JSON.parse(JSON.stringify(plan))));
function adoptCompatible15(previous) {
  const adopted = JSON.parse(JSON.stringify(previous));
  if (!Object.prototype.hasOwnProperty.call(adopted, 'proposed_review')) adopted.proposed_review = null;
  if (!Object.prototype.hasOwnProperty.call(adopted.supervisor, 'predecessor')) adopted.supervisor.predecessor = null;
  if (!Object.prototype.hasOwnProperty.call(adopted.supervisor.goal, 'supersedes_goal_ref')) adopted.supervisor.goal.supersedes_goal_ref = null;
  adopted.runtime.loaded_version = '15.0.1';
  adopted.runtime.installed_version = '15.0.1';
  adopted.runtime.adoption_ref = 'safe-boundary-adoption-a';
  return adopted;
}
const priorV5 = JSON.parse(JSON.stringify(plan));
priorV5.runtime.loaded_version = '15.0.0';
priorV5.runtime.installed_version = '15.0.1';
assert(validatePlan(adoptCompatible15(priorV5)));
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
assert.throws(() => validatePlan({...plan, supervisor: {...plan.supervisor, context_admission: {...plan.supervisor.context_admission, resumes_since_progress: 3}}}));
assert.throws(() => validatePlan({...plan, supervisor: {...plan.supervisor, context_admission: {...plan.supervisor.context_admission, decision: 'REPLACE'}}}));
const diagnosticBoundary = {purpose: 'material replan diagnosis', input_refs: 'bounded-input-ledger-a', max_report_shape: 'one consolidated proposal', planned_route: 'gpt-5.6-sol/xhigh', observed_route: 'gpt-5.6-sol/xhigh', route_evidence_ref: 'diagnostic-route-a', binding_readback_ref: 'diagnostic-binding-a', output_ref: 'diagnostic-report-a'};
assert(validatePlan({...plan, supervisor: {...plan.supervisor, context_admission: {...plan.supervisor.context_admission, decision: 'PAUSE', compaction_ref: 'compaction-a', resumes_since_progress: 3}}, delegation_boundaries: [diagnosticBoundary]}));
assert.throws(() => validatePlan({...plan, supervisor: {...plan.supervisor, context_admission: {...plan.supervisor.context_admission, decision: 'PAUSE', resumes_since_progress: 3}}}));
const predecessor = {thread_ref: 'thread-user', epoch: 1, goal_evidence_ref: 'goal-create-a', revival_ref: 'wake-attempt-a', terminal_or_unreachable_ref: 'native-terminal-a', fence_key: 'plan-a:takeover:epoch:2', fence_readback_ref: 'fence-readback-a', effects_quiescent_ref: 'post-fence-quiescence-a'};
const recoverySuccessor = {...plan, supervisor: {...plan.supervisor, thread_ref: 'thread-successor', epoch: 2, mode: 'recovery-successor', predecessor, context_admission: {...plan.supervisor.context_admission, supervisor_epoch: 2, state_hash: 'supervisor-state-hash-successor'}, goal: {...plan.supervisor.goal, owner_thread_ref: 'thread-successor', evidence_ref: 'goal-successor-a', supersedes_goal_ref: 'goal-create-a'}}};
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
function asReplanning(previous, proposedReview = null) {
  const proposedRevision = previous.status === 'replanning' ? previous.proposed_revision + 1 : previous.revision + 1;
  const sourceSnapshotHash = `source-snapshot-r${proposedRevision}`;
  const leaseRef = `planner-lease-r${proposedRevision}`;
  const expiredLeases = previous.planning.leases.map(lease => ({...lease, status: 'expired', output_hash: lease.output_hash}));
  return {
    ...previous,
    status: 'replanning',
    proposed_revision: proposedRevision,
    proposed_review: proposedReview,
    planning: {
      ...previous.planning,
      source_snapshot_hash: sourceSnapshotHash,
      active_lease_ref: leaseRef,
      leases: [...expiredLeases, {lease_ref: leaseRef, session_ref: `planner-r${proposedRevision}`, fresh_session_receipt: `planner-fresh-r${proposedRevision}`, plan_revision: proposedRevision, intent_revision: previous.intent.revision, candidate_hash: previous.planning.candidate_hash, input_snapshot_hash: sourceSnapshotHash, planned_route: 'gpt-5.6-sol/xhigh', observed_route: 'gpt-5.6-sol/xhigh', route_evidence_ref: `planner-turn-r${proposedRevision}`, binding_readback_ref: `planner-binding-r${proposedRevision}`, status: 'active', output_hash: null, prior_artifact_disposition_ref: `artifact-dispositions-r${proposedRevision}`}]
    }
  };
}
assert(validatePlan(asReplanning(plan)));
assert(validatePlan(asReplanning(plan, {revision: 2, verdict: 'PASS'})));
assert.throws(() => validatePlan(asReplanning(plan, {revision: 3, verdict: 'PASS'})));
const interruptedReplan = asReplanning(plan);
const replacementReplan = asReplanning(interruptedReplan);
const interruptedLease = replacementReplan.planning.leases.find(lease => lease.lease_ref === interruptedReplan.planning.active_lease_ref);
const replacementLease = replacementReplan.planning.leases.find(lease => lease.lease_ref === replacementReplan.planning.active_lease_ref);
assert(validatePlan(replacementReplan));
assert.strictEqual(replacementReplan.proposed_revision, 3);
assert.strictEqual(interruptedLease.status, 'expired');
assert.strictEqual(interruptedLease.output_hash, null);
assert.notStrictEqual(replacementLease.session_ref, interruptedLease.session_ref);
assert.notStrictEqual(replacementLease.fresh_session_receipt, interruptedLease.fresh_session_receipt);
assert.throws(() => validatePlan({...plan, status: 'replanning', proposed_revision: 2, proposed_review: null}));
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
assert.throws(() => validatePlan({...plan, review: {...plan.review, task_generations: {}}}));
assert.throws(() => validatePlan({...plan, review: {...plan.review, observed_route: 'gpt-5.6-terra/high'}}));
assert.throws(() => validatePlan({...plan, review: {...plan.review, planned_route: 'gpt-5.6-sol/high'}}));
assert.throws(() => validatePlan({...plan, review: {...plan.review, route_evidence_ref: ''}}));
assert.throws(() => validatePlan({...plan, stack_snapshots: {}}));
assert.throws(() => validatePlan({...plan, stack_snapshots: {'stack-a': {...plan.stack_snapshots['stack-a'], migration_registry_ref: ''}}}));
assert.throws(() => validatePlan({...plan, stack_snapshots: {'stack-a': {...plan.stack_snapshots['stack-a'], admission: 'STALE'}}}));
assert.throws(() => validatePlan({...plan, runtime: {...plan.runtime, admission_checked_at: '2026-08-12T08:06:00Z'}}));
assert.throws(() => validatePlan({...plan, runtime: {...plan.runtime, admission_checked_at: '2026-08-12T07:59:00Z'}}));
assert.throws(() => validatePlan({...plan, stack_snapshots: {'stack-a': {...plan.stack_snapshots['stack-a'], fresh_until: '2026-08-12T09:00:00Z'}}}));
assert.throws(() => validatePlan({...plan, resume: {last_event_id: null}}));
const actorBinding = {plan_id: 'plan-a', plan_revision: 1, intent_revision: 1, supervisor_epoch: 1, authority_source_ref: 'message-brief-go', organization_id: 'org-a', workspace_id: 'workspace-a', role: 'executor', task_id: 'task-a', task_generation: 1, contract_hash: 'contract-e01-g1', manifest_hash: 'manifest-hash-e01-g1', baseline_lease_ref: 'baseline-e01-g1', model: 'gpt-5.6-luna', effort: 'max', observed_model: 'gpt-5.6-luna', observed_effort: 'max', readback_ref: 'binding-readback-a', route_evidence_ref: 'turn-context-a'};
const actorBase = {actor_ref: 'executorA', role: 'executor', task_ref: 'E01', model: 'gpt-5.6-luna', effort: 'max', project_id: 'project-a', environment: 'local', binding: actorBinding, manifest_ack_ref: 'manifest-ack-a', stack_snapshot_ref: 'stack-a', fresh_session_receipt: 'fresh-session-a', provenance: {creation_key: 'create-a', authority_source_ref: 'message-brief-go', action: 'create', adopted_session_ref: null}, pending_correction: false, pending_recheck: false, waiting_human: false, handoff_pending: false};
const awaitingActor = {...actorBase, state: 'awaiting-review', previous_state: 'active', transition_evidence_ref: 'transition-review', report_ref: 'report-review', pending_recheck: true};
const archivedActor = {...actorBase, state: 'archived', previous_state: 'terminal-reconciled', transition_evidence_ref: 'transition-a', report_ref: 'report-a', terminal_reason: 'PASS', transfer_receipt: 'transfer-a', reconciliation_receipt: 'reconcile-a', archive_receipt: 'archive-a'};
const archivePendingActor = {...actorBase, state: 'archive-pending', previous_state: 'terminal-reconciled', transition_evidence_ref: 'transition-archive-pending', report_ref: 'report-a', terminal_reason: 'PASS', transfer_receipt: 'transfer-a', reconciliation_receipt: 'reconcile-a', archive_incident_ref: 'archive-incident-a', archive_attempts: 1};
const contextAdmissionA = {actor_ref: 'executorA', decision: 'REUSE', binding_readback_ref: 'binding-readback-a', manifest_readback_ref: 'manifest-readback-a', intent_readback_ref: 'intent-readback-a', accepted_progress_ref: null, compaction_ref: null, resumes_since_progress: 0, evidence_ref: 'context-admission-a'};
function withActors(previous, actors, contextAdmissions = {executorA: contextAdmissionA}) {
  const baselineLeases = JSON.parse(JSON.stringify(previous.baseline_leases));
  for (const [actorRef, actor] of Object.entries(actors)) {
    const lease = baselineLeases[actor.binding?.baseline_lease_ref];
    if (lease) lease.actor_ref = actorRef;
  }
  return {...previous, actors, context_admissions: contextAdmissions, baseline_leases: baselineLeases};
}
assert(validatePlan(withActors(plan, {executorA: awaitingActor})));
assert.throws(() => validatePlan(withActors(plan, {executorA: {...awaitingActor, pending_recheck: false}})));
assert(validatePlan(withActors(plan, {executorA: archivedActor})));
assert.throws(() => validatePlan({...plan, actors: {executorA: awaitingActor}}));
assert.throws(() => validatePlan(withActors(plan, {executorA: awaitingActor}, {executorA: {...contextAdmissionA, decision: 'REPLACE'}})));
assert.throws(() => validatePlan(withActors(plan, {executorA: awaitingActor}, {executorA: {...contextAdmissionA, resumes_since_progress: 3}})));
const historicalAdoptedActor = {...archivedActor, provenance: {...archivedActor.provenance, adopted_session_ref: 'adopted-historical'}};
const narrowedAuthorityPlan = {...plan, brief: {...plan.brief, native_actions: ['create']}, authority: {...plan.authority, actions: ['create']}};
assert(validatePlan(withActors(narrowedAuthorityPlan, {executorA: historicalAdoptedActor})));
assert(validatePlan(withActors(plan, {executorA: archivePendingActor})));
assert.throws(() => validatePlan(withActors(plan, {executorA: {...archivePendingActor, archive_attempts: 3}})));
assert.throws(() => validatePlan(withActors(plan, {executorA: {...archivePendingActor, archive_incident_ref: ''}})));
assert.throws(() => validatePlan(withActors(plan, {executorA: {...awaitingActor, model: 'gpt-5.6-luna', effort: 'xhigh'}})));
assert.throws(() => validatePlan(withActors(plan, {executorA: {...awaitingActor, model: 'gpt-5.6-terra', effort: 'high', binding: {...actorBinding, model: 'gpt-5.6-terra', observed_model: 'gpt-5.6-terra', effort: 'high', observed_effort: 'high'}}})));
const solActor = {...awaitingActor, model: 'gpt-5.6-sol', effort: 'high', binding: {...actorBinding, model: 'gpt-5.6-sol', observed_model: 'gpt-5.6-sol', effort: 'high', observed_effort: 'high'}};
assert(validatePlan(withActors(plan, {executorA: solActor})));
assert.throws(() => validatePlan(withActors(plan, {executorA: {...awaitingActor, binding: {...actorBinding, task_generation: 0}}})));
assert.throws(() => validatePlan(withActors(plan, {executorA: {...awaitingActor, fresh_session_receipt: null}})));
assert.throws(() => validatePlan(withActors(plan, {executorA: {...awaitingActor, binding: {...actorBinding, baseline_lease_ref: 'missing-baseline'}}})));
const wrongTaskBaselinePlan = {...plan, baseline_leases: {...plan.baseline_leases, 'baseline-e02-g1': {lease_ref: 'baseline-e02-g1', task_ref: 'E02', task_generation: 1, actor_ref: null, stack_snapshot_ref: 'stack-a', status: 'active', last_refresh_reason: 'dispatch', refresh_receipt_ref: 'baseline-refresh-e02'}}};
assert.throws(() => validatePlan(withActors(wrongTaskBaselinePlan, {executorA: {...awaitingActor, binding: {...actorBinding, baseline_lease_ref: 'baseline-e02-g1'}}})));
const generation2Contract = {...plan.task_contracts.E01, task_generation: 2, contract_hash: 'contract-e01-g2', manifest_ref: 'manifest-e01-g2', manifest_hash: 'manifest-hash-e01-g2', artifact_disposition: 'reject'};
const generation2Planning = {candidate_hash: 'plan-artifact-r2', source_snapshot_hash: 'source-snapshot-r2', active_lease_ref: 'planner-lease-r2', leases: [{...plan.planning.leases[0], status: 'expired'}, {lease_ref: 'planner-lease-r2', session_ref: 'planner-fresh-r2', fresh_session_receipt: 'planner-fresh-receipt-r2', plan_revision: 2, intent_revision: 1, candidate_hash: 'plan-artifact-r2', input_snapshot_hash: 'source-snapshot-r2', planned_route: 'gpt-5.6-sol/xhigh', observed_route: 'gpt-5.6-sol/xhigh', route_evidence_ref: 'planner-turn-r2', binding_readback_ref: 'planner-binding-r2', status: 'adopted', output_hash: 'plan-artifact-r2', prior_artifact_disposition_ref: 'artifact-dispositions-r2'}]};
const generation2Plan = {...plan, revision: 2, task_contracts: {...plan.task_contracts, E01: generation2Contract}, review: {...plan.review, revision: 2, task_generations: {...plan.review.task_generations, E01: 2}, reviewer_session_ref: 'reviewer-fresh-r2', artifact_hash: 'plan-artifact-r2', review_type: 'full_independent_fresh'}, planning: generation2Planning, supervisor: {...plan.supervisor, context_admission: {...plan.supervisor.context_admission, plan_revision: 2, state_hash: 'supervisor-state-hash-r2'}}, baseline_leases: {...plan.baseline_leases, 'baseline-e01-g2': {lease_ref: 'baseline-e01-g2', task_ref: 'E01', task_generation: 2, actor_ref: null, stack_snapshot_ref: 'stack-a', status: 'active', last_refresh_reason: 'dispatch', refresh_receipt_ref: 'baseline-refresh-g2'}}, outcome: {...plan.outcome, global_evidence_revision: null}, efficiency: {...plan.efficiency, material_replan_streak: 1, graph_hash_history: ['graph-a', 'graph-r2']}};
assert.throws(() => validatePlan({...generation2Plan, planning: plan.planning}));
assert.throws(() => validatePlan({...generation2Plan, planning: {...generation2Planning, leases: [generation2Planning.leases[0], {...generation2Planning.leases[1], session_ref: 'planner-a'}]}}));
assert.throws(() => validatePlan({...generation2Plan, planning: {...generation2Planning, leases: [generation2Planning.leases[0], {...generation2Planning.leases[1], output_hash: 'wrong-output'}]}}));
assert.throws(() => validatePlan({...generation2Plan, planning: {...generation2Planning, leases: [generation2Planning.leases[0], {...generation2Planning.leases[1], intent_revision: 0}]}}));
assert(validatePlan({...generation2Plan, planning: {...generation2Planning, leases: [{...generation2Planning.leases[0], output_hash: null}, generation2Planning.leases[1]]}}));
assert.throws(() => validatePlan(withActors(generation2Plan, {executorA: awaitingActor})));
const fencedGeneration1Actor = {...actorBase, state: 'fenced', previous_state: 'fence-pending', transition_evidence_ref: 'fence-transition-a', stop_intent_ref: 'stop-intent-a', stop_ack_ref: 'stop-ack-a', effects_quiescent_ref: 'quiescent-a'};
assert(validatePlan(withActors(generation2Plan, {executorA: fencedGeneration1Actor}, {executorA: {...contextAdmissionA, decision: 'REPLACE'}})));
const generation2Binding = {...actorBinding, plan_revision: 2, task_generation: 2, contract_hash: 'contract-e01-g2', manifest_hash: 'manifest-hash-e01-g2', baseline_lease_ref: 'baseline-e01-g2'};
const freshGeneration2Actor = {...awaitingActor, binding: generation2Binding, manifest_ack_ref: 'manifest-ack-g2', fresh_session_receipt: 'fresh-session-g2'};
assert(validatePlan(withActors(generation2Plan, {executorA: freshGeneration2Actor})));
assert.throws(() => validatePlan(withActors(plan, {executorA: {...archivedActor, transfer_receipt: null}})));
assert.throws(() => validatePlan(withActors(plan, {executorA: {...archivedActor, waiting_human: true}})));
assert.throws(() => validatePlan(withActors({...plan, authority: {...plan.authority, actions: ['create', 'message']}}, {executorA: archivedActor})));
assert.throws(() => validatePlan(withActors(plan, {executorA: {...archivedActor, role: 'unknown'}})));
assert.throws(() => validatePlan(withActors(plan, {executorA: {...archivedActor, previous_state: 'active'}})));
assert.throws(() => validatePlan(withActors(plan, {executorA: {...archivedActor, transition_evidence_ref: null}})));

const satisfiedCheckpoints = plan.human_checkpoints.map(checkpoint => ({...checkpoint, state: 'satisfied', evidence_ref: `${checkpoint.checkpoint_key}-evidence`}));
const completedPlan = withActors({...plan, status: 'completed', supervisor: {...plan.supervisor, goal: {...plan.supervisor.goal, state: 'complete'}}, outcome: {...plan.outcome, global_evidence_ref: 'integration-proof-a', global_evidence_revision: 1}, human_checkpoints: satisfiedCheckpoints}, {executorA: archivedActor});
assert(validatePlan(completedPlan));
assert.throws(() => validatePlan({...completedPlan, outcome: {...completedPlan.outcome, global_evidence_ref: null}}));
assert.throws(() => validatePlan({...completedPlan, outcome: {...completedPlan.outcome, global_evidence_revision: 2}}));
assert.throws(() => validatePlan({...completedPlan, human_checkpoints: plan.human_checkpoints}));
assert.throws(() => validatePlan({...completedPlan, resume: {last_event_id: null, pending_operation_keys: ['pending-a']}}));
assert.throws(() => validatePlan(withActors(completedPlan, {executorA: {...actorBase, state: 'active', previous_state: null}})));
assert.throws(() => validatePlan(withActors(completedPlan, {executorA: archivePendingActor})));

function validActorTransition(from, to) {
  const allowed = {
    'created-pending': ['active'],
    active: ['awaiting-review', 'handoff-pending', 'fence-pending'],
    'awaiting-review': ['correction-needed', 'handoff-pending', 'terminal-reconciled', 'fence-pending'],
    'correction-needed': ['active', 'handoff-pending', 'fence-pending'],
    'handoff-pending': ['active', 'terminal-reconciled', 'fence-pending'],
    'fence-pending': ['fenced'],
    fenced: ['terminal-reconciled'],
    'terminal-reconciled': ['archive-pending', 'archived'],
    'archive-pending': ['archived'],
    archived: []
  };
  return allowed[from]?.includes(to) === true;
}
assert(validActorTransition('active', 'awaiting-review'));
assert(validActorTransition('active', 'fence-pending'));
assert(validActorTransition('fence-pending', 'fenced'));
assert(validActorTransition('fenced', 'terminal-reconciled'));
assert(validActorTransition('awaiting-review', 'correction-needed'));
assert(validActorTransition('terminal-reconciled', 'archived'));
assert(validActorTransition('terminal-reconciled', 'archive-pending'));
assert(validActorTransition('archive-pending', 'archived'));
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
const redirectedRaw = applyDirective(plan, 'u1', 'u1', 'message-do-not-send', ['send:campaign-a']);
assert.strictEqual(redirectedRaw.intent.revision, 2);
assert.deepStrictEqual(redirectedRaw.intent.superseded_effect_keys, ['send:campaign-a']);
assert.throws(() => validatePlan(redirectedRaw));
const redirected = {
  ...redirectedRaw,
  planning: {...plan.planning, active_lease_ref: 'planner-lease-intent-2', leases: [{...plan.planning.leases[0], status: 'expired'}, {...plan.planning.leases[0], lease_ref: 'planner-lease-intent-2', session_ref: 'planner-intent-2', fresh_session_receipt: 'planner-fresh-intent-2', intent_revision: 2, binding_readback_ref: 'planner-binding-intent-2'}]},
  supervisor: {...plan.supervisor, context_admission: {...plan.supervisor.context_admission, intent_revision: 2, state_hash: 'supervisor-state-hash-intent-2'}}
};
assert(validatePlan(redirected));
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

function nativeTitle(role, workStream, taskName, limit = 64) {
  const prefixes = {supervisor: 'SUP', executor: 'EX', 'follow-up': 'EX', planner: 'PLN', recovery: 'PLN', reviewer: 'REV', 'specialist-reviewer': 'REV', 'plan-reviewer': 'REV'};
  const prefix = prefixes[role];
  assert(prefix);
  const compact = value => value.toLowerCase().replace(/\(octoplanned\)/g, '').replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');
  let stream = compact(workStream) || 'stream';
  let task = compact(taskName) || 'task';
  const available = limit - prefix.length - 2;
  assert(available >= 3);
  stream = stream.slice(0, Math.max(1, available - task.length - 1)).replace(/-$/g, '') || 's';
  task = task.slice(0, Math.max(1, available - stream.length - 1)).replace(/-$/g, '') || 't';
  const title = `${prefix}-${stream}-${task}`;
  assert(title.length <= limit && !/octoplanned|[0-9a-f]{8}-[0-9a-f-]{27,}/i.test(title));
  return title;
}
assert.strictEqual(nativeTitle('supervisor', 'Company Brain', 'Delivery'), 'SUP-company-brain-delivery');
assert.strictEqual(nativeTitle('executor', 'Company Brain (octoplanned)', 'Work Graph'), 'EX-company-brain-work-graph');
assert.strictEqual(nativeTitle('planner', 'Company Brain', 'Replan'), 'PLN-company-brain-replan');
assert.strictEqual(nativeTitle('reviewer', 'Company Brain', 'Work Graph'), 'REV-company-brain-work-graph');
assert(nativeTitle('executor', 'A very long work stream name that must be shortened before anything else', 'Task', 40).length <= 40);
for (const role of ['supervisor', 'executor', 'planner', 'reviewer']) {
  assert(nativeTitle(role, 'Stream', 'An extremely long task name that alone would exceed the runtime title limit by a wide margin').length <= 64);
  assert(!nativeTitle(role, '', '').includes('--'));
}

function versionDecision({schema, minimum, loaded, installed, safeBoundary}) {
  if (schema !== 'octoplan-plan-v5') return 'REPLAN_SCHEMA';
  const parse = value => value.split('.').map(Number);
  const [minimumMajor] = parse(minimum);
  const [installedMajor] = parse(installed);
  if (minimumMajor !== 15 || installedMajor !== 15) return 'REPLAN_BREAKING';
  const compare = (a, b) => parse(a).reduce((result, value, index) => result || value - parse(b)[index], 0);
  if (compare(installed, minimum) < 0) return 'PAUSE_INCOMPATIBLE';
  if (loaded === installed) return 'CONTINUE';
  return safeBoundary ? 'ADOPT_COMPATIBLE' : 'FINISH_SAFE_BOUNDARY';
}
assert.strictEqual(versionDecision({schema: 'octoplan-plan-v5', minimum: '15.0.0', loaded: '15.0.0', installed: '15.1.0', safeBoundary: true}), 'ADOPT_COMPATIBLE');
assert.strictEqual(versionDecision({schema: 'octoplan-plan-v5', minimum: '15.0.0', loaded: '15.0.0', installed: '15.1.0', safeBoundary: false}), 'FINISH_SAFE_BOUNDARY');
assert.strictEqual(versionDecision({schema: 'octoplan-plan-v4', minimum: '14.0.0', loaded: '14.0.0', installed: '15.0.0', safeBoundary: true}), 'REPLAN_SCHEMA');

function legacyGoalMigrationDecision({legacyGoalState, writersQuiescent = false, inventoryReceipt = false, terminationSupported = false}) {
  if (legacyGoalState === 'complete') return writersQuiescent && inventoryReceipt ? 'CREATE_FRESH_V5_PLAN' : 'FENCE_AND_INVENTORY';
  if (legacyGoalState === 'active' || legacyGoalState === 'blocked') {
    if (!writersQuiescent || !inventoryReceipt) return 'FENCE_AND_INVENTORY';
    return terminationSupported ? 'RESOLVE_LEGACY_GOAL_GENUINELY' : 'PAUSE_V5_FOR_LIFECYCLE_DECISION';
  }
  return 'PAUSE_UNPROVEN_LEGACY_GOAL';
}
assert.strictEqual(legacyGoalMigrationDecision({legacyGoalState: 'active'}), 'FENCE_AND_INVENTORY');
assert.strictEqual(legacyGoalMigrationDecision({legacyGoalState: 'active', writersQuiescent: true, inventoryReceipt: true}), 'PAUSE_V5_FOR_LIFECYCLE_DECISION');
assert.strictEqual(legacyGoalMigrationDecision({legacyGoalState: 'active', writersQuiescent: true, inventoryReceipt: true, terminationSupported: true}), 'RESOLVE_LEGACY_GOAL_GENUINELY');
assert.strictEqual(legacyGoalMigrationDecision({legacyGoalState: 'complete', writersQuiescent: true, inventoryReceipt: true}), 'CREATE_FRESH_V5_PLAN');
assert.strictEqual(legacyGoalMigrationDecision({legacyGoalState: 'unknown', writersQuiescent: true, inventoryReceipt: true}), 'PAUSE_UNPROVEN_LEGACY_GOAL');
const legacyMigration = {source_schema: 'octoplan-plan-v4', legacy_goal_ref: 'legacy-goal-a', legacy_goal_state: 'active', inventory_ref: 'legacy-inventory-a', fence_ref: 'legacy-fence-a', quiescence_ref: 'legacy-quiescence-a', route: 'human-decision', decision_ref: 'legacy-lifecycle-gate-a'};
const pausedLegacyMigrationPlan = {...plan, status: 'paused', legacy_migration: legacyMigration, supervisor: {...plan.supervisor, context_admission: {...plan.supervisor.context_admission, decision: 'PAUSE', state_hash: 'legacy-paused-state-a'}, goal: {...plan.supervisor.goal, origin: null, evidence_ref: null, state: 'pending'}}};
assert(validatePlan(pausedLegacyMigrationPlan));
assert.throws(() => validatePlan({...pausedLegacyMigrationPlan, status: 'active'}));
assert.throws(() => validatePlan({...pausedLegacyMigrationPlan, supervisor: {...pausedLegacyMigrationPlan.supervisor, goal: {...pausedLegacyMigrationPlan.supervisor.goal, origin: 'adopted', evidence_ref: 'legacy-goal-a', state: 'active'}}}));
assert(validatePlan({...plan, legacy_migration: {...legacyMigration, legacy_goal_state: 'complete', route: 'resolved', decision_ref: null}}));

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

function exactTakeoverIntent(value, {planId, predecessorEpoch}) {
  const predecessorKeys = ['thread_ref', 'goal_evidence_ref', 'revival_ref', 'terminal_or_unreachable_ref', 'fence_key'];
  if (!value || value.type !== 'OCTOPLAN_TAKEOVER_INTENT' || !value.predecessor) return false;
  const predecessor = value.predecessor;
  const expectedFenceKey = `${planId}:takeover:epoch:${predecessorEpoch + 1}`;
  return typeof planId === 'string' && planId.length > 0 && Number.isInteger(predecessorEpoch) && predecessorEpoch > 0 && predecessor.epoch === predecessorEpoch && predecessorKeys.every(key => typeof predecessor[key] === 'string' && predecessor[key].length > 0) && predecessor.fence_key === expectedFenceKey && value.fence_key === expectedFenceKey;
}
function supervisorRecoveryDecision({planId = 'plan-a', predecessorEpoch = 1, revivalAttempted = false, savedOwnerReachable = false, archived = false, lifecycleAuthority = false, terminalOrUnreachableProved = false, takeoverIntent = null, guardedRotationReadback = false, postFenceQuiescenceRef = null, successorGoalReceipt = null}) {
  if (!revivalAttempted && archived) return lifecycleAuthority ? 'UNARCHIVE_AND_WAKE_SAVED_OWNER' : 'RECOVER_LIFECYCLE_AUTHORITY';
  if (!revivalAttempted) return 'WAKE_SAVED_OWNER';
  if (savedOwnerReachable) return 'RESUME_SAVED_OWNER';
  if (!terminalOrUnreachableProved) return 'RECONCILE_NO_SUCCESSOR';
  if (!exactTakeoverIntent(takeoverIntent, {planId, predecessorEpoch})) return 'PERSIST_TAKEOVER_INTENT';
  if (!guardedRotationReadback) return 'ROTATE_OWNER_MODE_EPOCH_ATOMICALLY';
  if (typeof postFenceQuiescenceRef !== 'string' || postFenceQuiescenceRef.length === 0) return 'PROVE_POST_FENCE_QUIESCENCE';
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
assert.strictEqual(supervisorRecoveryDecision({revivalAttempted: true, terminalOrUnreachableProved: true}), 'PERSIST_TAKEOVER_INTENT');
assert.strictEqual(supervisorRecoveryDecision({revivalAttempted: true, terminalOrUnreachableProved: true, takeoverIntent: missingEpochIntent}), 'PERSIST_TAKEOVER_INTENT');
assert.strictEqual(supervisorRecoveryDecision({revivalAttempted: true, terminalOrUnreachableProved: true, takeoverIntent: wrongFenceIntent}), 'PERSIST_TAKEOVER_INTENT');
assert.strictEqual(supervisorRecoveryDecision({revivalAttempted: true, terminalOrUnreachableProved: true, takeoverIntent}), 'ROTATE_OWNER_MODE_EPOCH_ATOMICALLY');
assert.strictEqual(supervisorRecoveryDecision({revivalAttempted: true, terminalOrUnreachableProved: true, takeoverIntent, guardedRotationReadback: true}), 'PROVE_POST_FENCE_QUIESCENCE');
assert.strictEqual(supervisorRecoveryDecision({revivalAttempted: true, terminalOrUnreachableProved: true, takeoverIntent, guardedRotationReadback: true, postFenceQuiescenceRef: 'post-fence-quiescence-a'}), 'CREATE_ONE_RECOVERY_SUCCESSOR');
assert.strictEqual(supervisorRecoveryDecision({revivalAttempted: true, terminalOrUnreachableProved: true, takeoverIntent, guardedRotationReadback: true, postFenceQuiescenceRef: 'post-fence-quiescence-a', successorGoalReceipt: 'goal-successor-a'}), 'ACTIVATE_SUCCESSOR');

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
const actionIntent = {action_key: 'plan-a:r1:i1:message:E01:g1', action: 'message', target_ref: 'executorA', effect_ref: 'handoff-a', authority_source_ref: 'message-brief-go', role: 'executor', task_ref: 'E01', task_generation: 1, contract_hash: 'contract-e01-g1', manifest_hash: 'manifest-hash-e01-g1', planned_route: 'gpt-5.6-luna/max', observed_route: 'gpt-5.6-luna/max', route_evidence_ref: 'turn-context-a', stack_snapshot_ref: 'stack-a', project_id: 'project-a', directory_name: null, environment: 'local', adopted_session_ref: null, plan_id: 'plan-a', plan_revision: 1, intent_revision: 1, epoch: 1, result: 'pending'};
assert(validatePlan({...plan, native_action_intents: [actionIntent]}));
const createIntent = {...actionIntent, action_key: 'plan-a:r1:i1:create:E01:g1', action: 'create', effect_ref: 'create-executor-a', observed_route: null, route_evidence_ref: null};
assert(validatePlan({...plan, native_action_intents: [createIntent]}));
assert.throws(() => validatePlan({...plan, native_action_intents: [{...createIntent, planned_route: ''}]}));
assert.throws(() => validatePlan({...redirected, native_action_intents: [actionIntent]}));
assert.throws(() => validatePlan({...plan, native_action_intents: [{...actionIntent, effect_ref: ''}]}));
assert.throws(() => validatePlan({...plan, native_action_intents: [{...actionIntent, action: 'delete'}]}));
assert.throws(() => validatePlan({...plan, native_action_intents: [actionIntent, {...actionIntent}]}));
const projectlessPlan = {...plan, brief: {...plan.brief, project_id: null, directory_name: 'projectless-output', native_environments: [null], child_route: 'native-task/projectless'}, authority: {...plan.authority, project_id: null, directory_name: 'projectless-output', environments: [null], child_route: 'native-task/projectless'}};
const projectlessIntent = {...actionIntent, project_id: null, directory_name: 'projectless-output', environment: null};
assert(validatePlan({...projectlessPlan, native_action_intents: [projectlessIntent]}));
assert.throws(() => validatePlan({...projectlessPlan, native_action_intents: [{...projectlessIntent, directory_name: null}]}));
const confirmedIntent = {...actionIntent, result: 'confirmed'};
const actionReceipt = {action_key: actionIntent.action_key, action: 'message', target_ref: 'executorA', observed_effect_ref: 'handoff-a', authority_source_ref: 'message-brief-go', plan_id: 'plan-a', plan_revision: 1, intent_revision: 1, epoch: 1, task_generation: 1, manifest_hash: 'manifest-hash-e01-g1', observed_route: 'gpt-5.6-luna/max', stack_snapshot_ref: 'stack-a', result: 'confirmed', evidence_ref: 'thread-read-a'};
assert(validatePlan({...plan, native_action_intents: [confirmedIntent], native_action_receipts: [actionReceipt]}));
assert(validatePlan({...redirected, native_action_intents: [confirmedIntent], native_action_receipts: [actionReceipt]}));
const narrowedRedirected = {...redirected, brief: {...redirected.brief, native_actions: ['create']}, authority: {...redirected.authority, actions: ['create']}};
assert(validatePlan({...narrowedRedirected, native_action_intents: [confirmedIntent], native_action_receipts: [actionReceipt]}));
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
assert(!authorityCovers(plan.authority, {...authorityActor, role: 'follow-up'}, 'message'));
assert(!authorityCovers(plan.authority, {...authorityActor, adopted_session_ref: 'adopted-a'}, 'message'));
assert(authorityCovers({...plan.authority, adopted_session_refs: ['adopted-a']}, {...authorityActor, adopted_session_ref: 'adopted-a'}, 'message'));
assert(!authorityCovers({...plan.authority, delivery: false}, authorityActor, 'message'));

function beginReplan(previous) {
  return {...asReplanning(previous), acceptedPasses: []};
}
const replanned = beginReplan({...plan, acceptedPasses: ['pass-a']});
assert.strictEqual(replanned.revision, 1);
assert.strictEqual(replanned.proposed_revision, 2);
assert.deepStrictEqual(replanned.acceptedPasses, []);
assert.strictEqual(replanned.proposed_review, null);
assert.strictEqual(replanned.planning.leases[0].status, 'expired');
assert.strictEqual(replanned.planning.leases[1].session_ref, 'planner-r2');
assert.notStrictEqual(replanned.planning.leases[0].session_ref, replanned.planning.leases[1].session_ref);

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

function contextDecision(change, actorHealthy = true) {
  const material = ['taskMeaning', 'splitMerge', 'outputs', 'graph', 'route', 'acceptance', 'authority', 'contract', 'rewriteFromScratch', 'generation', 'unadoptableDrift'].some(key => change[key] === true);
  if (material) return 'FENCE_AND_FRESH_WRITER';
  return actorHealthy && change.sameArtifact && change.sameBase ? 'REUSE_AND_TARGETED_RECHECK' : 'FRESH_WRITER';
}
assert.strictEqual(contextDecision({sameArtifact: true, sameBase: true}), 'REUSE_AND_TARGETED_RECHECK');
assert.strictEqual(contextDecision({splitMerge: true, sameArtifact: true, sameBase: true}), 'FENCE_AND_FRESH_WRITER');
assert.strictEqual(contextDecision({generation: true}), 'FENCE_AND_FRESH_WRITER');
assert.strictEqual(contextDecision({sameArtifact: true, sameBase: true}, false), 'FRESH_WRITER');

function substantiveResumeDecision({materialChange = false, compacted = false, supersededIntent = false, resumesWithoutProgress = 0, acceptedProgress = false}) {
  if (materialChange || resumesWithoutProgress >= 3) return 'REPLACE';
  if (acceptedProgress) return 'REUSE';
  if (compacted || supersededIntent || resumesWithoutProgress >= 2) return 'ADMIT_CONTEXT';
  return 'REUSE';
}
assert.strictEqual(substantiveResumeDecision({}), 'REUSE');
assert.strictEqual(substantiveResumeDecision({compacted: true}), 'ADMIT_CONTEXT');
assert.strictEqual(substantiveResumeDecision({supersededIntent: true}), 'ADMIT_CONTEXT');
assert.strictEqual(substantiveResumeDecision({resumesWithoutProgress: 2}), 'ADMIT_CONTEXT');
assert.strictEqual(substantiveResumeDecision({resumesWithoutProgress: 3}), 'REPLACE');
assert.strictEqual(substantiveResumeDecision({materialChange: true, acceptedProgress: true}), 'REPLACE');

function planningContinuityDecision({materialReplan = false, volumetricDiagnosis = false, sameRevision = true, sameCandidate = true, sameIntent = true, sameSnapshot = true}) {
  if (materialReplan || volumetricDiagnosis) return 'FRESH_PLANNER';
  return sameRevision && sameCandidate && sameIntent && sameSnapshot ? 'REUSE_LEASE' : 'FRESH_PLANNER';
}
assert.strictEqual(planningContinuityDecision({}), 'REUSE_LEASE');
assert.strictEqual(planningContinuityDecision({materialReplan: true}), 'FRESH_PLANNER');
assert.strictEqual(planningContinuityDecision({volumetricDiagnosis: true}), 'FRESH_PLANNER');
assert.strictEqual(planningContinuityDecision({sameIntent: false}), 'FRESH_PLANNER');

function supervisorWorkDecision({materialReplan = false, volumetric = false}) {
  return materialReplan || volumetric ? 'DELEGATE_FRESH_PLN' : 'HANDLE_THIN_CONTROL';
}
assert.strictEqual(supervisorWorkDecision({}), 'HANDLE_THIN_CONTROL');
assert.strictEqual(supervisorWorkDecision({materialReplan: true}), 'DELEGATE_FRESH_PLN');
assert.strictEqual(supervisorWorkDecision({volumetric: true}), 'DELEGATE_FRESH_PLN');

function reviewType({materialChange, sameGeneration, sameArtifact, stableFinding, sameReviewer}) {
  if (materialChange || !sameGeneration || !sameArtifact) return 'full_independent_fresh';
  return stableFinding && sameReviewer ? 'targeted_recheck' : 'full_independent_fresh';
}
assert.strictEqual(reviewType({materialChange: true, sameGeneration: false, sameArtifact: false, stableFinding: false, sameReviewer: true}), 'full_independent_fresh');
assert.strictEqual(reviewType({materialChange: false, sameGeneration: true, sameArtifact: true, stableFinding: true, sameReviewer: true}), 'targeted_recheck');

function writerActivation({stopAck, quiescent, generationRotated, supervisorEpochUnchanged, transferReceipt, createReceipt, bindingReadback, manifestAck, stackFresh}) {
  return [stopAck, quiescent, generationRotated, supervisorEpochUnchanged, transferReceipt, createReceipt, bindingReadback, manifestAck, stackFresh].every(Boolean) ? 'ACTIVATE' : 'BLOCK';
}
const handoff = {stopAck: true, quiescent: true, generationRotated: true, supervisorEpochUnchanged: true, transferReceipt: true, createReceipt: true, bindingReadback: true, manifestAck: true, stackFresh: true};
assert.strictEqual(writerActivation(handoff), 'ACTIVATE');
assert.strictEqual(writerActivation({...handoff, quiescent: false}), 'BLOCK');
assert.strictEqual(writerActivation({...handoff, supervisorEpochUnchanged: false}), 'BLOCK');
assert.strictEqual(writerActivation({...handoff, bindingReadback: false}), 'BLOCK');

function observedRouteAdmission(plannedModel, plannedEffort, observedModel, observedEffort, evidence = true) {
  if (!evidence || plannedModel !== observedModel || plannedEffort !== observedEffort) return 'PAUSE';
  return validChildRoute(observedModel, observedEffort) ? 'PASS' : 'PAUSE';
}
assert.strictEqual(observedRouteAdmission('gpt-5.6-luna', 'max', 'gpt-5.6-luna', 'max'), 'PASS');
assert.strictEqual(observedRouteAdmission('gpt-5.6-luna', 'max', 'gpt-5.6-luna', 'high'), 'PAUSE');
assert.strictEqual(observedRouteAdmission('gpt-5.6-sol', 'high', 'gpt-5.6-terra', 'max'), 'PAUSE');
assert.strictEqual(observedRouteAdmission('gpt-5.6-sol', 'high', 'gpt-5.6-sol', 'high', false), 'PAUSE');

function stackGate({mode, main, bases, heads, ancestry, diffs, migrations, checks, verifierCoverage, fresh}) {
  const complete = [main, bases, heads, ancestry, diffs, migrations, checks, verifierCoverage, fresh].every(Boolean);
  if (mode === 'read-only' && !complete) return 'CONTINUE_BOUNDED_READ_ONLY';
  return complete ? 'PASS' : 'BLOCK_WRITER';
}
const freshStack = {mode: 'writer', main: true, bases: true, heads: true, ancestry: true, diffs: true, migrations: true, checks: true, verifierCoverage: true, fresh: true};
assert.strictEqual(stackGate(freshStack), 'PASS');
assert.strictEqual(stackGate({...freshStack, migrations: false}), 'BLOCK_WRITER');
assert.strictEqual(stackGate({...freshStack, mode: 'read-only', migrations: false}), 'CONTINUE_BOUNDED_READ_ONLY');

function baselineLeaseDecision({gate, collision = false, overlappingDrift = false}) {
  if (['dispatch', 'first-effect', 'push', 'review', 'handoff'].includes(gate) || collision || overlappingDrift) return 'REFRESH';
  return 'KEEP';
}
for (const gate of ['dispatch', 'first-effect', 'push', 'review', 'handoff']) assert.strictEqual(baselineLeaseDecision({gate}), 'REFRESH');
assert.strictEqual(baselineLeaseDecision({gate: 'poll', overlappingDrift: false}), 'KEEP');
assert.strictEqual(baselineLeaseDecision({gate: 'poll', collision: true}), 'REFRESH');

function deliveryArtifactTransition(from, to) {
  const allowed = {
    'branch-only': ['draft', 'closed', 'superseded'],
    draft: ['ready-for-review', 'closed', 'superseded'],
    'ready-for-review': ['draft', 'waiting-human', 'merged', 'closed', 'superseded'],
    'waiting-human': ['draft', 'ready-for-review', 'merged', 'closed', 'superseded'],
    merged: [], closed: [], superseded: []
  };
  return allowed[from]?.includes(to) === true;
}
assert(deliveryArtifactTransition('branch-only', 'draft'));
assert(deliveryArtifactTransition('draft', 'ready-for-review'));
assert(deliveryArtifactTransition('ready-for-review', 'waiting-human'));
assert(deliveryArtifactTransition('waiting-human', 'merged'));
assert(deliveryArtifactTransition('draft', 'superseded'));
assert(!deliveryArtifactTransition('draft', 'merged'));
assert(!deliveryArtifactTransition('merged', 'draft'));

const draftArtifact = {kind: 'pull-request', artifact_ref: 'pr-616', repository_ref: 'repo-a', base_ref: 'base-a', head_ref: 'head-a', state: 'draft', owner_actor_ref: 'executorA', next_transition: 'mark ready or supersede', blocker: 'plan revision pending', resume_predicate: 'plan revision accepted', disposition: 'active', evidence_ref: 'pr-readback-a'};
const activeWriter = {...actorBase, state: 'active', previous_state: null};
const planWithActiveWriter = withActors(plan, {executorA: activeWriter});
assert(validatePlan({...planWithActiveWriter, delivery_artifacts: {E01: [draftArtifact]}}));
assert.throws(() => validatePlan({...planWithActiveWriter, delivery_artifacts: {E01: [{...draftArtifact, owner_actor_ref: ''}]}}));
assert.throws(() => validatePlan({...plan, delivery_artifacts: {E01: [draftArtifact]}}));
assert.throws(() => validatePlan({...completedPlan, delivery_artifacts: {E01: [draftArtifact]}}));
assert(validatePlan({...completedPlan, delivery_artifacts: {E01: [{...draftArtifact, state: 'superseded', disposition: 'historical', blocker: null, next_transition: 'none', resume_predicate: 'terminal'}]}}));
assert.throws(() => validatePlan({...planWithActiveWriter, status: 'superseded', delivery_artifacts: {E01: [draftArtifact]}}));
assert(validatePlan({...plan, status: 'superseded', delivery_artifacts: {E01: [{...draftArtifact, state: 'superseded', disposition: 'historical', blocker: null, next_transition: 'none', resume_predicate: 'terminal'}]}}));

function progressCircuitDecision({acceptedProgress = false, materialReplans = 0, graphHashes = [], comparableCycles = 0}) {
  const repeatedGraph = new Set(graphHashes).size !== graphHashes.length;
  if (!acceptedProgress && (materialReplans >= 2 || comparableCycles >= 2 || repeatedGraph)) return 'OPEN_INCIDENT_AND_DIAGNOSE';
  return 'CONTINUE';
}
assert.strictEqual(progressCircuitDecision({materialReplans: 1, graphHashes: ['a', 'b'], comparableCycles: 1}), 'CONTINUE');
assert.strictEqual(progressCircuitDecision({materialReplans: 2, graphHashes: ['a', 'b']}), 'OPEN_INCIDENT_AND_DIAGNOSE');
assert.strictEqual(progressCircuitDecision({graphHashes: ['a', 'b', 'a']}), 'OPEN_INCIDENT_AND_DIAGNOSE');
assert.strictEqual(progressCircuitDecision({comparableCycles: 2}), 'OPEN_INCIDENT_AND_DIAGNOSE');
assert.strictEqual(progressCircuitDecision({acceptedProgress: true, materialReplans: 2, comparableCycles: 2}), 'CONTINUE');
assert.throws(() => validatePlan({...plan, efficiency: {...plan.efficiency, material_replan_streak: 2}}));
const openedReplanIncident = {incident_ref: 'replan-incident-a', kind: 'replan', state: 'opened', diagnosis_ref: null, disposition_ref: null};
const diagnosedReplanIncident = {...openedReplanIncident, state: 'diagnosed', diagnosis_ref: 'replan-diagnosis-a'};
const adoptedReplanIncident = {...diagnosedReplanIncident, state: 'adopted', disposition_ref: 'replan-disposition-a'};
assert(validatePlan({...plan, efficiency: {...plan.efficiency, material_replan_streak: 2, incident: openedReplanIncident}}));
assert(validatePlan({...plan, efficiency: {...plan.efficiency, material_replan_streak: 2, incident: diagnosedReplanIncident}}));
assert(validatePlan({...plan, efficiency: {...plan.efficiency, material_replan_streak: 2, incident: adoptedReplanIncident}}));
assert.throws(() => validatePlan(withActors({...plan, efficiency: {...plan.efficiency, material_replan_streak: 2, incident: openedReplanIncident}}, {executorA: activeWriter})));
assert(validatePlan(withActors({...plan, efficiency: {...plan.efficiency, material_replan_streak: 2, incident: adoptedReplanIncident}}, {executorA: activeWriter})));
assert.throws(() => validatePlan({...plan, efficiency: {...plan.efficiency, accepted_progress_ref: 'accepted-a', accepted_progress_kind: 'artifact', material_replan_streak: 2}}));
assert(validatePlan({...plan, efficiency: {...plan.efficiency, accepted_progress_ref: 'accepted-a', accepted_progress_kind: 'artifact', material_replan_streak: 0, comparable_cycles_without_progress: 0, graph_hash_history: ['graph-accepted']}}));

function compactState({size, budget, receipt}) {
  if (size < budget) return 'KEEP';
  return receipt && ['pre_hash', 'post_hash', 'essential_fields_ref', 'readback_ref', 'no_loss_ref'].every(key => receipt[key]) ? 'COMPACT' : 'BLOCK_COMPACTION';
}
const compactionReceipt = {pre_hash: 'pre', post_hash: 'post', essential_fields_ref: 'fields', readback_ref: 'readback', no_loss_ref: 'no-loss'};
assert.strictEqual(compactState({size: 100, budget: 200, receipt: null}), 'KEEP');
assert.strictEqual(compactState({size: 200, budget: 200, receipt: compactionReceipt}), 'COMPACT');
assert.strictEqual(compactState({size: 200, budget: 200, receipt: null}), 'BLOCK_COMPACTION');

function metricSnapshot(metric, value, source, population, windowStart, windowEnd) {
  assert(metric && source && population && windowStart && windowEnd);
  assert(value === 'unavailable' || typeof value === 'number');
  return {metric, value, source, population, windowStart, windowEnd};
}
assert.strictEqual(metricSnapshot('tokens', 126359, 'goal-counter', 'supervisor-goal', '08:13', '08:24').population, 'supervisor-goal');
assert.strictEqual(metricSnapshot('tokens', 'unavailable', 'runtime', 'executor-session', '08:24', 'close').value, 'unavailable');

console.log('PASS: Octoplan 15.0 planner, context, artifact, efficiency, lifecycle, review, and routing fixtures');
NODE

if [ "$codex_only" = false ]; then
  grep -q '^### 13\.1\.0 — 2026-08-11$' "$changelog" || fail 'Codex changelog lacks 13.1.0'
  grep -q '^### 14\.0\.0 — 2026-08-12$' "$changelog" || fail 'Codex changelog lacks 14.0.0'
  grep -q '^### 15\.0\.0 — 2026-08-12$' "$changelog" || fail 'Codex changelog lacks 15.0.0'
fi

printf 'PASS: Octoplan Codex 15.0.0 contract\n'
