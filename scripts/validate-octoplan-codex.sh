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
roles="$skill/roles"
manifest="$root/plugins/octoplan-codex/.codex-plugin/plugin.json"
agent_manifest="$skill/agents/openai.yaml"

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

case "$codex_only" in
  true|false) ;;
  *) fail 'OCTOPLAN_CODEX_ONLY must be true or false' ;;
esac

for file in "$skill/SKILL.md" "$planning" "$state" "$runtime" "$supervision" "$manifest" "$agent_manifest"; do
  require_file "$file"
done
for role in planner plan-reviewer supervisor executor reviewer specialist-reviewer recovery follow-up; do
  require_file "$roles/$role.md"
done

grep -q '^Version: 16\.0\.0$' "$skill/SKILL.md" || fail 'Codex SKILL.md is not 16.0.0'
grep -q '"version": "16\.0\.0"' "$manifest" || fail 'Codex plugin is not 16.0.0'
if [ "$codex_only" = false ]; then
  grep -Fq '| [`octoplan-codex`](plugins/octoplan-codex/skills/octoplan/SKILL.md) | Codex | 16.0.0 | Calibrates and challenges the plan, then supervises delivery after the user authorizes that scope. |' "$root/README.md" || fail 'README Codex version or behavior is stale'
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
for legacy in 3 4 5; do
  require_text "$skill/references/octoplan-contract-v$legacy.md" 'create a fresh reviewed v6 plan'
done

active_docs="$skill/SKILL.md $planning $state $runtime $supervision"
for forbidden in 'octoplan-plan-v5' 'base_stack_ref' 'stack_snapshots' 'baseline_leases' 'planner lease' 'parallel_safe_now' 'context_admission'; do
  if grep -Fq "$forbidden" $active_docs; then
    fail "retired universal control field remains active: $forbidden"
  fi
done

skill_lines=$(wc -l < "$skill/SKILL.md" | tr -d ' ')
planning_lines=$(wc -l < "$planning" | tr -d ' ')
state_lines=$(wc -l < "$state" | tr -d ' ')
runtime_lines=$(wc -l < "$runtime" | tr -d ' ')
supervision_lines=$(wc -l < "$supervision" | tr -d ' ')
[ "$skill_lines" -le 48 ] || fail "SKILL.md exceeds 48 lines: $skill_lines"
[ "$planning_lines" -le 120 ] || fail "planning.md exceeds 120 lines: $planning_lines"
[ "$state_lines" -le 145 ] || fail "state-and-recovery.md exceeds 145 lines: $state_lines"
[ "$runtime_lines" -le 80 ] || fail "codex-runtime.md exceeds 80 lines: $runtime_lines"
[ "$supervision_lines" -le 130 ] || fail "codex-supervision.md exceeds 130 lines: $supervision_lines"
active_lines=$((skill_lines + planning_lines + state_lines + runtime_lines + supervision_lines))
active_words=$(wc -w $active_docs | awk 'END {print $1}')
[ "$active_lines" -le 500 ] || fail "active skill documents exceed 500 lines: $active_lines"
[ "$active_words" -le 7000 ] || fail "active skill documents exceed 7000 words: $active_words"

require_text "$skill/SKILL.md" 'Only `octoplan-plan-v6` is supported.'
require_text "$skill/SKILL.md" '`shape = simple|structured|adaptive`'
require_text "$skill/SKILL.md" '`consequence = reversible|material|protected`'
require_text "$skill/SKILL.md" 'Preserve the documented Luna/Sol model-effort router exactly.'
require_text "$skill/SKILL.md" '`repository`, `content`, `research`, or `operations`'
require_text "$skill/SKILL.md" 'Every spawned agent'
require_text "$planning" 'They never collapse into one tier'
require_text "$planning" 'simple deletion may be protected'
require_text "$planning" 'Scale one review session rather than multiplying reviewers'
require_text "$planning" 'Corrections to stable findings return to the same session'
require_text "$planning" 'treats the immutable packet'
require_text "$planning" 'starts a production Octopad session'
require_text "$planning" 'A coherent task may own several profiles'
require_text "$planning" 'The plan-level maximum does not raise every task.'
require_text "$planning" 'they never replace the fresh record'
require_text "$state" '"schema": "octoplan-plan-v6"'
require_text "$state" '"calibration": {"shape": "simple|structured|adaptive", "consequence": "reversible|material|protected"'
require_text "$state" '"pending_actions": {'
require_text "$state" '"active_actors": {'
require_text "$state" '"octopad_context_ref"'
require_text "$state" '`plan_review.fresh` is immutable and mandatory'
require_text "$state" 'A targeted recheck alone never activates a plan.'
require_text "$state" 'Inline work omits actor bindings, not effect intents.'
require_text "$state" 'Never create a bookkeeping or status task.'
require_text "$state" 'excluding the delimited state block'
require_text "$state" 'Reads, deterministic local checks, waits, and routine status polling need no action intent.'
require_text "$state" 'Do not persist mirrored dependency graphs'
require_text "$state" 'repository base/head is invalid as a universal requirement'
require_text "$runtime" 'Keep the exact mapping; do not replace it with a vague capability label.'
require_text "$runtime" 'The only valid automatic routes are Luna `max` and Sol `high|xhigh|max`'
require_text "$runtime" 'Simple sequential work stays with the supervisor'
require_text "$runtime" 'Prompt text, title, or the requested route is not observation.'
require_text "$runtime" 'Content, research, and operations use their profile version'
require_text "$runtime" 'never invent a Git snapshot'
require_text "$supervision" 'Classify each obstacle:'
require_text "$supervision" '`transient`'
require_text "$supervision" '`evidence-gap`'
require_text "$supervision" '`in-envelope`'
require_text "$supervision" '`material`'
require_text "$supervision" '`protected`'
require_text "$supervision" 'benefit exceeds handoff cost'
require_text "$supervision" 'production Octopad session'
require_text "$supervision" 'every artifact terminal with a non-active disposition'

require_text "$agent_manifest" 'allow_implicit_invocation: false'
plugin_prompt=$(node -p 'require(process.argv[1]).interface.defaultPrompt[0]' "$manifest")
agent_prompt=$(sed -n 's/^  default_prompt: "\(.*\)"$/\1/p' "$agent_manifest")
[ -n "$plugin_prompt" ] && [ "${#plugin_prompt}" -le 128 ] || fail 'plugin default prompt exceeds 128 characters'
[ "$plugin_prompt" = "$agent_prompt" ] || fail 'plugin and agent default prompts differ'

for role in planner plan-reviewer supervisor executor reviewer specialist-reviewer recovery follow-up; do
  require_text "$roles/$role.md" 'production Octopad session'
done
require_text "$roles/plan-reviewer.md" 'read-only reviewer'
require_text "$roles/plan-reviewer.md" 'immutable review packet'
require_text "$roles/plan-reviewer.md" 'Do not write Octopad'
require_text "$roles/plan-reviewer.md" 'same session'
require_text "$roles/plan-reviewer.md" 'Only Luna `max` or Sol `high|xhigh|max` is admissible'

[ "$(grep -Fc '| Work profile |' "$runtime")" -eq 1 ] || fail 'capacity ladder is duplicated or missing'
[ "$(grep -Ec '^\| .*`gpt-5\.6-' "$runtime")" -eq 4 ] || fail 'capacity ladder does not have four exact routes'

changes_file=$(mktemp "${TMPDIR:-/tmp}/octoplan-changes.XXXXXX")
trap 'rm -f "$changes_file"' EXIT HUP INT TERM
{
  git -C "$root" diff --no-renames --no-ext-diff --no-textconv --name-only origin/main
  git -C "$root" diff --no-renames --no-ext-diff --no-textconv --cached --name-only
  git -C "$root" ls-files --others --exclude-standard
} | sort -u > "$changes_file"

worktree_matches_oid() {
  worktree_root=$1
  worktree_path=$2
  expected_oid=$3
  worktree_oid=$(git -C "$worktree_root" hash-object --path="$worktree_path" -- "$worktree_root/$worktree_path") || return 1
  [ "$worktree_oid" = "$expected_oid" ]
}

private_material_pattern="/""Users/|[[:alnum:]._%+-]+@[[:alnum:].-]+\.[[:alpha:]]{2,}|BEGIN (RSA |OPENSSH |EC )?PRIVATE KEY"
while IFS= read -r changed; do
  [ -n "$changed" ] || continue
  case "$changed" in
    .claude-plugin|.claude-plugin/*|plugins/octoplan-claude|plugins/octoplan-claude/*)
      fail "protected Claude surface changed: $changed"
      ;;
  esac
  skip_content_audit=false
  if [ "$codex_only" = true ]; then
    case "$changed" in
      CHANGELOG.md|README.md|INSTALL.md|CONTRIBUTING.md|scripts/validate-repository.sh|docs/clients/*)
        staged_entry=$(git -C "$root" ls-files --stage -- "$changed")
        staged_oid=$(printf '%s\n' "$staged_entry" | awk '$3 == "0" {print $2}')
        base_oid=$(git -C "$root" ls-tree origin/main -- "$changed" | awk '{print $3}')
        [ -n "$staged_oid" ] && [ "$staged_oid" != "$base_oid" ] || fail "shared surface is not staged as a reviewed change: $changed"
        case "$codex_shared_reviewed" in
          *" $changed=$staged_oid "*)
            worktree_matches_oid "$root" "$changed" "$staged_oid" || fail "shared surface has unreviewed worktree drift: $changed"
            skip_content_audit=true
            ;;
          *) fail "shared surface lacks an exact staged-blob review receipt: $changed=$staged_oid" ;;
        esac
        ;;
    esac
  fi
  if [ "$skip_content_audit" = false ] && [ -f "$root/$changed" ] && sed 's/support@octopad\.ai//g' "$root/$changed" | grep -E "$private_material_pattern" >/dev/null 2>&1; then
    fail "private or identifying material appears in public file: $changed"
  fi
done < "$changes_file"

if [ "$codex_only" = false ]; then
  origin_claude=$(git -C "$root" show origin/main:CHANGELOG.md | sed -n '/^## octoplan-claude$/,$p')
  current_claude=$(sed -n '/^## octoplan-claude$/,$p' "$root/CHANGELOG.md")
  [ "$origin_claude" = "$current_claude" ] || fail 'Claude changelog section changed without a Claude release'
fi

node <<'NODE'
const assert = require('assert');
const {createHash} = require('crypto');

const shapes = new Set(['simple', 'structured', 'adaptive']);
const consequences = new Set(['reversible', 'material', 'protected']);
const profiles = new Set(['repository', 'content', 'research', 'operations']);
const statuses = new Set(['planning', 'planned', 'active', 'replanning', 'waiting-human', 'paused', 'completed', 'superseded']);
const roles = new Set(['executor', 'reviewer', 'specialist-reviewer', 'planner', 'recovery', 'follow-up']);

function validRoute(model, effort) {
  return (model === 'gpt-5.6-luna' && effort === 'max') ||
    (model === 'gpt-5.6-sol' && ['high', 'xhigh', 'max'].includes(effort));
}

function routeDecision(model, effort, observed = true, available = true) {
  return observed && available && validRoute(model, effort) ? 'USE_EXACT' : 'PAUSE_NO_SUBSTITUTION';
}

assert.strictEqual(routeDecision('gpt-5.6-luna', 'max'), 'USE_EXACT');
assert.strictEqual(routeDecision('gpt-5.6-luna', 'high'), 'PAUSE_NO_SUBSTITUTION');
assert.strictEqual(routeDecision('gpt-5.6-sol', 'high'), 'USE_EXACT');
assert.strictEqual(routeDecision('gpt-5.6-sol', 'xhigh'), 'USE_EXACT');
assert.strictEqual(routeDecision('gpt-5.6-sol', 'max'), 'USE_EXACT');
assert.strictEqual(routeDecision('gpt-5.6-terra', 'max'), 'PAUSE_NO_SUBSTITUTION');
assert.strictEqual(routeDecision('gpt-5.6-sol', 'high', false), 'PAUSE_NO_SUBSTITUTION');
assert.strictEqual(routeDecision('gpt-5.6-sol', 'high', true, false), 'PAUSE_NO_SUBSTITUTION');

function calibrateShape(work) {
  if (work.methodUncertain || work.crossDomain || work.weakVerifier || work.likelyReplan) return 'adaptive';
  if ((work.deliverables ?? 1) > 2 || work.dependencies || (work.owners ?? 1) > 1 || (work.integrationPoints ?? 0) > 1) return 'structured';
  return 'simple';
}

function calibrateConsequence(work) {
  if (work.irreversible || work.privileged || work.financial || work.regulated || work.destructive || work.separateHumanGate) return 'protected';
  if (work.public || work.dataBearing || work.securityPrivacy || work.costlyRework) return 'material';
  return 'reversible';
}

assert.strictEqual(calibrateShape({deliverables: 1}), 'simple');
assert.strictEqual(calibrateShape({deliverables: 4, dependencies: true}), 'structured');
assert.strictEqual(calibrateShape({deliverables: 1, methodUncertain: true}), 'adaptive');
assert.strictEqual(calibrateConsequence({internal: true}), 'reversible');
assert.strictEqual(calibrateConsequence({public: true}), 'material');
assert.strictEqual(calibrateConsequence({destructive: true}), 'protected');
assert.deepStrictEqual({shape: calibrateShape({deliverables: 1}), consequence: calibrateConsequence({destructive: true})}, {shape: 'simple', consequence: 'protected'});
assert.deepStrictEqual({shape: calibrateShape({crossDomain: true}), consequence: calibrateConsequence({internal: true})}, {shape: 'adaptive', consequence: 'reversible'});

function planReviewLenses({shape, consequence}) {
  assert(shapes.has(shape) && consequences.has(consequence));
  const lenses = ['mandate', 'coverage', 'proof', 'decisions', 'dependencies', 'model-fit'];
  if (shape !== 'simple') lenses.push('critical-path', 'integration', 'wip-conflicts', 'delegation-cost', 'recovery');
  if (consequence !== 'reversible') lenses.push('reversibility', 'authority', 'access-data', 'containment', 'human-gates');
  if (shape === 'adaptive') lenses.push('uncertainty-reduction', 'stopping-conditions', 'cost-latency', 'replan-feasibility');
  return lenses;
}

assert.deepStrictEqual(planReviewLenses({shape: 'simple', consequence: 'reversible'}), ['mandate', 'coverage', 'proof', 'decisions', 'dependencies', 'model-fit']);
assert(planReviewLenses({shape: 'adaptive', consequence: 'protected'}).includes('containment'));
assert(planReviewLenses({shape: 'adaptive', consequence: 'protected'}).includes('stopping-conditions'));

function taskReviewClass({consequence, secondOrthogonalMaterialDomain = false, ruleFloor = null}) {
  let review = consequence === 'reversible' ? 'targeted' : 'independent';
  if (ruleFloor === 'independent') review = 'independent';
  return secondOrthogonalMaterialDomain ? 'specialist' : review;
}

assert.strictEqual(taskReviewClass({consequence: 'reversible'}), 'targeted');
assert.strictEqual(taskReviewClass({consequence: 'material'}), 'independent');
assert.strictEqual(taskReviewClass({consequence: 'protected'}), 'independent');
assert.strictEqual(taskReviewClass({consequence: 'reversible', ruleFloor: 'independent'}), 'independent');
assert.strictEqual(taskReviewClass({consequence: 'material', secondOrthogonalMaterialDomain: true}), 'specialist');

function delegationDecision({isolation = false, specialization = false, parallelIndependent = false, contextReduction = false, handoffCost = 1, benefit = 0}) {
  return (isolation || specialization || parallelIndependent || contextReduction) && benefit > handoffCost ? 'DELEGATE' : 'KEEP_WITH_SUPERVISOR';
}

assert.strictEqual(delegationDecision({benefit: 0}), 'KEEP_WITH_SUPERVISOR');
assert.strictEqual(delegationDecision({parallelIndependent: true, benefit: 3, handoffCost: 1}), 'DELEGATE');
assert.strictEqual(delegationDecision({specialization: true, benefit: 1, handoffCost: 1}), 'KEEP_WITH_SUPERVISOR');

function obstacleDecision({kind, attempts = 0}) {
  if (kind === 'transient') return attempts === 0 ? 'RETRY_SAME_KEY_ONCE' : 'DIAGNOSE';
  if (kind === 'evidence-gap') return 'REFRESH_AUTHORITY_SOURCE';
  if (kind === 'in-envelope') return attempts < 2 ? 'TRY_DISTINCT_REVERSIBLE_REMEDY' : 'DIAGNOSE';
  if (kind === 'material') return 'NEW_REVISION_AND_ONE_FRESH_PLAN_REVIEW';
  if (kind === 'protected') return 'OPEN_OR_RESUME_HUMAN_CHECKPOINT';
  return 'PAUSE_UNKNOWN';
}

assert.strictEqual(obstacleDecision({kind: 'transient'}), 'RETRY_SAME_KEY_ONCE');
assert.strictEqual(obstacleDecision({kind: 'transient', attempts: 1}), 'DIAGNOSE');
assert.strictEqual(obstacleDecision({kind: 'in-envelope', attempts: 1}), 'TRY_DISTINCT_REVERSIBLE_REMEDY');
assert.strictEqual(obstacleDecision({kind: 'in-envelope', attempts: 2}), 'DIAGNOSE');
assert.strictEqual(obstacleDecision({kind: 'material'}), 'NEW_REVISION_AND_ONE_FRESH_PLAN_REVIEW');
assert.strictEqual(obstacleDecision({kind: 'protected'}), 'OPEN_OR_RESUME_HUMAN_CHECKPOINT');

function validateProfileContract(profile, data) {
  assert(profiles.has(profile) && data && typeof data === 'object');
  const required = {
    repository: ['repository', 'base', 'head', 'changed_surfaces', 'checks', 'review_state'],
    content: ['document_revision', 'factual_sources', 'audience', 'approval_state', 'publication_target'],
    research: ['question', 'source_set', 'citation_coverage', 'uncertainty', 'synthesis_revision'],
    operations: ['target', 'dry_run_ref', 'approval_ref', 'execution_receipt', 'rollback_ref']
  }[profile];
  for (const key of required) assert(Object.prototype.hasOwnProperty.call(data, key));
  if (profile !== 'repository') for (const forbidden of ['repository', 'base', 'head']) assert(!Object.prototype.hasOwnProperty.call(data, forbidden));
  if (profile === 'repository' && data.migration_authored) assert(nonEmpty(data.backout_evidence));
  return true;
}

const repositoryProfile = {repository: 'repo', base: 'main', head: 'sha', changed_surfaces: ['a'], checks: ['test'], review_state: 'ready'};
const contentProfile = {document_revision: 'doc-r1', factual_sources: ['source'], audience: 'public', approval_state: 'draft', publication_target: null};
const researchProfile = {question: 'q', source_set: ['s1'], citation_coverage: 'complete', uncertainty: 'bounded', synthesis_revision: 'hash'};
const operationsProfile = {target: 'service', dry_run_ref: 'dry', approval_ref: null, execution_receipt: null, rollback_ref: 'rollback'};
const withoutKey = (value, key) => Object.fromEntries(Object.entries(value).filter(([entryKey]) => entryKey !== key));

assert(validateProfileContract('repository', repositoryProfile));
assert(validateProfileContract('content', contentProfile));
assert(validateProfileContract('research', researchProfile));
assert(validateProfileContract('operations', operationsProfile));
assert.throws(() => validateProfileContract('repository', withoutKey(repositoryProfile, 'head')));
assert.throws(() => validateProfileContract('content', withoutKey(contentProfile, 'document_revision')));
assert.throws(() => validateProfileContract('research', withoutKey(researchProfile, 'source_set')));
assert.throws(() => validateProfileContract('operations', withoutKey(operationsProfile, 'rollback_ref')));
assert.throws(() => validateProfileContract('repository', {...repositoryProfile, migration_authored: true}));
assert.throws(() => validateProfileContract('content', {...contentProfile, base: 'main'}));

function nonEmpty(value) {
  return typeof value === 'string' && value.length > 0;
}

function normalizedManifest(description) {
  assert(nonEmpty(description));
  return description
    .replace(/\r\n/g, '\n')
    .replace(/\nOCTOPLAN_STATE_BEGIN\n[\s\S]*?\nOCTOPLAN_STATE_END\s*$/, '')
    .trimEnd();
}

function manifestHash(description) {
  return createHash('sha256').update(normalizedManifest(description)).digest('hex');
}

const manifestFixture = '**Why**\nNeed the outcome.\n\n**What**\nProduce it.\n\n**Done when**\nIntegrated proof exists.';
const stateA = `${manifestFixture}\nOCTOPLAN_STATE_BEGIN\n{"revision":1}\nOCTOPLAN_STATE_END`;
const stateB = `${manifestFixture}\nOCTOPLAN_STATE_BEGIN\n{"revision":2,"status":"active"}\nOCTOPLAN_STATE_END`;
assert.strictEqual(manifestHash(stateA), manifestHash(stateB));
assert.strictEqual(manifestHash(stateA), manifestHash(manifestFixture));
assert.notStrictEqual(manifestHash(stateA), manifestHash(manifestFixture.replace('Produce it.', 'Produce the integrated result.')));

function routeFrom(value) {
  assert(nonEmpty(value) && value.includes('/'));
  const [model, effort] = value.split('/');
  assert(validRoute(model, effort));
  return {model, effort};
}

function validatePlan(plan) {
  assert.strictEqual(plan.schema, 'octoplan-plan-v6');
  assert(nonEmpty(plan.plan_id));
  assert(Number.isInteger(plan.revision) && plan.revision > 0);
  assert(statuses.has(plan.status));
  assert(plan.calibration && shapes.has(plan.calibration.shape) && consequences.has(plan.calibration.consequence) && nonEmpty(plan.calibration.rationale));
  assert(plan.context);
  for (const key of ['organization_id', 'workspace_id', 'work_stream_id', 'state_host_ref', 'native_target_ref']) assert(nonEmpty(plan.context[key]));
  assert(plan.context.project_ref === null || nonEmpty(plan.context.project_ref));
  assert(plan.contract);
  for (const key of ['brief_hash', 'source_ref', 'outcome', 'proof', 'authority']) assert(nonEmpty(plan.contract[key]));
  assert(typeof plan.contract.delivery_authorized === 'boolean');
  assert(['progressive', 'final'].includes(plan.contract.review_cadence));
  assert(plan.intent && Number.isInteger(plan.intent.revision) && plan.intent.revision > 0 && nonEmpty(plan.intent.latest_user_ref));
  assert(Array.isArray(plan.intent.superseded_action_keys));
  assert(plan.supervisor && nonEmpty(plan.supervisor.thread_ref) && Number.isInteger(plan.supervisor.epoch) && plan.supervisor.epoch > 0);
  assert.strictEqual(plan.supervisor.planned_route, plan.supervisor.observed_route);
  const supervisorRoute = routeFrom(plan.supervisor.observed_route);
  assert.strictEqual(supervisorRoute.model, 'gpt-5.6-sol');
  assert(['high', 'xhigh', 'max'].includes(supervisorRoute.effort));
  assert(nonEmpty(plan.supervisor.route_evidence_ref));
  if (plan.contract.delivery_authorized && ['active', 'replanning', 'waiting-human', 'paused', 'completed'].includes(plan.status)) assert(nonEmpty(plan.supervisor.goal_ref));
  if (!plan.contract.delivery_authorized) {
    assert.strictEqual(plan.status, 'planned');
    assert.strictEqual(plan.supervisor.goal_ref, null);
  }

  assert(plan.tasks && typeof plan.tasks === 'object' && Object.keys(plan.tasks).length > 0);
  const artifactAssignments = new Map();
  for (const [taskRef, task] of Object.entries(plan.tasks)) {
    assert(/^E[0-9]+$/.test(taskRef));
    assert(nonEmpty(task.task_id) && Number.isInteger(task.generation) && task.generation > 0);
    assert(consequences.has(task.consequence) && nonEmpty(task.manifest_hash));
    assert(Array.isArray(task.artifact_refs) && task.artifact_refs.length > 0);
    for (const artifactRef of task.artifact_refs) {
      assert(nonEmpty(artifactRef) && !artifactAssignments.has(artifactRef));
      artifactAssignments.set(artifactRef, taskRef);
    }
  }
  const consequenceRank = {reversible: 0, material: 1, protected: 2};
  const taskMaximum = Object.values(plan.tasks).reduce((maximum, task) => consequenceRank[task.consequence] > consequenceRank[maximum] ? task.consequence : maximum, 'reversible');
  assert.strictEqual(plan.calibration.consequence, taskMaximum);
  assert(plan.tasks[plan.context.state_host_ref]);

  assert(plan.plan_review && plan.plan_review.revision === plan.revision);
  const freshReview = plan.plan_review.fresh;
  assert(freshReview && freshReview.review_type === 'full_independent_fresh');
  for (const key of ['reviewer_session_ref', 'packet_hash', 'route_evidence_ref', 'octopad_context_ref', 'evidence_ref']) assert(nonEmpty(freshReview[key]));
  assert.strictEqual(freshReview.planned_route, freshReview.observed_route);
  routeFrom(freshReview.observed_route);
  assert(Array.isArray(freshReview.finding_keys) && Array.isArray(freshReview.executed_checks) && freshReview.executed_checks.length > 0);
  assert(['PASS', 'REVISE'].includes(freshReview.verdict));
  const latestRecheck = plan.plan_review.latest_recheck;
  if (freshReview.verdict === 'PASS') {
    assert.strictEqual(latestRecheck, null);
  } else {
    assert(freshReview.finding_keys.length > 0 && latestRecheck && latestRecheck.review_type === 'targeted_recheck');
    for (const key of ['reviewer_session_ref', 'packet_hash', 'evidence_ref']) assert(nonEmpty(latestRecheck[key]));
    assert.strictEqual(latestRecheck.reviewer_session_ref, freshReview.reviewer_session_ref);
    assert(Array.isArray(latestRecheck.finding_keys) && Array.isArray(latestRecheck.executed_checks) && latestRecheck.executed_checks.length > 0);
    assert(freshReview.finding_keys.every(key => latestRecheck.finding_keys.includes(key)));
    assert.strictEqual(latestRecheck.verdict, 'PASS');
  }

  assert(plan.open_checkpoints && typeof plan.open_checkpoints === 'object');
  for (const [checkpointRef, checkpoint] of Object.entries(plan.open_checkpoints)) {
    assert(/^C[0-9]+$/.test(checkpointRef));
    assert(Array.isArray(checkpoint.task_refs) && checkpoint.task_refs.length > 0 && checkpoint.task_refs.every(ref => plan.tasks[ref]));
    for (const key of ['owner', 'subject', 'resume_predicate']) assert(nonEmpty(checkpoint[key]));
    assert(checkpoint.evidence_ref === null || nonEmpty(checkpoint.evidence_ref));
  }
  if (plan.status === 'waiting-human') assert(Object.keys(plan.open_checkpoints).length > 0);

  const activeActors = plan.active_actors ?? {};
  assert(typeof activeActors === 'object');
  const actorThreads = new Set();
  for (const [actorRef, actor] of Object.entries(activeActors)) {
    assert(nonEmpty(actorRef) && nonEmpty(actor.thread_ref) && !actorThreads.has(actor.thread_ref));
    actorThreads.add(actor.thread_ref);
    assert(roles.has(actor.role) && (actor.task_ref === 'PLAN' || plan.tasks[actor.task_ref]));
    assert(Number.isInteger(actor.generation) && actor.generation > 0);
    if (actor.task_ref === 'PLAN') assert.strictEqual(actor.generation, plan.revision);
    else assert.strictEqual(actor.generation, plan.tasks[actor.task_ref].generation);
    for (const key of ['binding_hash', 'route_evidence_ref', 'octopad_context_ref']) assert(nonEmpty(actor[key]));
    assert.strictEqual(actor.planned_route, actor.observed_route);
    routeFrom(actor.observed_route);
    assert(['starting', 'active', 'waiting', 'correction', 'terminal'].includes(actor.state));
  }

  const pendingActions = plan.pending_actions ?? {};
  assert(typeof pendingActions === 'object');
  for (const [actionKey, action] of Object.entries(pendingActions)) {
    assert(nonEmpty(actionKey) && ['create', 'directive', 'effect', 'archive'].includes(action.kind));
    assert(action.task_ref === 'PLAN' || plan.tasks[action.task_ref]);
    assert(Number.isInteger(action.generation) && action.generation > 0);
    if (action.task_ref !== 'PLAN') assert(action.generation <= plan.tasks[action.task_ref].generation);
    for (const key of ['target_ref', 'authority_ref']) assert(nonEmpty(action[key]));
    assert(['pending', 'ambiguous'].includes(action.result));
  }

  assert(plan.artifacts && typeof plan.artifacts === 'object');
  assert.strictEqual(Object.keys(plan.artifacts).length, artifactAssignments.size);
  for (const [artifactRef, artifact] of Object.entries(plan.artifacts)) {
    assert.strictEqual(artifactAssignments.get(artifactRef), artifact.task_ref);
    assert(profiles.has(artifact.profile));
    for (const key of ['locator', 'version', 'owner_ref', 'verifier_ref']) assert(nonEmpty(artifact[key]));
    validateProfileContract(artifact.profile, artifact.profile_data);
    assert(['draft', 'ready', 'waiting-human', 'terminal'].includes(artifact.state));
    assert(['active', 'adopt', 'reject', 'rewrite', 'historical'].includes(artifact.disposition));
    assert(artifact.evidence_ref === null || nonEmpty(artifact.evidence_ref));
    if (artifact.state === 'terminal') {
      assert(nonEmpty(artifact.evidence_ref));
      assert.notStrictEqual(artifact.disposition, 'active');
    } else {
      assert.strictEqual(artifact.disposition, 'active');
    }
  }

  assert(plan.continuation && Array.isArray(plan.continuation.next_safe_task_refs));
  assert(plan.continuation.next_safe_task_refs.every(ref => plan.tasks[ref]));
  assert(plan.continuation.blocked && typeof plan.continuation.blocked === 'object');
  assert(plan.continuation.last_progress_ref === null || nonEmpty(plan.continuation.last_progress_ref));
  if (plan.continuation.incident !== null) {
    const incident = plan.continuation.incident;
    assert(nonEmpty(incident.key) && ['transient', 'evidence-gap', 'in-envelope', 'material', 'protected', 'efficiency'].includes(incident.kind));
    assert(Array.isArray(incident.attempt_refs) && incident.attempt_refs.length <= 2);
    assert(nonEmpty(incident.failed_predicate) && nonEmpty(incident.resume_predicate));
  }

  if (plan.status === 'completed') {
    assert(nonEmpty(plan.contract.completion_evidence_ref));
    assert.strictEqual(Object.keys(plan.open_checkpoints).length, 0);
    assert.strictEqual(Object.keys(activeActors).length, 0);
    assert.strictEqual(Object.keys(pendingActions).length, 0);
    assert(Object.values(plan.artifacts).every(artifact => artifact.state === 'terminal' && artifact.disposition !== 'active'));
    assert.strictEqual(plan.continuation.incident, null);
  }
  return true;
}

const plan = {
  schema: 'octoplan-plan-v6',
  plan_id: 'plan-a',
  revision: 1,
  status: 'active',
  calibration: {shape: 'structured', consequence: 'protected', rationale: 'known dependency graph with protected publication'},
  context: {organization_id: 'org-a', workspace_id: 'workspace-a', work_stream_id: 'stream-a', state_host_ref: 'E02', native_target_ref: 'thread-supervisor', project_ref: null},
  contract: {brief_hash: 'brief-hash-a', source_ref: 'user-turn-a', outcome: 'integrated governed release', proof: 'current artifact and publication receipts', authority: 'bounded delivery excluding protected checkpoints', delivery_authorized: true, review_cadence: 'final', completion_evidence_ref: null},
  intent: {revision: 1, latest_user_ref: 'approval-a', superseded_action_keys: []},
  supervisor: {thread_ref: 'thread-supervisor', epoch: 1, goal_ref: 'goal-a', planned_route: 'gpt-5.6-sol/high', observed_route: 'gpt-5.6-sol/high', route_evidence_ref: 'route-supervisor-a'},
  tasks: {
    E01: {task_id: 'task-code', generation: 1, consequence: 'material', manifest_hash: 'manifest-code-a', artifact_refs: ['A01']},
    E02: {task_id: 'task-content', generation: 1, consequence: 'protected', manifest_hash: 'manifest-content-a', artifact_refs: ['A02', 'A03']}
  },
  plan_review: {revision: 1, fresh: {review_type: 'full_independent_fresh', reviewer_session_ref: 'review-session-a', packet_hash: 'packet-a', planned_route: 'gpt-5.6-sol/high', observed_route: 'gpt-5.6-sol/high', route_evidence_ref: 'review-route-a', octopad_context_ref: 'octopad-review-context-a', finding_keys: [], executed_checks: ['mandate', 'integration', 'authority'], verdict: 'PASS', evidence_ref: 'review-evidence-a'}, latest_recheck: null},
  open_checkpoints: {C01: {task_refs: ['E02'], owner: 'publisher', subject: 'publish exact revision', resume_predicate: 'approval matches A03 version', evidence_ref: null}},
  active_actors: {'E01:g1:executor': {thread_ref: 'thread-executor-a', role: 'executor', task_ref: 'E01', generation: 1, binding_hash: 'binding-a', planned_route: 'gpt-5.6-sol/high', observed_route: 'gpt-5.6-sol/high', route_evidence_ref: 'route-a', octopad_context_ref: 'octopad-session-task-a', state: 'active'}},
  pending_actions: {},
  artifacts: {
    A01: {task_ref: 'E01', profile: 'repository', locator: 'repo/pr', version: 'sha-a', state: 'draft', owner_ref: 'thread-executor-a', verifier_ref: 'checks-a', evidence_ref: null, disposition: 'active', profile_data: repositoryProfile},
    A02: {task_ref: 'E02', profile: 'research', locator: 'evidence-ledger-a', version: 'research-r1', state: 'ready', owner_ref: 'thread-supervisor', verifier_ref: 'citation-review-a', evidence_ref: null, disposition: 'active', profile_data: researchProfile},
    A03: {task_ref: 'E02', profile: 'content', locator: 'doc-a', version: 'doc-r1', state: 'waiting-human', owner_ref: 'thread-supervisor', verifier_ref: 'factual-review-a', evidence_ref: null, disposition: 'active', profile_data: contentProfile}
  },
  continuation: {last_progress_ref: 'accepted-draft-a', next_safe_task_refs: ['E01'], blocked: {E02: ['C01']}, incident: null}
};

assert(validatePlan(plan));
assert.throws(() => validatePlan({...plan, schema: 'octoplan-plan-v5'}));
assert.throws(() => validatePlan({...plan, calibration: {...plan.calibration, shape: 'complex'}}));
assert.throws(() => validatePlan({...plan, calibration: {...plan.calibration, consequence: 'material'}}));
assert.throws(() => validatePlan({...plan, tasks: {...plan.tasks, E01: {...plan.tasks.E01, consequence: 'low'}}}));
assert.throws(() => validatePlan({...plan, supervisor: {...plan.supervisor, observed_route: 'gpt-5.6-terra/high'}}));
assert.throws(() => validatePlan({...plan, active_actors: {'E01:g1:executor': {...plan.active_actors['E01:g1:executor'], octopad_context_ref: ''}}}));
assert.throws(() => validatePlan({...plan, plan_review: {revision: 1, fresh: null, latest_recheck: {...plan.plan_review.fresh, review_type: 'targeted_recheck'}}}));
assert.throws(() => validatePlan({...plan, plan_review: {...plan.plan_review, fresh: {...plan.plan_review.fresh, verdict: 'REVISE', finding_keys: ['F01']}}}));
assert.throws(() => validatePlan({...plan, artifacts: {...plan.artifacts, A02: {...plan.artifacts.A02, profile: 'unknown'}}}));
assert.throws(() => validatePlan({...plan, artifacts: {...plan.artifacts, A03: {...plan.artifacts.A03, profile_data: withoutKey(contentProfile, 'audience')}}}));
assert(validatePlan({...plan, active_actors: {...plan.active_actors, 'PLAN:r1:planner': {thread_ref: 'thread-planner-a', role: 'planner', task_ref: 'PLAN', generation: 1, binding_hash: 'plan-binding-a', planned_route: 'gpt-5.6-sol/xhigh', observed_route: 'gpt-5.6-sol/xhigh', route_evidence_ref: 'route-plan-a', octopad_context_ref: 'octopad-session-plan-a', state: 'active'}}}));

const revisedPlan = {
  ...plan,
  plan_review: {
    revision: 1,
    fresh: {...plan.plan_review.fresh, verdict: 'REVISE', finding_keys: ['F01']},
    latest_recheck: {review_type: 'targeted_recheck', reviewer_session_ref: 'review-session-a', packet_hash: 'packet-a-corrected', finding_keys: ['F01'], executed_checks: ['F01'], verdict: 'PASS', evidence_ref: 'recheck-evidence-a'}
  }
};
assert(validatePlan(revisedPlan));
assert.throws(() => validatePlan({...revisedPlan, plan_review: {...revisedPlan.plan_review, latest_recheck: {...revisedPlan.plan_review.latest_recheck, reviewer_session_ref: 'different-session'}}}));

const soleTaskPlan = {
  ...plan,
  calibration: {...plan.calibration, shape: 'simple'},
  context: {...plan.context, state_host_ref: 'E02'},
  tasks: {E02: plan.tasks.E02},
  active_actors: {},
  artifacts: {A02: plan.artifacts.A02, A03: plan.artifacts.A03},
  continuation: {last_progress_ref: 'accepted-draft-a', next_safe_task_refs: [], blocked: {E02: ['C01']}, incident: null}
};
assert(validatePlan(soleTaskPlan));

const planOnly = {
  ...plan,
  status: 'planned',
  contract: {...plan.contract, delivery_authorized: false},
  supervisor: {...plan.supervisor, goal_ref: null},
  open_checkpoints: {},
  active_actors: {},
  artifacts: {
    A01: {...plan.artifacts.A01, owner_ref: 'plan-owner'},
    A02: {...plan.artifacts.A02, owner_ref: 'plan-owner', state: 'draft'},
    A03: {...plan.artifacts.A03, owner_ref: 'plan-owner', state: 'draft'}
  },
  continuation: {...plan.continuation, next_safe_task_refs: [], blocked: {}}
};
assert(validatePlan(planOnly));

const completed = {
  ...plan,
  status: 'completed',
  contract: {...plan.contract, completion_evidence_ref: 'integrated-proof-a'},
  open_checkpoints: {},
  active_actors: {},
  pending_actions: {},
  artifacts: Object.fromEntries(Object.entries(plan.artifacts).map(([ref, artifact]) => [ref, {...artifact, state: 'terminal', evidence_ref: `evidence-${ref}`, disposition: 'adopt'}])),
  continuation: {last_progress_ref: 'integrated-proof-a', next_safe_task_refs: [], blocked: {}, incident: null}
};
assert(validatePlan(completed));
assert.throws(() => validatePlan({...completed, active_actors: plan.active_actors}));
assert.throws(() => validatePlan({...completed, contract: {...completed.contract, completion_evidence_ref: null}}));

function reviewSessionDecision({previousRevision, nextRevision, stableFindings = false, materialDelta = false}) {
  if (nextRevision !== previousRevision || materialDelta) return 'ONE_NEW_FRESH_SESSION';
  return stableFindings ? 'SAME_SESSION_TARGETED_RECHECK' : 'NO_EXTRA_REVIEW';
}

assert.strictEqual(reviewSessionDecision({previousRevision: 1, nextRevision: 1, stableFindings: true}), 'SAME_SESSION_TARGETED_RECHECK');
assert.strictEqual(reviewSessionDecision({previousRevision: 1, nextRevision: 2}), 'ONE_NEW_FRESH_SESSION');
assert.strictEqual(reviewSessionDecision({previousRevision: 1, nextRevision: 1, materialDelta: true}), 'ONE_NEW_FRESH_SESSION');

function inlineActionIntent({spawned = false, mutation = false, externalSideEffect = false}) {
  return {
    activeActorRequired: spawned,
    pendingActionRequired: mutation || externalSideEffect
  };
}

assert.deepStrictEqual(inlineActionIntent({}), {activeActorRequired: false, pendingActionRequired: false});
assert.deepStrictEqual(inlineActionIntent({mutation: true}), {activeActorRequired: false, pendingActionRequired: true});
assert.deepStrictEqual(inlineActionIntent({externalSideEffect: true}), {activeActorRequired: false, pendingActionRequired: true});

console.log('PASS: Octoplan 16 calibration, compact state, profiles, review, recovery, lifecycle, and routing fixtures');
NODE

printf 'PASS: Octoplan Codex 16.0.0 contract\n'
