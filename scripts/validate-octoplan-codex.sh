#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
skill="$root/plugins/octoplan-codex/skills/octoplan"
planning="$skill/references/planning.md"
state="$skill/references/state-and-recovery.md"
runtime="$skill/references/codex-runtime.md"
supervision="$skill/references/codex-supervision.md"
tombstone="$skill/references/octoplan-contract-v3.md"
roles="$skill/roles"
manifest="$root/plugins/octoplan-codex/.codex-plugin/plugin.json"
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

for file in "$skill/SKILL.md" "$planning" "$state" "$runtime" "$supervision" "$tombstone" "$manifest"; do
  require_file "$file"
done
for role in planner plan-reviewer supervisor executor reviewer specialist-reviewer recovery follow-up; do
  require_file "$roles/$role.md"
done

grep -q '^Version: 11\.0\.0$' "$skill/SKILL.md" || fail 'Codex SKILL.md is not 11.0.0'
grep -q '"version": "11\.0\.0"' "$manifest" || fail 'Codex plugin is not 11.0.0'
grep -Fq '| [`octoplan-codex`](plugins/octoplan-codex/skills/octoplan/SKILL.md) | Codex | 11.0.0 |' "$root/README.md" || fail 'README Codex version is stale'
grep -q '^### 11\.0\.0 — 2026-08-09$' "$changelog" || fail 'Codex changelog lacks 11.0.0'

expected_refs='codex-runtime.md
codex-supervision.md
octoplan-contract-v3.md
planning.md
state-and-recovery.md'
actual_refs=$(find "$skill/references" -maxdepth 1 -type f -name '*.md' -exec basename '{}' \; | sort)
[ "$actual_refs" = "$expected_refs" ] || fail 'unexpected Codex reference set'
require_text "$tombstone" '# Octoplan 10.x contract retired'
require_text "$tombstone" 'Do not translate old fingerprints'

active_docs="$skill/SKILL.md $planning $state $runtime $supervision"
for forbidden in 'octoplan-supervision-v6' 'octoplan-fingerprint-v' 'octopad-direct-readback-v1' 'canonical review-subject' 'saved-state equality' 'byte-deterministic' 'plan_hash'; do
  if grep -Fq "$forbidden" $active_docs; then
    fail "retired blocking contract remains active: $forbidden"
  fi
done
if grep -Fq 'references/octoplan-contract-v3.md' "$skill/SKILL.md" "$planning" "$runtime" "$supervision"; then
  fail 'active documents still load the retired contract'
fi

skill_lines=$(wc -l < "$skill/SKILL.md" | tr -d ' ')
planning_lines=$(wc -l < "$planning" | tr -d ' ')
state_lines=$(wc -l < "$state" | tr -d ' ')
runtime_lines=$(wc -l < "$runtime" | tr -d ' ')
supervision_lines=$(wc -l < "$supervision" | tr -d ' ')
[ "$skill_lines" -le 45 ] || fail "SKILL.md exceeds 45 lines: $skill_lines"
[ "$planning_lines" -le 120 ] || fail "planning.md exceeds 120 lines: $planning_lines"
[ "$state_lines" -le 160 ] || fail "state-and-recovery.md exceeds 160 lines: $state_lines"
[ "$runtime_lines" -le 110 ] || fail "codex-runtime.md exceeds 110 lines: $runtime_lines"
[ "$supervision_lines" -le 140 ] || fail "codex-supervision.md exceeds 140 lines: $supervision_lines"
active_lines=$((skill_lines + planning_lines + state_lines + runtime_lines + supervision_lines))
active_words=$(wc -w $active_docs | awk 'END {print $1}')
[ "$active_lines" -le 540 ] || fail "active skill documents exceed 540 lines: $active_lines"
[ "$active_words" -le 6000 ] || fail "active skill documents exceed 6000 words: $active_words"

for toc_file in "$planning" "$state" "$runtime" "$supervision"; do
  require_text "$toc_file" '## Contents'
done
require_text "$skill/SKILL.md" 'Only `octoplan-plan-v1` is supported.'
require_text "$skill/SKILL.md" 'missing `structuredContent`'
require_text "$skill/SKILL.md" 'Record one receipt per item'
require_text "$skill/SKILL.md" 'Pause strictly for a wrong project/workspace'
require_text "$planning" 'Ask all currently material questions in one numbered batch'
require_text "$planning" 'never ask actor by actor'
require_text "$planning" 'Never retry blindly'
require_text "$planning" '`bootstrap-dispatch-ambiguous`'
require_text "$planning" 'Octoplan operation key:'
require_text "$planning" 'depends_on_refs'
require_text "$planning" 'streamed tasks use `work_stream_id` and omit `goal_id`'
require_text "$planning" 'page links use `{page_id, rationale}`'
require_text "$planning" 'It never requires exhaustive readback or byte equality.'
require_text "$state" 'Use `expected_updated_at` on every state-changing update.'
require_text "$state" 'one UUID `idempotency_key` per logical event'
require_text "$state" 'The plan ID plus approved integer revision is the execution identity.'
require_text "$state" '"execution_authority"'
require_text "$state" '`review-before-delivery` pairs only with `revision-approval`'
require_text "$state" 'OCTOPLAN_WRITE_INTENT <operation-key>'
require_text "$state" '`structuredContent` is useful when present but never mandatory.'
require_text "$state" 'Never replay the whole batch because one item is unclear.'
require_text "$state" 'Call native create at most once for that key.'
require_text "$state" '`creation-dispatch-ambiguous`'
require_text "$state" 'Targeted recovery'
require_text "$runtime" 'One exact user source may grant the finite roles'
require_text "$runtime" 'Treat `clientThreadId` as pending setup'
require_text "$runtime" 'Product, code, security, privacy, data, migration, and materially public changes require `independent`.'
require_text "$runtime" 'one additional fresh reviewer only for a second material and orthogonal failure domain'
require_text "$supervision" "Use Octopad's task graph and statuses directly"
require_text "$supervision" 'Never retry create to improve a response.'
require_text "$supervision" 'Silence, timeout, missing checks'
require_text "$supervision" 'Contact the user only for a true material choice'
require_text "$supervision" 'Secrets, access grants, spend, destructive effects, merge, migration application, deployment, publication, and acceptance'
require_text "$supervision" '`État`'
require_text "$supervision" '`Prochaine étape`'

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

const materialFields = new Set(['result', 'scope', 'success', 'taskMeaning', 'dependencies', 'parallelism', 'protectedGates', 'owner', 'route', 'authority', 'acceptance']);
const pauseReasons = new Set(['wrong-target', 'unreconcilable-duplicate', 'bootstrap-dispatch-ambiguous', 'creation-dispatch-ambiguous', 'missing-authority', 'proven-missing-write', 'revision-conflict', 'protected-gate', 'human-decision']);
const protectedKinds = new Set(['secret', 'access-grant', 'external-spend', 'destructive-effect', 'merge', 'migration-application', 'deployment', 'publication', 'acceptance']);
const runStatuses = new Set(['approved', 'active', 'replanning', 'waiting-human', 'paused', 'completed', 'superseded']);
const actorRoles = new Set(['supervisor', 'planner', 'executor', 'reviewer', 'specialist-reviewer', 'recovery', 'follow-up']);

function validatePlan(plan) {
  assert.strictEqual(plan.schema, 'octoplan-plan-v1');
  assert(typeof plan.plan_id === 'string' && plan.plan_id.length > 0);
  assert(Number.isInteger(plan.approved_revision) && plan.approved_revision > 0);
  assert(runStatuses.has(plan.status));
  for (const key of ['organization_id', 'workspace_id', 'work_stream_id', 'coordination_task_id']) assert(typeof plan[key] === 'string' && plan[key].length > 0);
  assert(plan.review && plan.review.revision === plan.approved_revision && plan.review.verdict === 'PASS');
  assert(typeof plan.review.reviewer_ref === 'string' && plan.review.reviewer_ref.length > 0);
  assert(typeof plan.review.evidence_ref === 'string' && plan.review.evidence_ref.length > 0);
  assert(plan.execution_authority && typeof plan.execution_authority.source_ref === 'string' && plan.execution_authority.source_ref.length > 0);
  assert(['revision-approval', 'bounded-outcome'].includes(plan.execution_authority.kind));
  if (plan.delivery_mode === 'review-before-delivery') {
    assert.strictEqual(plan.execution_authority.kind, 'revision-approval');
    assert.strictEqual(plan.execution_authority.approved_revision, plan.approved_revision);
    assert.strictEqual(plan.execution_authority.outcome_boundary_ref, null);
  } else {
    assert.strictEqual(plan.delivery_mode, 'autonomous-delivery');
    assert.strictEqual(plan.execution_authority.kind, 'bounded-outcome');
    assert(plan.execution_authority.approved_revision === null && typeof plan.execution_authority.outcome_boundary_ref === 'string' && plan.execution_authority.outcome_boundary_ref.length > 0);
  }
  assert(plan.supervisor && Number.isInteger(plan.supervisor.epoch) && plan.supervisor.epoch > 0);
  assert(plan.creation_grant && typeof plan.creation_grant.source_ref === 'string' && plan.creation_grant.source_ref.length > 0);
  assert(Array.isArray(plan.creation_grant.roles) && plan.creation_grant.roles.length > 0);
  assert(plan.creation_grant.roles.every(role => actorRoles.has(role)));
  assert.strictEqual(new Set(plan.creation_grant.roles).size, plan.creation_grant.roles.length);
  assert(Array.isArray(plan.creation_grant.environments) && plan.creation_grant.environments.length > 0);
  if (plan.creation_grant.project_id === null) {
    assert(typeof plan.creation_grant.directory_name === 'string' && plan.creation_grant.directory_name.length > 0);
    assert.deepStrictEqual(plan.creation_grant.environments, [null]);
  } else {
    assert(typeof plan.creation_grant.project_id === 'string' && plan.creation_grant.project_id.length > 0);
    assert.strictEqual(plan.creation_grant.directory_name, null);
    assert(plan.creation_grant.environments.every(environment => environment === 'local' || environment === 'worktree'));
    assert.strictEqual(new Set(plan.creation_grant.environments).size, plan.creation_grant.environments.length);
  }
  const refs = new Set(Object.keys(plan.task_ids));
  assert(refs.size > 0);
  assert(Object.values(plan.task_ids).every(id => typeof id === 'string' && id.length > 0));
  assert.strictEqual(new Set(Object.values(plan.task_ids)).size, refs.size);
  for (const edge of plan.desired_dependencies) {
    assert(refs.has(edge.task_ref) && refs.has(edge.depends_on_ref));
    assert(typeof edge.rationale === 'string' && edge.rationale.length > 0);
  }
  const gateKeys = new Set();
  const gateTaskRefs = new Set();
  for (const gate of plan.protected_gates) {
    assert(refs.has(gate.task_ref) && /^H[0-9]+$/.test(gate.task_ref) && protectedKinds.has(gate.kind));
    assert(typeof gate.gate_key === 'string' && gate.gate_key.length > 0 && !gateKeys.has(gate.gate_key));
    assert(['pending', 'satisfied', 'rejected'].includes(gate.state));
    assert(!gateTaskRefs.has(gate.task_ref));
    gateKeys.add(gate.gate_key);
    gateTaskRefs.add(gate.task_ref);
  }
  assert(plan.resume && Array.isArray(plan.resume.pending_operation_keys));
  return true;
}

const plan = {
  schema: 'octoplan-plan-v1', plan_id: 'plan-a', approved_revision: 1, status: 'approved',
  organization_id: 'org-a', workspace_id: 'workspace-a', work_stream_id: 'stream-a', coordination_task_id: 'task-control',
  delivery_mode: 'autonomous-delivery', task_ids: {E01: 'task-a', E02: 'task-b', H01: 'task-c'},
  execution_authority: {source_ref: 'message-execution', kind: 'bounded-outcome', approved_revision: null, outcome_boundary_ref: 'message-outcome'},
  desired_dependencies: [{task_ref: 'E02', depends_on_ref: 'E01', rationale: 'needs artifact'}],
  review: {revision: 1, verdict: 'PASS', reviewer_ref: 'reviewer-a', evidence_ref: 'evidence-a'},
  supervisor: {owner_thread_id: null, epoch: 1},
  creation_grant: {source_ref: 'message-a', project_id: 'project-a', directory_name: null, environments: ['local', 'worktree'], roles: ['executor', 'reviewer', 'supervisor']},
  protected_gates: [{gate_key: 'merge-a', task_ref: 'H01', kind: 'merge', state: 'pending'}],
  resume: {last_event_id: null, pending_operation_keys: []}
};
assert(validatePlan(plan));
assert(validatePlan(JSON.parse(JSON.stringify(plan))));
assert(validatePlan({...plan, creation_grant: {...plan.creation_grant, project_id: null, directory_name: 'projectless-output', environments: [null]}}));
assert.throws(() => validatePlan({...plan, approved_revision: 2}));
const reviewBeforePlan = {...plan, delivery_mode: 'review-before-delivery', execution_authority: {source_ref: 'message-review', kind: 'revision-approval', approved_revision: 1, outcome_boundary_ref: null}};
assert(validatePlan(reviewBeforePlan));
assert.throws(() => validatePlan({...plan, delivery_mode: 'review-before-delivery'}));
assert.throws(() => validatePlan({...reviewBeforePlan, delivery_mode: 'autonomous-delivery'}));
assert.throws(() => validatePlan({...plan, status: 'revoked'}));
assert.throws(() => validatePlan({...plan, task_ids: {E01: 'task-a', E02: 'task-a', H01: 'task-c'}}));
assert.throws(() => validatePlan({...plan, task_ids: {E01: '', E02: 'task-b', H01: 'task-c'}}));
assert.throws(() => validatePlan({...plan, task_ids: {...plan.task_ids, H02: 'task-d'}, protected_gates: [...plan.protected_gates, {gate_key: 'merge-a', task_ref: 'H02', kind: 'publication', state: 'pending'}]}));
assert.throws(() => validatePlan({...plan, protected_gates: [...plan.protected_gates, {gate_key: 'publish-a', task_ref: 'H01', kind: 'publication', state: 'pending'}]}));
assert.throws(() => validatePlan({...plan, protected_gates: [{gate_key: 'merge-agent', task_ref: 'E01', kind: 'merge', state: 'pending'}]}));
assert.throws(() => validatePlan({...plan, protected_gates: [{gate_key: 'merge-a', task_ref: 'H01', kind: 'merge'}]}));
assert.throws(() => validatePlan({...plan, creation_grant: {roles: ['executor']}}));
assert.throws(() => validatePlan({...plan, creation_grant: {...plan.creation_grant, project_id: null, directory_name: null, environments: [null]}}));
assert.throws(() => validatePlan({...plan, creation_grant: {...plan.creation_grant, environments: [null]}}));
assert.throws(() => validatePlan({...plan, review: {revision: 1, verdict: 'PASS'}}));
assert.throws(() => validatePlan({...plan, resume: {last_event_id: null}}));

function changeNeedsRevision(changes) {
  return changes.some(change => materialFields.has(change));
}
assert(changeNeedsRevision(['dependencies']));
assert(changeNeedsRevision(['authority']));
assert(!changeNeedsRevision(['displayName', 'descriptionFormatting', 'responseShape', 'links', 'status', 'receipt']));

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

function creationDecision(intentExists, observed, boundedReconciliationComplete = false) {
  const exact = observed.filter(item => item === 'exact');
  if (observed.length === 1 && exact.length === 1) return 'ADOPT';
  if (observed.length > 0) return 'PAUSE';
  if (!intentExists) return 'WRITE_INTENT_AND_CREATE_ONCE';
  return boundedReconciliationComplete ? 'PAUSE_CREATION_DISPATCH_AMBIGUOUS' : 'PENDING';
}
assert.strictEqual(creationDecision(false, []), 'WRITE_INTENT_AND_CREATE_ONCE');
assert.strictEqual(creationDecision(false, ['exact']), 'ADOPT');
assert.strictEqual(creationDecision(false, ['wrong-project']), 'PAUSE');
assert.strictEqual(creationDecision(true, []), 'PENDING');
assert.strictEqual(creationDecision(true, [], true), 'PAUSE_CREATION_DISPATCH_AMBIGUOUS');
assert.strictEqual(creationDecision(true, ['exact']), 'ADOPT');
assert.strictEqual(creationDecision(true, ['exact', 'exact']), 'PAUSE');
assert.strictEqual(creationDecision(true, ['wrong-project']), 'PAUSE');

function bootstrapDecision(intentExists, observed, boundedReconciliationComplete = false) {
  const exact = observed.filter(item => item === 'exact-destination');
  if (observed.length === 1 && exact.length === 1) return 'ADOPT';
  if (observed.length > 0) return 'PAUSE';
  if (!intentExists) return 'WRITE_BOOTSTRAP_INTENT_AND_CREATE_ONCE';
  return boundedReconciliationComplete ? 'PAUSE_BOOTSTRAP_DISPATCH_AMBIGUOUS' : 'PENDING';
}
assert.strictEqual(bootstrapDecision(false, []), 'WRITE_BOOTSTRAP_INTENT_AND_CREATE_ONCE');
assert.strictEqual(bootstrapDecision(true, []), 'PENDING');
assert.strictEqual(bootstrapDecision(true, [], true), 'PAUSE_BOOTSTRAP_DISPATCH_AMBIGUOUS');
assert.strictEqual(bootstrapDecision(true, ['exact-destination']), 'ADOPT');
assert.strictEqual(bootstrapDecision(true, ['wrong-project']), 'PAUSE');

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

function grantCovers(grant, actor) {
  const identity = grant.project_id === null ? actor.project_id === null && grant.directory_name === actor.directory_name : grant.project_id === actor.project_id;
  return identity && grant.environments.includes(actor.environment) && grant.roles.includes(actor.role);
}
assert(grantCovers(plan.creation_grant, {project_id: 'project-a', directory_name: null, environment: 'local', role: 'executor'}));
assert(!grantCovers(plan.creation_grant, {project_id: 'project-b', directory_name: null, environment: 'local', role: 'executor'}));
assert(!grantCovers(plan.creation_grant, {project_id: 'project-a', directory_name: null, environment: 'local', role: 'planner'}));

function beginReplan(previous) {
  return {...previous, status: 'replanning', proposed_revision: previous.approved_revision + 1, proposed_review: null, acceptedPasses: []};
}
const replanned = beginReplan({...plan, acceptedPasses: ['pass-a']});
assert.strictEqual(replanned.approved_revision, 1);
assert.strictEqual(replanned.proposed_revision, 2);
assert.deepStrictEqual(replanned.acceptedPasses, []);
assert.strictEqual(replanned.proposed_review, null);

console.log('PASS: Octoplan 11 minimal-state fixtures');
NODE

printf 'PASS: Octoplan Codex 11.0.0 contract\n'
