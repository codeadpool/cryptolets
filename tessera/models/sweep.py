"""
Pydantic models for sweep files.
"""
import logging
from typing import Literal, Optional, get_args
from pydantic import BaseModel, model_validator

from tessera.const import ARB_FIELD, KERNELS_DIR
from tessera.models.common import (load_and_validate_yaml, load_catapult_directives,
                                   load_curves, is_fpga)
from tessera.models.config import RunConfig

# The settings deps can give one child kernel, in ns
DEP_SETTINGS = {"period", "io_delay"}


def _check_kernel(block, kernel):
    # Kernel.find, without importing the kernel model, which imports this one
    if not any((level / kernel).is_dir() for level in KERNELS_DIR.iterdir()):
        raise ValueError(f"{block}: unknown kernel '{kernel}'")


def _check_directive_value(key, value, spec):
    # YAML reads an unquoted true as a bool, Catapult wants the word
    value = str(value).lower() if isinstance(value, bool) else value
    if "choices" in spec:
        if str(value) not in spec["choices"]:
            raise ValueError(f"{key}: {value} not in {spec['choices']}")
        return
    kind = {"int": int, "float": (int, float)}[spec["type"]]
    if isinstance(value, bool) or not isinstance(value, kind):
        raise ValueError(f"{key}: {value} is not a {spec['type']}")
    if value < spec.get("min", value) or value > spec.get("max", value):
        raise ValueError(f"{key}: {value} out of range")


class Sweep(BaseModel):
    bitwidth: list[int]
    tech_type: list[str]
    period: list[float]
    ii: list[int] # initation interval in HLS a.k.a throughput

    # Blackboxed deps are built at period * ratio, so a chain of them fits
    # the parent's clock. Applied again at each level of depth.
    # Helps meet timing constraints of the parent
    dep_period_ratio: Optional[list[float]] = [1]

    # The share of a blackboxed child's period kept for the parent's logic at
    # each child port. Applied again at each level of depth.
    dep_io_ratio: Optional[list[float]] = None

    # The time a parent keeps at each port, in ns. Builds a kernel alone as
    # the child it would be, with the same hash, so a later parent reuses it
    io_delay: Optional[list[float]] = None

    # Exact timing for one blackboxed child kernel, in ns, in place of the
    # ratios above, e.g. {l0_int_cmul: {period: [0.8], io_delay: [0.32]}}
    deps: Optional[dict[str, dict[str, list[float]]]] = None

    # Catapult directives for one kernel, e.g. {l1_mod_mul: {CLOCK_OVERHEAD: [0]}}.
    # Allowed names and values are in tessera/tcl/catapult/directives.yaml
    catapult: Optional[dict[str, dict[str, list]]] = None

    # A named curve fixes n to its own bitwidth; arb_field follows n
    field: Optional[list[str]] = None
    mred: Optional[list[Literal["mred_mont", "mred_bar"]]] = None # montgomery or barrett reduction

    # fixed hardwires the const into the hardware, for mults, this uses a sometimes cheaper constant multiplier
    q_type: Optional[list[Literal["fixed_q", "var_q"]]] = None # modulus prime q

    # reduction constant q_prime for montgomery reduction and mu for barrett reduction
    rc_type: Optional[list[Literal["fixed_rc", "var_rc"]]] = None

    # normal (DesignWare mults), schoolbook, karatsuba multipliers
    mul_type: Optional[list[Literal["mul_nor", "mul_sb", "mul_kar"]]] = None

    # which part of the product a mul keeps
    mul_output_type: Optional[list[Literal[
        "mul_output_full", "mul_output_lo", "mul_output_hi"
    ]]] = None

    # which constant to use, specifically for the l0_int_cmul kernel
    cmul_const: Optional[list[str]] = None
    cmul_const_w: Optional[list[int]] = None
    cmul_hamming: Optional[list[float]] = None

    # which part of the product a cmul keeps
    cmul_output_type: Optional[list[Literal[
        "cmul_output_full", "cmul_output_lo", "cmul_output_hi"
    ]]] = None

    # point addtion formula selections
    pdbl_form: Optional[list[Literal["pdbl_a0", "pdbl_a2", "pdbl_a3", "pdbl_avar"]]] = None
    padd_te_form: Optional[list[Literal["padd_te_add", "padd_te_cyclone"]]] = None

    # fixed bakes the curve coefficients into the hardware, var takes them as ports
    coef_type: Optional[list[Literal["fixed_coef", "var_coef"]]] = None

    # Keyed by n, e.g. {16: [8, 16], 32: [16, 32]}
    # TODO: We can autogenerate this list given rough base width constraint
    base_mul_width: Optional[dict[int, list[int]]] = None
    kar_base_mul_width: Optional[dict[int, list[int]]] = None

    @classmethod
    def enums(cls):
        """
        Returns enums for each sweep key, which are then
        used to generate the params.h defines.
        """
        out = {}
        for name, field in cls.model_fields.items():
            for arg in get_args(field.annotation) or ():
                values = get_args(get_args(arg)[0]) if get_args(arg) else ()
                if values and all(isinstance(v, str) for v in values):
                    out[name] = list(values)
                    break
        return out

    @model_validator(mode="after")
    def _check_tech(self):
        known_tech = RunConfig.load().tech
        for name in self.tech_type:
            if name not in known_tech:
                raise ValueError(f"unknown tech_type '{name}', pick from: {', '.join(sorted(known_tech))}")

        # The two report different things and take different flows, so a sweep
        # holding both would compare designs that cannot be compared
        if len({is_fpga(name) for name in self.tech_type}) > 1:
            raise ValueError("a sweep is either FPGA or ASIC, not both")
        return self

    @model_validator(mode="after")
    def _check_deps(self):
        for kernel, settings in (self.deps or {}).items():
            _check_kernel("deps", kernel)
            unknown = set(settings) - DEP_SETTINGS
            if unknown:
                raise ValueError(f"deps.{kernel}: unknown {', '.join(sorted(unknown))}, "
                                 f"pick from: {', '.join(sorted(DEP_SETTINGS))}")
        return self

    @model_validator(mode="after")
    def _check_catapult(self):
        allowed = load_catapult_directives()
        for kernel, directives in (self.catapult or {}).items():
            _check_kernel("catapult", kernel)
            for name, values in directives.items():
                if name not in allowed:
                    raise ValueError(f"catapult.{kernel}: unknown directive {name}, "
                                     f"pick from: {', '.join(sorted(allowed))}")
                for value in values:
                    _check_directive_value(f"catapult.{kernel}.{name}", value, allowed[name])
        return self

    @model_validator(mode="after")
    def _check_fields(self):
        if self.field:
            valid = {ARB_FIELD} | set(load_curves())
            for name in self.field:
                if name not in valid:
                    raise ValueError(f"unknown field '{name}', pick from: {', '.join(sorted(valid))}")
        return self

class SweepFlags(BaseModel):
    # Selects which designs go through logic synthesis
    syn_sel: Literal["all", "pareto", "small_fast"]

    # number of test samples for each design for C++/HLS-RTL/GLS Simulation/Verification
    num_test_samples: int = 100

    # compile_ultra passes in synthesis: one full, the rest incremental
    syn_passes: int = 1

    # A blackbox carries the child's synthesized area and delay, rather than
    # what Catapult estimated for it. Needs the children through syn.
    bb_syn_metrics: bool = False


class SweepConfig(BaseModel):
    sweep: Sweep
    flags: SweepFlags

    # Each variant replaces the keys it names in the sweep and is swept on
    # its own, so values from two variants are never crossed
    variants: list[dict] = []

    def sweeps(self):
        "The sweep, or one sweep per variant"
        base = self.sweep.model_dump()
        if not self.variants:
            return [base]
        return [Sweep(**{**base, **v}).model_dump() for v in self.variants]

    def is_fpga_run(self):
        return any(is_fpga(tech) for sweep in self.sweeps() for tech in sweep["tech_type"])

    @model_validator(mode="after")
    def _warn_fixed_deps_across_periods(self):
        # deps times are in ns, so they stay put while the top period changes
        for sweep in self.sweeps():
            if sweep["deps"] and len(sweep["period"]) > 1:
                logging.warning(f"deps sets fixed times in ns for {', '.join(sweep['deps'])}, "
                                f"but the sweep has several periods {sweep['period']}. "
                                f"Use one variant per period.")
        return self

    @model_validator(mode="after")
    def _check_fpga_flags(self):
        if self.is_fpga_run() and self.flags.bb_syn_metrics:
            raise ValueError("FPGA does not support bb_syn_metrics=true. Set bb_syn_metrics=false.")
        return self

    @classmethod
    def load(cls, path):
        return load_and_validate_yaml(cls, path)

