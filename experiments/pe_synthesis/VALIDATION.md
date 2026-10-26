# Publication checks

These checks validate the relocated source package and preparation flow. They
do not constitute a new Catapult extraction, RTL simulation, or DC mapping run.

- **Native SystemC: PASS.** Compiled the packaged PE/testbench using Catapult's
  GCC 13.4.0, SystemC and Connections headers, plus the arithmetic snapshot
  already on this branch. Used the full K4/W8/4,096-point-bank geometry, depth-8
  pending FIFO, and 13-cycle native PADD model. All 21 outputs matched the
  independently generated affine goldens exactly, including 9 serial reductions.
- **HLS preparation: PASS.** Generated fresh local include/RTL paths, parameters,
  fixture CSVs, Tcl configuration and source hashes without importing the current
  Tessera Python framework or referring to the historical MSM workspace.
- **DC preparation: PASS.** Used a scratch copy of the previously validated PE
  RTL. The port checker found all three external bucket interfaces, zero internal
  generic SRAM instances and one PADD reference. The dependency walker retained
  the FIFO helper modules inside generate blocks. It prepared a four-core,
  protected-child, link/check-only DC run with the pinned original PADD checkpoint.
  The prepared DC command was not executed.
- **Source identity: PASS.** Copied PE and scheduler headers, testbench, arithmetic
  RTL and declared original sources match the hashes in `SOURCE_MANIFEST.json`.
  Relocation/configuration adaptations are marked separately.

The historical OSCI/SCVerify acceptance receipt and original DC QoR are under
`reference/`. The original PE's mapped PADD was protected; its negative setup
slack remains in the reference result. No timing-closure claim is made.
