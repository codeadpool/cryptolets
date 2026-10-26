#!/usr/bin/env python3
"""Prepare a fresh standalone PE HLS or protected-child DC run; never launch tools."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import shlex
import shutil
import sys

ROOT = Path(__file__).resolve().parent
FROZEN = ROOT.parent / 'padd_timing_debug/frozen_sources'
ENTITY = 'l2_msm_padd_rcb_d7267ca0d90c7363'
PADD_SHA = '48574e2276e047385dd7e46fe0fb273ba6d624e6e6b2818ba260bbc5aff05099'
sys.path.insert(0, str(ROOT / 'scripts'))


def sha(path):
    h = hashlib.sha256()
    with Path(path).open('rb') as f:
        for block in iter(lambda: f.read(1024 * 1024), b''):
            h.update(block)
    return h.hexdigest()


def tcl(value):
    value = str(value)
    if any(c in value for c in '{}\n\r'):
        raise ValueError(f'Unsupported Tcl literal: {value!r}')
    return '{' + value + '}'


def path(value):
    return Path(value).expanduser().resolve()


def require(p):
    if not p.is_file():
        raise ValueError(f'Missing file: {p}')
    return p


def fresh(out):
    # Existing output paths are never reused, including empty directories.
    out.mkdir(parents=True, exist_ok=False)


def settings(out, name, values):
    (out / name).write_text(''.join(f'set {key} {tcl(value)}\n'
                                  for key, value in values.items()))


def receipt(out, mode, command, extra=None):
    files = [p for p in ROOT.rglob('*') if p.is_file() and '__pycache__' not in p.parts]
    if mode == 'hls':
        files += [p for p in FROZEN.rglob('*') if p.is_file()]
    data = {'state': 'prepared_not_executed', 'mode': mode, 'cwd': str(out),
            'command': list(map(str, command)), 'padd_cycles': 12,
            'source_sha256': {str(p): sha(p) for p in sorted(files)}, **(extra or {})}
    (out / 'prepared.json').write_text(json.dumps(data, indent=2) + '\n')
    print('Prepared:', out)
    print('Run in that directory:', shlex.join(list(map(str, command))))


def prepare_hls(args):
    from gen_pe_vectors import generate
    out = path(args.out)
    mgc, questa, dc = map(path, (args.catapult_home, args.questa_home, args.dc_home))
    lib = require(path(args.gf12_lib))
    require(mgc / 'bin/catapult')
    require(mgc / 'shared/include/ac_int.h')
    require(FROZEN / 'kernels/l2/l2_msm_padd_rcb/impl/l2_msm_padd_rcb_impl.h')
    dware = path(args.dware_dir) if args.dware_dir else out / 'dware'
    if args.rtl:
        for name in ['DW01_ver', 'DW02_ver', 'DW03_ver', 'DWARE_ver']:
            if not (dware / name).is_dir():
                raise ValueError('RTL simulation needs compiled DesignWare libraries: ' + str(dware / name))
    fresh(out)
    for sub in ['include', 'blackbox/impl', 'blackbox/rtl', 'blackbox/wrapper', 'reports']:
        (out / sub).mkdir(parents=True, exist_ok=True)
    shutil.copyfile(ROOT / 'arithmetic/params.h', out / 'include/params.h')
    padd_rtl = out / 'blackbox/rtl' / (ENTITY + '.v')
    shutil.copyfile(ROOT / 'arithmetic/padd.v', padd_rtl)
    shutil.copyfile(ROOT / 'arithmetic/padd_wrapper.v', out / 'blackbox/wrapper' / (ENTITY + '_wrapper.v'))
    impl = FROZEN / 'kernels/l2/l2_msm_padd_rcb/impl/l2_msm_padd_rcb_impl.h'
    if any(c in str(impl) + str(padd_rtl) for c in '"\\\n\r'):
        raise ValueError('Unsupported C++ include/RTL path')
    header = (ROOT / 'arithmetic/padd_blackbox.h.in').read_text()
    header = header.replace('@PADD_IMPL@', str(impl)).replace('@PADD_RTL@', str(padd_rtl))
    (out / 'blackbox/impl/l2_msm_padd_rcb_impl.h').write_text(header)
    includes = [out / 'blackbox/impl', ROOT / 'msm/include', out / 'include',
                ROOT / 'support', FROZEN / 'tessera/cpp/include',
                *sorted((FROZEN / 'kernels').glob('*/*/impl')),
                mgc / 'shared/pkgs/matchlib/cmod/include']
    defines = {'MSM_LOG_POINTS': 16, 'MSM_BANK_LOG_POINTS': 12, 'MSM_WINDOW': 8,
               'MSM_NUM_PES': 4, 'MSM_SCALAR_BITS': 255, 'MSM_QDEPTH': 4,
               'MSM_SIM_PADD_LATENCY': 13, 'MSM_PENDING_DEPTH': 8}
    flags = '-DCONNECTIONS_ACCURATE_SIM -DSC_INCLUDE_DYNAMIC_PROCESSES -DBLACKBOX_FLOW '
    flags += ' '.join(f'-D{k}={v}' for k, v in defines.items())
    values = {'root_dir': ROOT, 'support_dir': FROZEN, 'design_build_dir': out,
              'threads_per_process': args.cores, 'compiler_flags': flags,
              'period': 1.0, 'tech_type': 'gf12_highperf', 'verify_rtl': int(args.rtl),
              'test_cpp_only': int(args.cpp_only), 'trace_control': 0,
              'tool_questa': questa, 'tool_dc': dc, 'tool_vivado': '',
              'tech_lib_path': path(args.gf12_search) if args.gf12_search else lib.parent,
              'tech_catapult_lib_name': 'gf12_highperf', 'tech_vendor': 'GlobalFoundries',
              'tech_technology': '12nm', 'tech_catapult_lib_file': lib, 'dware_dir': dware}
    settings(out, 'run_config.tcl', values)
    with (out / 'run_config.tcl').open('a') as f:
        f.write('set include_paths [list ' + ' '.join(tcl(p) for p in includes) + ']\n')
    shutil.copyfile(ROOT / 'tcl/msm_pe_external.tcl', out / 'msm_pe_external.tcl')
    generate(out / 'test')
    # Reusable include/define arguments also allow a native SystemC smoke test.
    (out / 'native_flags.json').write_text(json.dumps({
        'defines': defines, 'include_paths': list(map(str, includes)),
        'testbench': str(ROOT / 'msm/src/msm_pe_tb.cpp'),
        'csvparser': str(ROOT / 'support/csvparser.cpp')}, indent=2) + '\n')
    receipt(out, 'hls', [mgc / 'bin/catapult', '-shell', '-file', 'msm_pe_external.tcl'],
            {'geometry': defines, 'rtl_simulation_requested': args.rtl,
             'cpp_only': args.cpp_only, 'padd_rtl_sha256': sha(padd_rtl)})


def prepare_dc(args):
    from extract_parent import parent_rtl
    from report_external_pe import report
    hls, out = path(args.hls_out), path(args.out)
    checkpoint, library = require(path(args.padd_ddc)), require(path(args.library_db))
    if sha(checkpoint) != PADD_SHA:
        raise ValueError('PADD checkpoint does not match the pinned 12-cycle PE baseline. '
                         'Changing arithmetic requires a new HLS/validation contract.')
    # Check the generated physical memory ports and exactly one real PADD.
    contract = report(hls)
    raw, concat = require(Path(contract['raw_rtl'])), require(Path(contract['concat_rtl']))
    wrapper = require(hls / 'blackbox/wrapper' / (ENTITY + '_wrapper.v'))
    fresh(out)
    (out / 'sources').mkdir()
    rtl = out / 'sources/parent.v'
    inventory = parent_rtl(raw, concat, 'msm_mpe_pe', ENTITY, rtl)
    if inventory['boundary_reference_count'] != 1:
        raise ValueError('Expected exactly one PADD boundary in extracted PE')
    shutil.copyfile(wrapper, out / 'sources/child_wrapper.v')
    shutil.copyfile(ROOT / 'dc/map_stage.tcl', out / 'map_stage.tcl')
    values = {'stage': 'pe', 'top': 'msm_mpe_pe', 'rtl': rtl, 'library_db': library,
              'resume_ddc': '', 'resume_sha256': '', 'period_ns': 1.0,
              'check_only': int(args.check_only), 'max_cores': args.cores,
              'child_ddc': checkpoint, 'child_top': 'l2_msm_padd_rcb',
              'child_ref': ENTITY, 'child_count': 1, 'child_ddc_sha256': PADD_SHA,
              'child_wrapper': out / 'sources/child_wrapper.v'}
    settings(out, 'inputs.tcl', values)
    identity = {'pe_rtl_sha256': sha(rtl), 'padd_ddc_sha256': PADD_SHA,
                'library_sha256': sha(library), 'wrapper_sha256': sha(out / 'sources/child_wrapper.v'),
                'inputs_sha256': sha(out / 'inputs.tcl'), 'script_sha256': sha(out / 'map_stage.tcl')}
    serialized = json.dumps(identity, sort_keys=True).encode()
    (out / 'contract.sha256').write_text(hashlib.sha256(serialized).hexdigest() + '\n')
    (out / 'rtl_inventory.json').write_text(json.dumps(inventory, indent=2) + '\n')
    receipt(out, 'dc', [path(args.dc_home) / 'bin/dc_shell', '-f', 'map_stage.tcl'],
            {'identity': identity, 'child_dont_touch': True,
             'excluded_bucket_sram_bits': contract['excluded_bucket_sram_bits']})


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest='mode', required=True)
    hls = sub.add_parser('hls', help='Prepare Catapult HLS with the included real PADD RTL')
    hls.add_argument('--out', required=True)
    hls.add_argument('--catapult-home', default=os.environ.get('MGC_HOME'), required=not os.environ.get('MGC_HOME'))
    hls.add_argument('--questa-home', required=True)
    hls.add_argument('--dc-home', required=True)
    hls.add_argument('--gf12-lib', required=True, help='Catapult gf12_highperf.lib file')
    hls.add_argument('--gf12-search', help='Additional foundry library search root')
    hls.add_argument('--cores', type=int, choices=range(1, 5), default=1)
    modes = hls.add_mutually_exclusive_group()
    modes.add_argument('--rtl', action='store_true', help='Also run SCVerify RTL after HLS')
    modes.add_argument('--cpp-only', action='store_true', help='Stop after OSCI; do not synthesize')
    hls.add_argument('--dware-dir', help='Existing compiled DesignWare libraries; required with --rtl')
    hls.set_defaults(func=prepare_hls)
    dc = sub.add_parser('dc', help='Prepare DC with the mapped PADD protected')
    dc.add_argument('--out', required=True)
    dc.add_argument('--hls-out', required=True)
    dc.add_argument('--padd-ddc', required=True)
    dc.add_argument('--library-db', required=True)
    dc.add_argument('--dc-home', required=True)
    dc.add_argument('--cores', type=int, choices=range(1, 5), default=4)
    dc.add_argument('--check-only', action='store_true', help='Generate a link/check-only DC run')
    dc.set_defaults(func=prepare_dc)
    args = parser.parse_args()
    args.func(args)


if __name__ == '__main__':
    main()
