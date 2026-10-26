#!/usr/bin/env python3
"""Check exported physical bucket ports and reject internal SRAM instances."""
import argparse
import hashlib
import json
from pathlib import Path
import re


def report(build):
    build = Path(build)
    candidates = sorted((build / 'Catapult').glob('msm_mpe_pe.v*/rtl.v'))
    if len(candidates) != 1:
        raise RuntimeError(f'Expected one PE RTL solution, got {candidates}')
    rtl = candidates[0]
    text = re.sub(r'/\*.*?\*/|//[^\n]*', '', rtl.read_text(), flags=re.S)
    match = re.search(r'\bmodule\s+msm_mpe_pe\s*\((.*?)\bendmodule', text, re.S)
    if not match:
        raise RuntimeError('No msm_mpe_pe RTL top found')
    body = match.group(1)
    ports = []
    for item in re.finditer(r'\b(input|output|inout)\s+(?:(?:wire|reg)\s+)?(?:\[(\d+):(\d+)\]\s*)?([A-Za-z_][\w$]*)\s*;', body):
        direction, hi, lo, name = item.groups()
        ports.append({'name': name, 'direction': direction,
                      'width': abs(int(hi)-int(lo))+1 if hi else 1})
    if not ports:
        raise RuntimeError('No plain Verilog port declarations parsed')
    memories = {}
    failures = []
    for coordinate in 'xyz':
        selected = [p for p in ports if f'br_{coordinate}' in p['name']]
        counts = {}
        for p in selected:
            key = (p['direction'], p['width'])
            counts[key] = counts.get(key, 0) + 1
        # One read-data bus, one write-data bus, two independently enabled
        # address paths. Additional clock/reset/enable outputs are permitted.
        for key, wanted in [(('input', 381), 1), (('output', 381), 1),
                            (('output', 12), 2)]:
            if counts.get(key, 0) != wanted:
                failures.append(f'{coordinate}: expected {wanted} {key} port(s), got {counts.get(key,0)}')
        if counts.get(('output', 1), 0) < 2:
            failures.append(f'{coordinate}: missing independent read/write enable outputs')
        memories[coordinate] = {'depth': 2080, 'data_bits': 381,
            'address_bits': 12, 'ports': selected,
            'memory_type': 'synchronous 1R1W, external ccs_ram_sync_1R1W model',
            'read_latency_cycles': 1, 'clock_edge': 'posedge',
            'read_enable_active_high': True, 'write_enable_active_high': True,
            'same_address_read_write': 'read returns old data',
            'disabled_read': 'read data holds previous value'}
    # Adapter modules containing the memory type in their name are valid logic;
    # an actual generic SRAM instance would defeat this external boundary.
    internal_instances = len(re.findall(r'(?m)^\s*ccs_ram_sync_1R1W\s*#\s*\(', text))
    if internal_instances:
        failures.append(f'{internal_instances} internal generic bucket SRAM instances remain')
    padd_header = build / 'blackbox/impl/l2_msm_padd_rcb_impl.h'
    padd_entities = re.findall(r'\.entity\("([^"]+)"\)', padd_header.read_text())
    if len(padd_entities) != 1:
        failures.append(f'Expected one PADD blackbox entity, got {padd_entities}')
    padd_entity = padd_entities[0] if len(padd_entities) == 1 else None
    padd_instances = len(re.findall(r'(?m)^\s*' + re.escape(padd_entity) + r'\s+[A-Za-z_][\w$]*\s*\(', text)) if padd_entity else 0
    if padd_instances != 1:
        failures.append(f'Expected one real PADD reference instance, got {padd_instances}')
    result = {'top_module': 'msm_mpe_pe', 'raw_rtl': str(rtl.resolve()),
        'concat_rtl': str((rtl.parent / 'concat_rtl.v').resolve()),
        'wrappers': [str(p.resolve()) for p in sorted((build / 'blackbox/wrapper').glob('*_wrapper.v'))],
        'padd_reference_module': padd_entity, 'padd_reference_instances': padd_instances,
        'external_memory_model': 'Catapult pkgs/siflibs/ccs_ram_sync_1R1W.v',
        'passed': not failures, 'failures': failures, 'top': 'msm_mpe_pe',
        'rtl': str(rtl.resolve()), 'rtl_sha256': hashlib.sha256(rtl.read_bytes()).hexdigest(),
        'bucket_memories': memories, 'all_top_ports': ports,
        'internal_generic_sram_instances': internal_instances,
        'excluded_bucket_sram_bits': 3 * 2080 * 381,
        'excluded_bucket_sram_mib': 3 * 2080 * 381 / 8 / 2**20,
        'excluded_bucket_sram_area_mm2_at_0_88_per_mib': 3 * 2080 * 381 / 8 / 2**20 * 0.88,
        'notes': ['No scheduler or array access order change: externalization is a Catapult mapping directive.',
                  'Array behavior is verified by SCVerify external sample-memory models, not counted as PE mapped logic.',
                  'C++ busy/address queues and pending FIFO remain within the PE.']}
    directory = build / 'reports'
    directory.mkdir(exist_ok=True)
    (directory / 'external_bucket_ports.json').write_text(json.dumps(result, indent=2) + '\n')
    (directory / 'pe_artifact_contract.json').write_text(json.dumps(result, indent=2) + '\n')
    if failures:
        raise RuntimeError('; '.join(failures))
    return result


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--build', type=Path, required=True)
    args = parser.parse_args()
    result = report(args.build)
    print(json.dumps({'passed': result['passed'], 'rtl': result['rtl'],
                      'excluded_bucket_sram_bits': result['excluded_bucket_sram_bits']}))
