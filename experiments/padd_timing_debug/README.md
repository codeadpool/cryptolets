# BLS12-381 PADD timing diagnosis

This bundle records the completed four-core, 16-cycle PADD synthesis that missed
the 1 ns setup target. It preserves the actual scripts and evidence, including
`dont_touch false`. It does not implement the requested future change to protect
the mapped arithmetic, and collecting this bundle did not run synthesis.

The review branch is based on Tessera commit
`ca32d9058b970f57645d6309af9565d7580d44b2`. That is the branch base, **not** a claim
that the historical experiment used that version of Tessera. The experiment used
its own frozen source copy, selected files from which are under `frozen_sources/`.

The companion [standalone PE synthesis package](../pe_synthesis/README.md)
contains the minimal PE sources, included 12-cycle PADD RTL, and portable
Catapult/DC preparation commands. That PE preserves its validated arithmetic
baseline; it does not integrate this 16-cycle PADD candidate.

## Start here

| Artifact | What to inspect |
|---|---|
| [PADD DC script](padd_dc/sources/repair.tcl) | `relax_arithmetic`, child checkpoint linking, hierarchy preservation, and both compile passes |
| [PADD inputs](padd_dc/inputs.tcl) / [input identities](padd_dc/inputs.json) | Exact original paths and hashes |
| [Actual input constraints](padd_dc/original_input.sdc) | The SDC loaded by `repair.tcl`, copied from the original PADD run |
| [Final setup timing](padd_dc/reports/pass_2/timing_max.rpt) / [QoR](padd_dc/reports/pass_2/qor.rpt) | Worst 20 setup paths, area, and violations |
| [DC log](padd_dc/dc.log) / [run status](padd_dc/status.json) | Executed commands, tool messages, elapsed time, and completion state |
| [Standalone multiplier timing](multiplier_dc/reports/timing_max.rpt) / [comparison](multiplier_dc/COMPARISON.md) | Starting multiplier's standalone result |
| [Multiplier input constraints](multiplier_dc/original_input.sdc) / [incremental script](multiplier_dc/sources/incremental.tcl) | Conditions under which that multiplier was optimized |
| [PADD RTL](padd_hls/parent_for_dc.v) / [registered multiplier wrapper](padd_hls/wrapper_for_dc.v) | Actual parent RTL and the added input registers |
| [HLS blackbox declaration](padd_hls/blackbox/impl/l1_mod_mul_impl.h) | Child latency, input/output timing assumptions, and stale HLS area model |
| [PADD Catapult script](padd_hls/run.tcl) / [multiplier Catapult script](multiplier_hls/kernel.tcl) | Directives used for HLS |
| [Integer multiplier](frozen_sources/kernels/l0/l0_int_mul/impl/l0_int_mul_impl.h) / [Montgomery reducer](frozen_sources/kernels/l1/l1_mod_mul/impl/l1_mont_reduce.h) | Variable multiplication decomposition and the two constant multiplications |

## Measurements

All DC figures below use the GF12 SLVT library at TT, 0.90 V, 25 C, and a 1 ns
clock. They are synthesis estimates, without placement or routed parasitics.
The SDC files contain the complete constraints; no clock uncertainty, input
driving cell, or output load was added by the repair script. PADD input delay is
0 ns and output delay is 0.25 ns maximum / 0.125 ns minimum.

| Result | Latency | II | Mapped cell area (um^2) | Worst setup slack (ns) |
|---|---:|---:|---:|---:|
| Standalone multiplier after incremental compile | 5 | 1 | 157875.825721 | +0.000032 |
| PADD, four-core full compile | 16 | 1 | 1681480.269416 | -0.257143 |
| PADD, four-core incremental pass | 16 | 1 | 1687103.942319 | -0.152882 |

The multiplier has effectively no standalone setup margin. Its passing result
does not establish timing closure when integrated behind real launching registers
or reoptimized in the parent. The PADD final QoR reports 9,657 violating setup
paths and 9 hold violations. `timing_min.rpt` and `constraints.rpt` are included;
neither mapping completion nor a `SUCCESS` marker means timing passed.

Catapult version: **2026.1_1/1274012**. DC version: **Y-2026.03**. The four-core
driver completed in 33,499.08 seconds (9 h 18 m 19 s). The one-core counterpart
reported the same final area and setup slack; that duplicate run is omitted.

## Critical path and protection settings

The first final timing path is:

```text
modmul_inst_rtl_cmp_11/y_q_reg[235]
  -> 48 x 47-bit variable multiplication
  -> partial-product recombination adders
  -> l0_int_mul_sb_64_96_96_constexpr_if_else_acc_7_itm_1_144_48_reg[64]
```

Its arrival time is 1.142524 ns; required time is 0.989641 ns; reported slack is
-0.152882 ns. All 20 reported worst setup paths terminate in multiplier
partial-product registers. These reports do not establish that every cmul path
meets timing.

The HLS PADD uses twelve instances of a packaged sequential modular multiplier.
For DC these are linked to **real mapped logic**, not empty blackboxes. The
starting child checkpoint was loaded, but `relax_arithmetic` then cleared
`dont_touch` on designs and hierarchical instances and enabled boundary
optimization. `set_ungroup false` and `-no_autoungroup` preserve hierarchy; they
do not freeze multiplier internals. No retiming was enabled. Thus the final
integrated result is not a measurement of twelve untouched child checkpoints.

The current user requirement is to protect the mapped child modules with
`dont_touch true` in a future experiment. That change has **not** been applied
to any evidence in this bundle. A protected-child rerun and review of the
child interface timing remain open diagnostic steps; closure is not assumed.

## Constant multipliers and the frozen HLS source

The reducer computes fixed-constant products using `q_prime` and `q`. The
generated multiplier and PADD scripts use `OPT_CONST_MULTS simple_one_adder`.
The frozen `l1_mod_mul` kernel has no separately packaged cmul dependency:
those cmuls are inlined into the scheduled multiplier.

The frozen [kernel configuration model](frozen_sources/tessera/models/kernel.py)
and [Catapult driver](frozen_sources/tessera/steps/catapult/__init__.py) do not
implement `force_combinational`. Current Tessera at this branch's base does,
and its `l0_int_cmul/kernel.yaml` enables it. The current setting was **not**
retroactively used in these results. The saved `CLUSTER_TYPE combinational`
directive is not proof of a separately forced combinational cmul kernel.

The registered wrapper adds one cycle to a five-cycle child; its HLS blackbox
declares latency 6, input delay 0.03 ns, output delay 0.75 ns, and minimum clock
period 1 ns. PADD was rescheduled to 16 cycles, II=1, with 20% clock overhead,
speculation enabled, and registered outputs. Those blackbox delays are scheduling
assumptions, not proof of mapped timing closure. The HLS blackbox area retains the
original child estimate without the new wrapper registers; use the mapped DC
area above for the integrated result.

## Provenance and rerunning

[MANIFEST.json](MANIFEST.json) maps each copied file to its original source,
size, and SHA-256. All 95 copied files are byte-for-byte unchanged. Check them
from this directory with:

```sh
sha256sum -c SHA256SUMS
```

This is a review bundle, not a portable build tree. Tcl, C++ includes, and the
copied generation driver retain original absolute paths and some dependencies
outside this bundle. Do not run the historical driver directly in the evidence
directory: its output paths refer to the original experiment.

To repeat **DC mapping** in a fresh scratch directory, supply:

1. `padd_dc/sources/repair.tcl`, with `inputs.tcl` adapted in that scratch
   directory to local paths. Keep the preserved evidence unchanged.
2. `padd_hls/parent_for_dc.v`, `padd_hls/wrapper_for_dc.v`, and
   `padd_dc/original_input.sdc` as the parent RTL, child wrapper, and input SDC.
3. The original standalone multiplier checkpoint, listed with its hash in
   `MANIFEST.json` (20.6 MiB), and access to the specified GF12 library and DC.

The script's `mode` is `pipelined`. The historical `baseline_ddc` entry is unused
in this mode; the **multiplier DDC is required**. Once scratch inputs are prepared,
the original DC invocation is `dc_shell -f sources/repair.tcl`. Do not call this a
protected-child experiment unless its protection policy is explicitly changed
and separately recorded.

The final PADD DDC (245.1 MiB) is an optional external artifact for additional
timing queries without recompilation. Its path and hash are in the manifest.
The older standalone multiplier DDC is only needed to repeat that incremental
child compile. Checkpoints, foundry libraries, tool installations, simulation
waveforms, and caches are not committed. Full HLS regeneration requires the
remaining historical testbench/tool dependencies beyond this selected snapshot.
