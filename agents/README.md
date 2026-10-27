# agents

This folder holds all AI files for an agent design search in this Tessera directory. The method comes from `../playbook.md`.

| Path | Contents |
|---|---|
| [audit.md](audit.md) | Log of decisions, one line each, with the date |
| [plans/rcb_padd/](plans/rcb_padd/) | The plan and the learnings of the PADD search |
| [plans/msm_pe/](plans/msm_pe/) | The plan of the MSM PE search |
| [plans/plan.md](plans/plan.md) | An empty plan template |
| [deadline.txt](deadline.txt) | The deadline as a unix time. The agents read it before each new candidate. |
| [sweeps/](sweeps/) | All sweep files that the agents write. The `*_start.yaml` files are the starting PADD sweeps. |
| [results/](results/) | One CSV for each lane, and the final CSV |
| [notes/](notes/) | One notes file for each lane, and `verify.md` |
| [workflows/rcb_padd/workflow.js](workflows/rcb_padd/workflow.js) | The PADD search workflow |
| [workflows/msm_pe/workflow.js](workflows/msm_pe/workflow.js) | The MSM PE workflow. It starts after the PADD search. |

## Scope

The smallest BLS12-381 RCB PADD (`l2_point_add_rcb`, Alg. 7) at 15 to 17 cycles that meets DC timing at 1 ns. The plan is `plans/rcb_padd/plan.md`. The hints are in `plans/rcb_padd/learnings_alg7_16cyc.md`.

After the PADD search: a BLS12-381 MSM PE (`l3_msm_pe`) with the PADD winner that meets DC timing at 1 ns. The plan is `plans/msm_pe/plan.md`.
