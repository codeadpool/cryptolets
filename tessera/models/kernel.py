"""
Per kernel models: kernel.yaml and the kernel itself.
"""
from pathlib import Path
from pydantic import BaseModel, model_validator

from tessera.const import BUILD_DIR, KERNELS_DIR
from tessera.models.common import load_and_validate_yaml
from tessera.parser.cpp import parse_header


class KernelConfig(BaseModel):
    # parameters specific to the design, which helps use group
    # designs for given kernel which perform the same arithmetic operation 
    design_key: list[str] = []
    kernel_key: list[str] = [] # parameters specific to the kernel
    states: dict[str, str] = {} # TCL per Catapult state, from kernel.yaml
    fields: list[str] = [] # Fields the impl names directly, beyond the design's own
    structs: dict[str, dict] = {} # Structs the kernel defines itself
    force_combinational: bool = False # Skip the latency check, build as one combinational block
    systemc: bool = False # The impl is an sc_module, the top itself, with no run()


    @model_validator(mode="after")
    def _kernel_key_is_part_of_the_design(self):
        extra = set(self.kernel_key) - set(self.design_key or self.kernel_key)
        if extra:
            raise ValueError(
                f"{', '.join(sorted(extra))} decide what the kernel computes, "
                f"so they belong in design_key as well")
        return self

    @classmethod
    def load(cls, kernel_path):
        return load_and_validate_yaml(cls, Path(kernel_path, "kernel.yaml"))


class Kernel:
    def __init__(self, name):
        self.name = name
        self.path = Kernel.find(name)
        self.build_dir = BUILD_DIR / name
        self.config = KernelConfig.load(self.path)
        # A SystemC kernel has no run() to wrap, and is never a blackboxed child
        self.impl_spec = None if self.config.systemc else parse_header(self.path / "impl" / f"{name}_impl.h")
        self.blackbox = [] # set per run from the sweep's flags.blackbox

    @staticmethod
    def find(name):
        "The kernel's directory, under whichever level holds it"
        for level in KERNELS_DIR.iterdir():
            if level.is_dir() and (level / name).is_dir():
                return level / name
        raise Exception(f"Kernel '{name}' not found")
