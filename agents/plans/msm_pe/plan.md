# Plan: MSM PE that meets DC timing

The goal is a `l3_msm_pe` (BLS12-381) that meets DC timing at 1 ns. The method comes from `playbook.md`. The search changes only sweep knobs of the PE and of its PADD. The PADD latency can change to meet timing. Latency is not a goal.

## Prerequisites

1. The PADD search (`plans/rcb_padd/plan.md`) has a verified winner. The workflow gets its sweep file as an argument.
2. Done: the PE runs to `--to syn` in Tessera.
3. Do not rename `build/` between the two searches. The PE reuses the PADD builds of the PADD search.

## Goal

| # | Kernel | Parameters | Goal |
|---|---|---|---|
| 1 | `l3_msm_pe` | `bls12_381_base`, PADD Alg. 7 | Catapult meets timing. DC slack 0 or more, with no violating path. Then minimum DC area. |
| 2 | `l2_point_add_rcb`, `l1_mod_mul`, `l1_mod_cmul` | The children inside design 1 | Each child meets DC timing alone, with the `period` and `io_delay` that its parent gives it. |

## How the PE is built

These facts set which knobs can fix which paths.

- **The PADD keeps its own synthesis.** DC reads the mapped PADD and sets `dont_touch` on it. The PE run maps only the PE logic. A path inside the PADD shows in the PE report only if the PADD fails alone, and only a new PADD build can fix it.
- **The PADD gets its timing from the PE sweep.** Its period is `dep_period_ratio` × PE period, or `deps.l2_point_add_rcb.period`. Its port budget is `dep_io_ratio`, or `deps.l2_point_add_rcb.io_delay`. Each level inherits `dep_period_ratio`, so the PADD children get the ratio two times.
- **A new PADD timing gives a new PADD build.** Each new PADD build needs its own DC run (0.6 to 2.1 hours) before the PE can run DC.
- **The bucket memories are not part of the PE.** Catapult exports `br_x`, `br_y` and `br_z` as external 1R1W ports. DC does not map them, and their area is not in the PE area. Their ports get the same constraints as all PE ports: inputs arrive at the clock edge, and outputs must be ready 0.25 ns before the edge. The SRAM access time is out of scope.
- **The PE logic can change only through Catapult directives.** A sweep sets them as `catapult.l3_msm_pe.<DIRECTIVE>`. They come after the defaults in `kernel.yaml`, so they override them. The MSM geometry (window, queue depth) is in the C++, so it cannot change.

## Reuse of the PADD build

The PE reuses a PADD build of the PADD search only if the PADD inside the PE gets the same hash. The recipe in Phase 0 gives the same hash. It was checked with the scheduler of Tessera.

- Without `deps.l2_point_add_rcb.period`, the PADD period is `dep_period_ratio` × the PE period.
- Without `deps.l2_point_add_rcb.io_delay: [0]`, the PE `dep_io_ratio` gives the PADD an `io_delay`, which is part of its hash. The value 0 turns the share off.
- A PADD inside the PE always has `coef_type: fixed_coef`, because the C++ sets it. The PADD search sweeps also set it.

## How to read the PE timing report

- A path with `l2_point_add_rcb_run_inst` in its startpoint and endpoint is inside the PADD.
- A path with `sched_thread` is in the scheduler. A path that ends in `sched_core_br_*_rsc_*` ends at a bucket memory port.
- `reports/dc/pass_1/timing_max.rpt` shows the worst paths of each path group (`clk`, `input_group`, `output_group`).

## Phases

### Phase 0: Baseline

1. Write `agents/sweeps/msm_base.yaml` from the sweep of the PADD winner. Keep every key. Add `l3_msm_pe: [l2_point_add_rcb]` to `flags.blackbox`. Add `l2_point_add_rcb: {period: [<winner period>], io_delay: [0]}` to `deps` in each variant. The section "Reuse of the PADD build" shows why.
2. Run it with `--to gen`. Make sure that the log says that the `l2_point_add_rcb` design is already built. If it does not, the PADD gets a new hash: compare the two `design.yaml` files and correct the sweep.
3. Run it with `--to syn`. Catapult takes about 1 h 45 min for the PE.
4. Record WNS, the number of violating paths, the area, and the 20 worst paths in `agents/notes/msm_base.md`.

### Phase 1: Sort the failing paths

Put each of the worst paths in one group. Count the paths of each group.

| Group | Example | Knobs |
|---|---|---|
| Inside the PADD | A path with both ends in `l2_point_add_rcb_run_inst` | None in the PE run. The PADD fails alone: go back to the PADD search. |
| PE to PADD | PE register → PADD input port, or PADD output port → PE register | `deps.l2_point_add_rcb.io_delay` (a value more than 0 gives the PADD a port budget), `deps.l2_point_add_rcb.period`. Each gives a new PADD build. With `deps.l2_point_add_rcb` set, `dep_period_ratio` and `dep_io_ratio` set only the PADD children, as in the PADD search. |
| PE logic | Scheduler select, queue write, busy bits, FIFOs | `catapult.l3_msm_pe.*` (for example `CLOCK_OVERHEAD`), `flags.syn_passes` |
| PE ports | PE register → `br_x` port, `preq`, `sreq` | `catapult.l3_msm_pe.*`, `flags.syn_passes` |

### Phase 2: Search lanes

1. Run one lane for each group that has failing paths. The lanes run in parallel.
2. The PE-to-PADD lane gives the PADD a port budget. Use the settings in `plans/rcb_padd/learnings_alg7_16cyc.md` for the PADD and its children. If the PADD fails DC alone, change its knobs first. A PADD that fails alone cannot make the PE pass.
3. The PE-logic lane and the PE-ports lane keep the PADD of the baseline. Then they do not need a new PADD build.
4. Change one knob per candidate. If DC fails by 0.01 ns or less, run DC again with `syn_passes: 2` before you change the design.
5. Record each candidate in `agents/results/msm_<lane>.csv`: knobs, PADD hash, PE WNS, violating paths, PE DC area, PADD WNS, pass or fail.
6. Merge: when two lanes each fix their own group, try the two settings together.
7. If no directive fixes the PE logic, stop the lane and write the paths in `agents/notes/msm_<lane>.md`. The person decides the next step.

### Phase 3: Child check and final

1. Build each child of the winner alone with its `period` and `io_delay`, and run DC (playbook lesson 2).
2. The verifier checks the PE and its children against their DC reports.
3. Run `gls` and `pwr` on the PE one time.
4. Write `agents/results/msm_final.csv` and `agents/notes/msm_summary.md`.

## Agents

| Agent | Phase | Model | Effort | Job |
|---|---|---|---|---|
| setup | 0 | Sonnet | low | Write the baseline sweep. Run it to `syn`. |
| sorter | 1 | Opus | medium | Read the timing reports. Sort the paths into groups. |
| lane (one for each group) | 2 | Opus | medium | Search for one group |
| child check | 3 | Sonnet | medium | Build the children alone and run DC |
| verifier | end of 2 and 3 | Opus | high | Check each winner against its reports |
| final | 3 | Sonnet | medium | Do the `gls`/`pwr` run. Write the summary. |

## Guardrails

The guardrails of `plans/rcb_padd/plan.md` apply. In addition:

1. Never change kernel, test, framework or reference code, and never edit `kernel.yaml`.
2. Change only sweep knobs of `l3_msm_pe`, `l2_point_add_rcb` and its children.
3. Keep `l2_point_add_rcb` blackboxed in the PE.
4. Do not optimize for latency. A design passes on timing, then area.
5. A PE DC run can take hours. Do not start a PE DC run until its PADD has passed DC alone.
