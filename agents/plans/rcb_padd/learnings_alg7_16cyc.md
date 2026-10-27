# Learnings: Tessera Alg. 7 PADDs near 16 cycles that meet timing

These learnings are for unmodified Alg. 7 PADDs (`padd_rcb_form: padd_rcb_alg7`) at gf12, a 1 ns clock, and II 1. The modmul and cmul children are plain kernels, with no lazy reduction and no fused operations.

The goal is a BLS12-381 PADD at about 16 cycles that meets timing. The BLS12-381 section is the main guide. The BN254 section shows the same pattern on a smaller field.

All numbers here are observations. They are not targets or limits.

## Guardrails

1. Do not use `CLUSTER addtree`, with any `OPT_CONST_MULTS` value, on any kernel. Do not use the directive in any form or spelling.
2. Keep `l1_mod_mul` and `l1_mod_cmul` blackboxed in the PADD (`flags.blackbox`).
3. Do not change the algorithm. Use plain modmul and cmul children. Fused or lazy kernels are out of scope.
4. A design passes only if Catapult meets timing and DC meets timing.
   - A DC report with "slack 0.00 VIOLATED (increase significant digits)" is a failure.
   - Any violating path in the DC QoR report is a failure, even when WNS rounds to 0.00.

## How the latency is set

PADD latency is about (modmul levels on the critical path) × (modmul latency) + (glue cycles). Near 16 cycles, DC timing is the usual problem, not latency. Most DC failures were on cross-port paths: child output register → PADD glue (add, sub) → first register of the next child.

Abbreviations: dpr = `dep_period_ratio`, io = `dep_io_ratio`, CO = `CLOCK_OVERHEAD`.

## 1. BLS12-381

### Settings that met DC

| PADD cycles | Multiplier | mul / cmul cycles | Settings | Area (µm²) |
|---:|---|---|---|---:|
| 13 | `mul_nor`, width 381 | 4 / 4 | dpr 0.9, io 0.7, child `io_delay` 0.83, child CO 0 | 1,869,039 |
| 15 | `mul_kar`, width 48 | 5 / 4 | dpr 0.9, io 0.7, child `io_delay` 0.83, child CO 0 | 1,664,800 |
| 17 | `mul_nor`, width 381 | 5 / 5 | dpr 0.85, io 0.6 | 1,893,019 |
| 18 | `mul_nor`, width 381 | 5 / 5 | dpr 1.0, io 0.5 | 1,816,488 |
| 18 | `mul_kar`, width 48, small-constant cmul | 6 / 1 | dpr 1.0, io 0.19, `RESET_CLEARS_ALL_REGS: 'no'`, `syn_passes` 2 | 1,294,035 |
| 20 | `mul_kar`, width 96 | 5 / 5 | dpr 0.95, io 0.3 | 1,604,306 |

"Child `io_delay`" means `deps.l1_mod_mul.io_delay` and `deps.l1_mod_cmul.io_delay`. "Child CO 0" means `catapult.l1_mod_mul.CLOCK_OVERHEAD: 0` and `catapult.l1_mod_cmul.CLOCK_OVERHEAD: 0`.

Example sweep (the 15-cycle row):

```yaml
sweep:
  padd_rcb_form: [padd_rcb_alg7]
  dep_period_ratio: [0.9]
  dep_io_ratio: [0.7]
  mul_type: [mul_kar]
  base_mul_width: {381: [48]}
  kar_base_mul_width: {381: [48]}
variants:
  - {deps: {l1_mod_mul: {io_delay: [0.83]}, l1_mod_cmul: {io_delay: [0.83]}},
     catapult: {l1_mod_mul: {CLOCK_OVERHEAD: [0]}, l1_mod_cmul: {CLOCK_OVERHEAD: [0]}}}
flags:
  syn_passes: 1
  blackbox:
    l2_point_add_rcb: [l1_mod_mul, l1_mod_cmul]
    l1_mod_mul: [l0_int_cmul]
    l1_mod_cmul: [l0_int_cmul]
```

### What made these designs meet timing

1. **Use a child period below the clock.** dpr 0.85 to 0.9 met DC. At dpr 1.0 with the Montgomery cmul, the children failed DC by about 0.10 ns. The failing path was the q-prime constant multiply in `l0_int_cmul`.
2. **Give the child ports a large budget.** io 0.7 with a child `io_delay` of 0.83 met DC at 13 and 15 cycles.
3. **Set child CO 0.** All the designs at 13 and 15 cycles used it.
4. **For a smaller PADD, use kar48.** With the same settings as nor 381, kar48 added 2 cycles and cut area by 11%.
5. **With a small-constant cmul and dpr 1.0, the io window is narrow.** io 0.19 met DC. io 0.18 failed (132 violating paths). io 0.15 failed (5,980 paths).

### What failed

- kar48 at dpr 0.8 and io 0.3: the child failed DC on `input_group` by 0.03 ns.
- An `l0_int_cmul` period of 0.64 ns (dpr 0.8 applied twice): Catapult failed with CRAAS-6.
- kar48 at dpr 1.0 and io 0.3 (22 cycles): 1 violating path, PADD modsub register → cmul reduce register.
- `MAX_LATENCY` below the schedule bound: Catapult gives CRAAS-13 and keeps the old latency.

### A 16-cycle setting that has no DC result

nor 381, dpr 0.85, io 0.7, child `io_delay` 0.78, and child CO 0 scheduled at 16 cycles in Catapult. DC was not run on it, so it is not known if it meets timing.

## 2. BN254

### Settings that met DC

| PADD cycles | Multiplier | mul / cmul cycles | Settings | Area (µm²) |
|---:|---|---|---|---:|
| 13 | `mul_kar`, width 64 | 4 / 3 | 16-cycle row + child output share 0.85 + PADD CO 0 | 765,759 |
| 14 | `mul_nor`, width 254 | 3 / 3 | dpr 0.85, io 0.225, `RESET_CLEARS_ALL_REGS: 'no'` | 839,105 |
| 15 | `mul_kar`, width 64 | 4 / 3 | 16-cycle row + child output share 0.85 | 766,658 |
| 16 | `mul_kar`, width 64 | 4 / 3 | dpr 0.9, io 0.25, `RESET_CLEARS_ALL_REGS: 'no'`, `syn_passes` 2 | 766,978 |
| 17 | `mul_kar`, width 64 | 4 / 3 | dpr 0.9, io 0.225, `RESET_CLEARS_ALL_REGS: 'no'` | 772,188 |

"Child output share" means that the child output gets 85% of the port budget and the input gets the remainder. If your Tessera has no knob for this, use a large child `io_delay` instead.

At exactly 16 cycles, 15 different settings met DC. 14 of them were kar64 at dpr 0.85 to 0.95 and io 0.25 to 0.3.

### What made these designs meet timing

1. **Give the child ports a timing budget.** With no `dep_io_ratio`, every PADD failed DC on cross-port paths (WNS -0.22 to -0.6 ns).
2. **Use a child period below the clock.** dpr 1.0 failed DC by 0.58 to 0.6 ns. dpr 0.85 to 0.9 met DC.
3. **Keep io inside its window.** io 0.25 to 0.3 met DC at 16 cycles. io 0.225 or less added a cycle. io 0.4 gave 20 cycles.
4. **Use `syn_passes` 2 for near-misses.** Several designs that failed pass 1 by a few hundredths of a ns met DC at pass 2.

### What failed

- nor at dpr 0.8 and io 0.2, or dpr 0.9 and io 0.3, with `syn_passes` 1: DC failed by less than 0.01 ns on the glue → nor child first-stage path. The second setting met DC with `syn_passes` 2.
- nor at dpr 0.875 and io 0.25: 15 violating paths.
- nor children with a small-constant cmul: DC failed on child output → glue modsub. `syn_passes` 3 and a child input-delay change did not fix it.

## How to search

1. Start from the nearest setting that met DC. Change one knob per candidate.
2. Screen with Catapult only (`--to rtl`) before you run DC. One PADD DC took 0.6 to 2.1 hours. The time changes with the design, the threads, and the machine.
3. If DC fails by 0.01 ns or less, run DC again with `syn_passes` 2 before you change the design.
4. If DC fails on a path that crosses a child port, change the port budget first (`dep_io_ratio`, child `io_delay`).
