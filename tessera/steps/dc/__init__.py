import logging
import subprocess
import time

import yaml

from tessera.steps.base import Step
from tessera.steps.catapult.package import update_manifest
from tessera.steps.dc.codegen import gen_dc_tcl
from tessera.steps.dc.select import select_designs
from tessera.parser.metrics.dc import parse_dc_qor, parse_dc_power
from tessera.helpers.archive import archive_run
from tessera.helpers.others import log_elapsed
from tessera.const import BUILD_DIR


def met_all(manifest, build_dir=BUILD_DIR):
    """
    Whether this design and every child below it met DC. A parent links its
    children untouched, so its own report cannot show a miss inside one.
    None when a child has no verdict yet, so unknown never reads as met.
    """
    verdicts = [manifest.get("met_dc")]
    for child in manifest.get("children", []):
        path = build_dir / child / "package" / "manifest.yaml"
        verdicts.append(yaml.safe_load(path.read_text()).get("met_all") if path.exists() else None)
    if False in verdicts:
        return False
    return None if None in verdicts else True


class DesignCompiler(Step):
    """
    Logic synthesis using Design Compiler. RTL to a Gate netlist.
    """
    name = "syn"
    license = "dc"

    def select(self, designs, kernel, run_inst):
        # Synthesis costs far more than the run that estimated it, so a sweep
        # can ask for only the designs on its frontier
        return select_designs(designs, kernel, run_inst.sweep_flags["syn_sel"])

    def run(self, design, kernel, run_inst):
        design_name = design.build_dir.name
        start_time = time.time()

        # Design Compiler writes its work directories into the current one, so
        # it gets its own. Catapult's is left alone for a syn only run.
        archive_run(design.build_dir, dirs=("dc",))
        dc_dir = design.build_dir / "dc"
        dc_dir.mkdir(parents=True, exist_ok=True)

        module = gen_dc_tcl(design, kernel, run_inst)
        logging.info(f"Running Design Compiler for {design_name}")

        log_path = design.build_dir / "logs" / "dc.tessera.log"
        log_path.parent.mkdir(parents=True, exist_ok=True)
        with log_path.open("w") as log:
            result = subprocess.run(
                ["dc_shell", "-f", str((design.build_dir / "dc.tcl").resolve())],
                cwd=dc_dir,
                stdout=log,
                stderr=subprocess.STDOUT,
            )

        ok = log_elapsed(self.name, design_name, result.returncode, start_time)
        if ok:
            passes = run_inst.sweep_flags["syn_passes"]
            manifest = update_manifest(
                design, **parse_dc_qor(design, passes),
                power_dc=parse_dc_power(design, module, passes)
            )
            update_manifest(design, met_all=met_all(manifest))
        return ok
