# Octoplan v3 compatibility

Octoplan 13 reads and executes only `octoplan-plan-v3`. Preserve v1, v2, 10.x, or unknown state as history, fence or reconcile its native actors, then materially replan from the confirmed mandate under [state-and-recovery.md](state-and-recovery.md).

Do not translate old fingerprints, PASS records, authority, readback assertions, creation intents, supervisor ownership, or Goal state into v3. Useful source artifacts may be adopted only through the new plan's explicit artifact map and review.

Within v3, a newly installed compatible skill version is adopted at the next safe actor boundary after the actor fully reads it, records the version change, and confirms that the live plan remains compatible. A higher required schema or breaking major requires a material replan; an old role packet never pins a compatible actor forever.

Installing v13 does not retroactively change an already-running v2 task. A controlled upgrade must enumerate known live v2 supervisors/Goals, persist a source-bound migration notice, fence affected old execution, and replan under v3; never assume installation alone propagated the correction.
