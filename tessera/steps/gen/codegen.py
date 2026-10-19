"""
Generate Core Catapult Sweep files per-design header files
"""
from pathlib import Path

from tessera.models.config import RunConfig
from tessera.models.sweep import Sweep
from tessera.templating import render
from tessera.parser.common import norm_to_cpp_conv, strip_tmpl_prefix
from tessera.models.common import load_catapult_directives
from tessera.models.design import PARAMS_MAPPED_TO_STRUCT
from tessera.models.ports import is_fixed, fixed_member
from tessera.const import CATAPULT_STATES, DWARE_DIR, HW_CONSTRAINTS_PARAMS, KERNELS_DIR

# Catapult states that save the table to a file
SAVE_TABLE_STATES = {"schedule", "dpfsm", "extract"}


def gen_params_h(design, out_dir=None):
    out_dir = out_dir or design.build_dir
    enums = {
        norm_to_cpp_conv(value): i
        for values in Sweep.enums().values()
        for i, value in enumerate(values)
    }

    defines, usings = {}, {}
    for param, value in design.design.items():
        # Constraints steer the tools, not the C++, so they stay out of params.h
        if param in HW_CONSTRAINTS_PARAMS or param == "io_delay" or param.startswith(("deps.", "catapult.")):
            continue
        if param in PARAMS_MAPPED_TO_STRUCT:
            # A struct ref becomes a type alias, e.g.
            # using CMUL_CONST = BN254_BASE::Q_PRIME
            # Therefore its uses the "using" syntax
            usings[norm_to_cpp_conv(param)] = norm_to_cpp_conv(value)
        else:
            # rest are define macros
            defines[norm_to_cpp_conv(param)] = norm_to_cpp_conv(value)

    render(
        "params.h.j2",
        out_dir / 'include' / 'params.h',
        enums=enums,
        params=defines,
        usings=usings,
        structs=design.structs,
    )


def gen_kernel_top(design, kernel, combinational=False, out_dir=None):
    """
    Generate the top header and the source file Catapult synthesizes.
    A combinational kernel is wrapped, a sequential one is the top itself.
    """
    out_dir = out_dir or design.build_dir
    template_args = ", ".join(p["name"].upper()
                              for p in kernel.impl_spec["tmpl_params"])

    ports, args = [], []
    for param in kernel.impl_spec["run_params"]:
        if is_fixed(param["name"], design.design):
            member = fixed_member(param["name"], design.design)
            args.append(f"FIELD::{member.upper()}::VALUE()")
            continue

        # A template param _X resolves through the params.h name X at the top
        text = strip_tmpl_prefix(param["text"])
        ports.append({"name": param["name"], "text": text})
        args.append(param["name"])

    ctx = dict(
        kernel=kernel.name,
        ports=ports,
        args=args,
        combinational=combinational,
        template_args=template_args,
    )

    render("kernel_top.h.j2", out_dir / 'include' / f'{kernel.name}_top.h', **ctx)
    render("kernel.cpp.j2", out_dir / 'src' / f'{kernel.name}_top.cpp', **ctx)
    

def gen_catapult_design_tcl(design, kernel, comb_chk=False, combinational=False):
    # Add the design's tech node, lib paths and config from config.yaml
    tech = RunConfig.load().tech[design.design['tech_type']].model_dump()
    tech = {k: str(Path(v).expanduser()) if v and k.endswith(('_path', '_file')) else (v or "")
            for k, v in tech.items()}

    render(
        "design.tcl.j2",
        design.build_dir / "design.tcl",
        design_name=design.build_dir.name,
        design_build_dir=design.build_dir.resolve(),
        design=design.design,
        tech=tech,
        comb_chk=comb_chk,
        uses_blackboxes=design.uses_blackboxes,
        top_class=f"{kernel.name}_top" if combinational else kernel.name,
        catapult_directives=directives_by_state(design, kernel),
    )


def directives_by_state(design, kernel):
    """
    This kernel's sweep directives as state -> "NAME value ..." pairs. Each is
    applied just before its last allowed state, when any object it names exists.
    """
    allowed = load_catapult_directives()
    by_state = {}
    for key, value in design.design.items():
        if key.startswith(f"catapult.{kernel.name}."):
            name = key.rsplit(".", 1)[1]
            by_state.setdefault(allowed[name]["last_state"], []).append(f"{name} {value}")
    return {state: " ".join(pairs) for state, pairs in by_state.items()}


def _state_bodies(kernel, run_inst):
    "Kernel-agnostic TCL per Catapult state, before kernel.yaml additions are appended"
    cpp_path = Path(run_inst.root_dir, 'tessera', 'cpp')
    cpp_src_path = cpp_path / 'src'

    # Every kernel's impl dir is on the search path, so any dep's header
    # resolves without walking the dependency tree
    include_paths = [
        cpp_path / 'include',
        *sorted(KERNELS_DIR.glob("*/*/impl")),
    ]
    include_paths_str = "\n".join(f"  {p.resolve()}" for p in include_paths)

    analyze_state = [
        # The blackbox dir comes first, so a generated header shadows the
        # kernel's own when that dep is blackboxed.
        "options set Input/SearchPath [file join $design_build_dir blackbox impl] -append",
        "options set Input/SearchPath {\n" + include_paths_str + "\n} -append",
        "options set Input/SearchPath [file join $design_build_dir include] -append",
        "solution file add [file join $design_build_dir src " + f"{kernel.name}_top.cpp]",
        # A generated header stands in for its dep only under this flag, and
        # falls back to the real implementation without it
        "if { $uses_blackboxes } { options set Input/CompilerFlags "
        "\"[options get Input/CompilerFlags] -DBLACKBOX_FLOW\" }",
        f"solution file add [file join {(kernel.path / f'{kernel.name}_tb.cpp').resolve()}] -exclude true",
        f"solution file add [file join {(cpp_src_path / 'csvparser.cpp').resolve()}] -exclude true",
        f"solution file add [file join {(cpp_src_path / 'tb_helper.cpp').resolve()}] -exclude true",
    ]

    compile_state = [
        # A combinational kernel is wrapped, so the top class differs
        "solution design set $top_class.run -top",
        "directive set -CCORE_POINTS 1",
        "directive set -DESIGN_GOAL latency",
        "directive set -OUTPUT_REGISTERS false",
    ]

    libraries_state = [
        "run_osci_test $test_cpp $test_cpp_only $design_build_dir",
        "set_tech_lib $tech_type $root_dir $tech_lib_path $tech_catapult_lib_name \
     $tech_vendor $tech_technology $tech_catapult_lib_file \
     $tech_family $tech_speed $tech_part",
        "set_clock $period",
        # A sequential child leaves io_delay at its ports for the parent. A
        # combinational one reports its full delay to the parent instead.
        "if { [info exists io_delay] && $top_class eq $kernel_name } {",
        "    directive set -INPUT_DELAY $io_delay",
        "    directive set -OUTPUT_DELAY $io_delay",
        "}",
    ]

    return {'analyze': analyze_state, 'compile': compile_state, 'libraries': libraries_state}



def gen_catapult_kernel_tcl(flags, kernel, run_inst):
    bodies = _state_bodies(kernel, run_inst)
    for state, body in kernel.config.states.items():
        bodies.setdefault(state, []).extend(body.splitlines())

    states = [
        {
            'name': state,
            'body': "\n".join(bodies.get(state, [])),
            'save_table': state in SAVE_TABLE_STATES,
        }
        for state in CATAPULT_STATES
    ]

    tcl_dir = Path(run_inst.root_dir, 'tessera', 'tcl', 'catapult')
    render(
        "kernel.tcl.j2",
        kernel.build_dir / "kernel.tcl",
        root_dir=run_inst.root_dir,
        kernel_name=kernel.name,
        dware_dir=DWARE_DIR,
        catapult_util_tcl=(tcl_dir / 'util.tcl').resolve(),
        catapult_init_tcl=(tcl_dir / 'init.tcl').resolve(),
        catapult_verify_tcl=(tcl_dir / 'verify.tcl').resolve(),
        catapult_vivado_tcl=(tcl_dir / 'vivado.tcl').resolve(),
        flags=flags,
        threads_per_process=run_inst.threads_per_process,
        vcd_size_limit=RunConfig.load().vcd_size_limit_mb,
        states=states,
        tools={k: str(Path(v).expanduser()) for k, v in RunConfig.load().tools.items()},
    )
