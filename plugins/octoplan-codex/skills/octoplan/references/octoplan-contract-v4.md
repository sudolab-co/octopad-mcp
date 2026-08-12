# Octoplan v4 compatibility

Octoplan 14 reads and executes only `octoplan-plan-v4`. Preserve v1-v3, 10.x, or unknown state as history, fence or reconcile its native actors, then materially replan from the confirmed mandate under [state-and-recovery.md](state-and-recovery.md).

Do not translate old fingerprints, PASS records, authority, readback assertions, creation intents, actor bindings, supervisor ownership, or Goal state into v4. Useful source artifacts may be adopted only through the new generation's explicit manifest, artifact disposition, and fresh review.

Within v4, adopt a compatible installed update only at a safe boundary after fully reading it and recording the transition. A higher schema or breaking major requires material replan; an old role packet never pins an actor forever.

Version 14.0 is breaking: every earlier plan lacks mandatory task generations, execution manifests, actor-binding readbacks, typed review evidence, observed-route admission, and stack-freshness receipts. Fence writers, preserve recoverable artifacts as evidence only, and create a fresh v4 plan; do not migrate an unfinished Goal or infer a compatible generation.

Installing v14 does not change a running legacy task. Enumerate live supervisors/Goals, persist a source-bound migration notice, fence affected execution, and replan under v4; never assume installation propagated the correction.
