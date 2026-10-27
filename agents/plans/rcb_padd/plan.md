# Plan: small BLS12-381 RCB PADD near 16 cycles that meets timing

The goal is a set of sweep knobs for `l2_point_add_rcb` (Alg. 7) on BLS12-381 that meets DC timing at 1 ns, at 15 to 17 cycles, with the smallest DC area. The method comes from `playbook.md`. The hints are in `learnings_alg7_16cyc.md`, in this folder.

## Goal

| # | Kernel | Parameters | Goal |
|---|---|---|---|
| 1 | `l2_point_add_rcb` | `bls12_381_base`, `padd_rcb_form: padd_rcb_alg7` | Catapult meets timing. DC slack 0 or more, with no violating path. Latency 15 to 17 cycles. Then minimum DC area. If two designs are within 1% in area, pick the one at 16 cycles. |
| 2 | `l1_mod_mul`, `l1_mod_cmul` | The children of the design 1 winner | Each child, built alone with the same `period`, `io_delay` and directives, meets DC timing. |

A design passes only if design 1 and its children (design 2) both meet their goals.

## Common settings

- Technology `gf12_highperf`, clock period 1.0 ns, II 1.
- `field: bls12_381_base`, `bitwidth: 381`.
- `mred: mred_mont`, `q_type: fixed_q`, `rc_type: fixed_rc`, `coef_type: fixed_coef`. A PADD inside the PE always has `coef_type: fixed_coef`. With the same value here, the PE reuses the PADD build of this search.
- Blackbox `l1_mod_mul` and `l1_mod_cmul` in the PADD, and `l0_int_cmul` in both children.
- `num_test_samples: 100`.
- Thread budget: 40 threads in total, 20 for each lane. Run Catapult with `-t 20 -p 1`. Run DC with `-t 20 -p 5`, so that each DC run gets 5 threads.
- Deadline: 24 hours after the workflow starts. The workflow writes it as a unix time in `agents/deadline.txt`. One PADD DC run took 0.6 to 2.1 hours.
- Python: `.venv/bin/python -m tessera`, from the root of this Tessera directory.

## Inputs

- `agents/plans/rcb_padd/learnings_alg7_16cyc.md`: the settings that met DC near 16 cycles, and the settings that failed.
- `sweeps/l2_point_add_rcb.yaml`: the main sweep. Do not edit it. Copy it to `agents/sweeps/` and change the copy.
- `tessera/tcl/catapult/directives.yaml`: the Catapult directives that a sweep can set.
- `python -m tessera analyze l2_point_add_rcb`: cycles and area for each design.

## Phases

### Phase 0: Setup

1. The workflow writes the deadline (start + 24 hours) to `agents/deadline.txt`.
2. The starting sweeps are `agents/sweeps/nor381_start.yaml` and `agents/sweeps/kar48_start.yaml`. Each has one design.
3. Run each sweep to `--to rtl`. This makes sure that each sweep builds.

### Phase 1: Search lanes (in parallel)

Each lane starts from a different setting in the learnings.

| Lane | Start | Why |
|---|---|---|
| `nor381` | `mul_nor` width 381, dpr 0.85, io 0.7, child `io_delay` 0.78, child CO 0 | Catapult already scheduled this setting at 16 cycles. DC was not run. |
| `kar48` | `mul_kar` width 48, dpr 0.9, io 0.7, child `io_delay` 0.83, child CO 0 | This setting met DC at 15 cycles with the smallest area of the designs near 16 cycles. Try to make it smaller. |

Each lane does these steps:

1. Screen candidates with Catapult only (`--to rtl`). Keep only the candidates at 15 to 17 cycles.
2. Send a candidate to DC (`--to syn`) only if its Catapult area is less than the Catapult area of the best passing design.
3. Change one knob per candidate.
4. If DC fails by 0.01 ns or less, run DC again with `syn_passes: 2` before you change the design.
5. If DC fails on a path that crosses a child port, change the port budget first (`dep_io_ratio`, child `io_delay`).
6. Record each candidate in `agents/results/<lane>.csv`: knobs, cycles, Catapult area, DC area, WNS, number of violating paths, pass or fail.
7. Stop after 3 rounds with no area gain of more than 1%, or at the deadline.

### Phase 2: Child check (dependent lane)

1. Start this phase only after the verifier passes the winner of a lane.
2. Build the `l1_mod_mul` and `l1_mod_cmul` of the winner alone to `--to syn`. Use the same `period`, `io_delay` and directives, so that the build has the same hash.
3. If a child fails DC, give the result to the verifier. The lane then tries its next best design.

### Phase 3: Final runs

1. From all lanes, pick the passing design with the smallest DC area. If two designs are within 1% in area, pick the one at 16 cycles.
2. Run it through `gls` and `pwr` one time only.
3. Write `agents/results/final.csv` and `agents/notes/summary.md`. The summary gives the sweep knobs of the winner.
4. Add one line to `agents/audit.md`.

### What the verifier checks

The verifier reads the Catapult and DC reports itself. It does not trust the lane.

1. The latency in the Catapult report is 15 to 17 cycles and agrees with the CSV.
2. Catapult meets timing.
3. DC slack is 0 or more, and the DC QoR report has no violating path. "slack 0.00 VIOLATED" is a failure.
4. The area in the CSV agrees with the DC report.
5. The children of the winner meet DC timing when built alone.
6. For the final design, GLS passes all samples and the power report exists.
7. The lane obeyed the guardrails.

If a check fails, the verifier writes the problem to `agents/notes/verify.md`. A fix agent corrects it, and the verifier checks again. The maximum is 3 rounds. After that, the workflow continues with the best result and records the problem.

## Agents

| Agent | Phase | Model | Effort | Job |
|---|---|---|---|---|
| setup | 0 | Sonnet | low | Write the starting sweeps. Do the smoke runs. |
| lane `nor381` | 1 | Opus | medium | Search from the nor 381 start |
| lane `kar48` | 1 | Opus | medium | Search from the kar48 start |
| child check | 2 | Sonnet | medium | Build the children of a winner alone and run DC on them |
| verifier | end of 1, 2 and 3 | Opus | high | Check each winner against its reports |
| final | 3 | Sonnet | medium | Do the final `gls` and `pwr` runs. Write the summary. |

## Guardrails

1. Edit only files in `agents/`. Never edit `tessera/`, `kernels/`, `reference/`, `config.yaml`, or the sweeps in `sweeps/`.
2. Never edit the test or verification files.
3. Never read or write anything outside this Tessera directory.
4. Do not use git commands.
5. Change only sweep knobs: sweep keys, `variants`, `deps`, `catapult` directives, and `flags`.
6. BLS12-381 only. Alg. 7 only. Montgomery reduction only. Fixed q, rc and coef only.
7. Use plain modmul and cmul children. Fused or lazy kernels are out of scope.
8. Keep `l1_mod_mul` and `l1_mod_cmul` blackboxed in the PADD.
9. Do not use `CLUSTER` directives in any form, on any kernel.
10. Do not run past `syn` in Phases 0 to 2. Only the final design goes to `gls` and `pwr`, because GLS writes very large VCD files.
11. Obey the thread budget. Divide it between the lanes.
12. Do not run a design that already has DC results again with `--to rtl`. Tessera then deletes its DC reports.
13. Do not delete builds that another lane uses.
14. Read the deadline from `agents/deadline.txt` before each new candidate. After the deadline, start no new candidates. Let the runs in progress finish.
