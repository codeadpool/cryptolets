# Standalone BLS12-381 PE synthesis

This is the source and preparation flow for one PE from the completed four-PE
experiment. It keeps the existing scheduler and datapath unchanged and uses the
included, real **12-cycle projective PADD RTL**. The adjacent
[`padd_timing_debug`](../padd_timing_debug/README.md) bundle describes a separate
16-cycle PADD timing experiment; that candidate is not substituted into this PE.

The PE retains four-PE geometry: eight resident window contexts, W8, 4,096-point
input-bank capacity, 16-bit point addresses, per-bucket address FIFO depth 4,
and pending-work FIFO depth 8. `MSM_NUM_PES=4` preserves these types and context
counts; the synthesized top is a single `msm_mpe_pe`, not the full system.

## Source and memory boundary

Start with [msm_mpe_pe.h](msm/include/msm_mpe_pe.h) and
[msm_mpe_sched.h](msm/include/msm_mpe_sched.h). Seven local headers cover the PE
and its channel types. Arithmetic C++ headers and the frozen Catapult utilities
are reused from `../padd_timing_debug/frozen_sources/`, which is already tracked
on this branch. No historical `/home/ajd9396/hls_sandbox` files are required for
Catapult synthesis.

The top has one PADD, external scalar/point request-response channels, and
external bucket-memory pins. Point responses carry X/Y; the PE constructs
projective Z. Each bucket coordinate has a synchronous 1R1W interface for
2,080 words x 381 bits: eight contexts of 260 slots, including scratch slots.
The total excluded bucket SRAM is 2,377,440 bits. Reads take one cycle, and a
same-address simultaneous read/write returns the old data. Address queues,
active-window busy bits, pending work, and control remain in PE logic.

There is no input SRAM, full-system crossbar, shared normalization unit, or extra
combination PADD inside this synthesis boundary. The normalization C++ helper is
included because the existing headers and testbench reference it; it does not
add a normalizer instance to the PE top.

## Prepare and run Catapult

Preparation uses Python 3.8+ and the standard library. The build uses the licensed
Catapult/SystemC/Connections installation, Questa tool configuration, and the
Catapult GF12 technology library. Original tools were Catapult 2026.1_1/1274012
and DC Y-2026.03. Library/tool binaries are external dependencies.

From the repository root, choose installation paths for your machine:

```bash
export MGC_HOME=/eda/siemens/Catapult/Mgc_home
export PE_QUESTA_HOME=/eda/siemens/Questasim/questasim
export PE_DC_HOME=/eda/synopsys/syn/Y-2026.03
export PE_GF12_CATAPULT_LIB=/home/ajd9396/gf12_libs/gf12_highperf.lib
export PE_GF12_SEARCH=/ip/arm/gf12/sc7p5mcpp84_base_slvt_c14/r1p0
export PE_HLS_OUT=/tmp/pe_hls_review_01

python3 experiments/pe_synthesis/prepare.py hls \
  --out "$PE_HLS_OUT" \
  --catapult-home "$MGC_HOME" \
  --questa-home "$PE_QUESTA_HOME" \
  --dc-home "$PE_DC_HOME" \
  --gf12-lib "$PE_GF12_CATAPULT_LIB" \
  --gf12-search "$PE_GF12_SEARCH"

cd "$PE_HLS_OUT"
"$MGC_HOME/bin/catapult" -shell -file msm_pe_external.tcl > catapult.log 2>&1
```

`prepare.py` refuses existing output directories, generates local paths and the
21-command test fixture, and prints the tool command. It does not launch tools.
Catapult first checks native/OSCI results against independent affine Python
goldens, then synthesizes the PE and exports its bucket SRAM interfaces.

For only the OSCI check, add `--cpp-only` during preparation. For HLS plus SCVerify
RTL, use a fresh output directory and add `--rtl --dware-dir /path/to/dware`.
That directory must contain the precompiled `DW01_ver`, `DW02_ver`, `DW03_ver`,
and `DWARE_ver` libraries for your Questa/DC installations. Tessera's existing
DesignWare-library builder can supply them; compiled vendor models are not in
this bundle. The default command does not run RTL simulation.

After HLS, check the exported memory and arithmetic boundary:

```bash
python3 /path/to/cryptolets/experiments/pe_synthesis/scripts/report_external_pe.py \
  --build "$PE_HLS_OUT"
```

The checker requires three external 2,080 x 381 interfaces, no internal generic
bucket SRAM instances, and exactly one PADD reference. Reports are under
`reports/`; generated RTL is under `Catapult/msm_mpe_pe.v*/`.

## Optional Design Compiler mapping

This flow loads the **mapped 12-cycle PADD checkpoint**, protects the PADD with
`set_dont_touch true`, disables boundary optimization for it, and maps the PE
logic around it. It does not freeze the PE itself. It does not use the
`relax_arithmetic` procedure from the separate timing-repair experiment.

Install the small parser dependency in your Python environment:

```bash
python3 -m pip install -r experiments/pe_synthesis/requirements-dc.txt
```

Then prepare DC after Catapult has produced the PE RTL:

```bash
export PE_PADD_DDC=/path/to/the/12_cycle_padd/results/mapped.ddc
export PE_GF12_DB=/ip/arm/gf12/sc7p5mcpp84_base_slvt_c14/r1p0/db/sc7p5mcpp84_12lp_base_slvt_c14_tt_nominal_max_0p90v_25c.db
export PE_DC_OUT=/tmp/pe_dc_review_01

python3 experiments/pe_synthesis/prepare.py dc \
  --hls-out "$PE_HLS_OUT" --out "$PE_DC_OUT" \
  --padd-ddc "$PE_PADD_DDC" --library-db "$PE_GF12_DB" \
  --dc-home "$PE_DC_HOME" --cores 4

cd "$PE_DC_OUT"
"$PE_DC_HOME/bin/dc_shell" -f map_stage.tcl > dc.log 2>&1
```

The required checkpoint's original path and SHA-256 are in
[SOURCE_MANIFEST.json](SOURCE_MANIFEST.json). It is external and differs from both
the standalone multiplier DDC and the 16-cycle PADD DDC in the timing-debug
bundle. The preparation step rejects a different checkpoint to avoid silently
changing the validated arithmetic latency. To use another PADD, regenerate and
validate the HLS blackbox contract first.

Only the reachable parent/helper RTL is extracted, including FIFO register
helpers inside generate blocks. The arithmetic implementation is supplied by
the real checkpoint rather than an empty blackbox. `--check-only` prepares a
DC run that stops after elaboration, linking and checks. It still needs the DDC
and library. Default mapping uses four cores, a 1 ns clock, zero input delay,
and output delays of 0.25 ns maximum / 0.125 ns minimum. SRAM timing is represented
only by these port constraints; no SRAM cells are mapped.

Long Catapult/RTL/DC commands should run in a persistent terminal such as tmux.
The preparer itself is short and does not start background jobs or install tools.

## Provenance and validation

[SOURCE_MANIFEST.json](SOURCE_MANIFEST.json) distinguishes unchanged copied
sources from path/configuration adaptations. The packaged PADD RTL and its
latency/area declaration are preserved. Its HLS model is 12 cycles, II=1; the
native PE model uses 13 cycles to include the wrapper allowance.

The [historical receipt](reference/status.json) records passing OSCI and SCVerify
checks for this PE. The fixture covers all eight contexts, accumulation across
tiles, odd counts, backpressure, clearing/reuse, and serial bucket reduction.
The [historical DC QoR](reference/dc_qor.rpt) still has negative setup slack;
the [protection report](reference/protected_after.rpt) confirms the PADD was
protected in that completed PE mapping. This package does not claim timing
closure or a new completed synthesis run. See `VALIDATION.md` for checks performed
on the relocated package before publication.
