#!/usr/bin/env python3
"""Durable BLS PADD timing repair; keep original PE/arithmetic jobs immutable."""
import argparse, csv, datetime, fcntl, hashlib, importlib.util, json, os, re
import shutil, signal, subprocess, sys, time, traceback
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT.parent
WS = BASE / 'workspace'
OLD = BASE / 'dc_runs/20261024_014259_115687_padd'
MUL = BASE / 'dc_runs/20261024_021607_951088_multiplier_incremental'
BUILD = WS / 'build/l2_msm_padd_rcb/d7267ca0d90c7363'
LIB = Path('/ip/arm/gf12/sc7p5mcpp84_base_slvt_c14/r1p0/db/sc7p5mcpp84_12lp_base_slvt_c14_tt_nominal_max_0p90v_25c.db')
DC = '/eda/synopsys/syn/Y-2026.03/bin/dc_shell'
CAT = '/eda/siemens/Catapult/Mgc_home/bin/catapult'
OLDREF = 'l1_mod_mul_d7267ca0d90c7363'
NEWREF = OLDREF + '_regin'

def now(): return datetime.datetime.now(datetime.timezone.utc).isoformat()
def sha(p):
    h=hashlib.sha256()
    with Path(p).open('rb') as f:
        for b in iter(lambda:f.read(1<<20), b''): h.update(b)
    return h.hexdigest()
def save(p, v):
    p=Path(p); t=p.with_suffix(p.suffix+'.tmp')
    t.write_text(json.dumps(v, indent=2)+'\n'); t.replace(p)
def tcl(v):
    v=str(v)
    if any(x in v for x in '{}\r\n'): raise ValueError('Invalid Tcl literal')
    return '{'+v+'}'
def metrics(directory):
    p=Path(directory)
    area=re.search(r'Total cell area:\s*([\d.eE+-]+)', (p/'area.rpt').read_text())
    slacks=re.findall(r'slack\s*\((?:MET|VIOLATED)\)\s*([\d.eE+-]+)', (p/'timing_max.rpt').read_text())
    if not area or not slacks: raise RuntimeError('Missing area or slack in '+str(p))
    value={'area_um2':float(area[1]), 'worst_slack_ns':min(map(float, slacks))}
    if (p/'worst_slack_ns.txt').exists(): value['worst_slack_ns']=float((p/'worst_slack_ns.txt').read_text())
    value['setup_met']=value['worst_slack_ns']>=0
    return value
def hls_metrics(p):
    sections={}; current=None
    for row in csv.reader(p.open()):
        if len(row)==1 and row[0].strip(): current=row[0].strip(); sections[current]=[]
        elif row and current: sections[current].append(row)
    def first(name):
        rows=sections[name]; return dict(zip(map(str.strip, rows[0]), rows[1]))
    general=first('General'); timing=first('Timing')
    return {'latency_cycles':int(general['Latency Cycle']), 'ii':int(general['Throughput Cycle']),
            'estimated_area_score':float(general['Area']), 'estimated_delay_ns':float(timing['Max Delay'])}

def summary(state):
    rows=['# BLS PADD 1 ns timing repair', '',
          'Target: 1 ns, II=1, fewer than 20 PADD cycles. Original mapped PADD/PE files are preserved.', '',
          'The first attempt loads the 12-cycle mapped PADD, replaces all twelve multipliers with the completed incremental multiplier checkpoint, and permits optimization within and across those formerly protected boundaries. It uses up to two incremental passes, one core, no automatic ungrouping and no retiming.', '',
          'If setup still fails, the fallback regenerates PADD with a synchronous input register on each multiplier wrapper (child latency 5 → 6 cycles), explicit sequential blackbox timing, and 20% PADD clock overhead. It runs native and SCVerify RTL checks, then maps only if measured PADD latency is below 20 and II=1. The multiplier is real mapped logic, not an empty blackbox. Both attempts keep the original 1 ns and I/O constraints.', '',
          '**Current state:** '+state['state']+'; **active:** '+state.get('active','none')+'.', '',
          '| Candidate | State | PADD cycles | DC area (mm²) | Setup slack (ns) |',
          '|---|---|---:|---:|---:|', '| Original | mapped, timing failed | 12 | 1.909666 | −0.77 |']
    for name, item in state.get('candidates',{}).items():
        m=item.get('after',{}); latency=item.get('latency_cycles','pending')
        area=f"{m['area_um2']/1e6:.6f}" if m else 'pending'
        slack=f"{m['worst_slack_ns']:+.6f}" if m else 'pending'
        rows.append(f"| {name} | {item['state']} | {latency} | {area} | {slack} |")
    rows += ['', 'See [status.json](status.json) for heartbeat, logs, immutable input hashes and measurements. Completion of mapping is reported separately from timing closure. HLS RTL validation is not a gate-level equivalence or post-layout signoff result.', '',
             'The fallback HLS blackbox area carries the original multiplier estimate and does not add its new wrapper registers to that estimate; mapped DC area includes those registers. Use DC for the final area comparison. Sparse mode and the CGRA projects are outside this work.', '',
             'Tmux: `tmux -L pe_dc_simple attach -t run`, window `padd-timing`. Jobs survive editor/network disconnection; they do not survive host reboot. Each DC process has the existing 50 GiB host-free-memory guard.', '']
    (ROOT/'RESULTS.md').write_text('\n'.join(rows))

def prepare_dc(directory, mode, latency, parent=None, wrapper=None):
    directory.mkdir(parents=True, exist_ok=False); (directory/'sources').mkdir()
    for src in [ROOT/'scripts/repair.tcl', BASE/'dc/guard.py', BASE/'dc/memory_log.py']:
        shutil.copy2(src, directory/'sources'/src.name)
    mul_ddc=MUL/'results/mapped.ddc'; old_ddc=OLD/'results/mapped.ddc'; sdc=OLD/'results/mapped.sdc'
    for p in [mul_ddc,old_ddc]:
        if sha(p)!=(p.parent/'mapped.sha256').read_text().strip(): raise RuntimeError('Checkpoint checksum mismatch: '+str(p))
    if json.loads((MUL/'status.json').read_text())['state']!='passed': raise RuntimeError('Incremental multiplier not completed')
    values=dict(mode=mode, latency_cycles=latency, multiplier_ddc=mul_ddc, multiplier_sha256=sha(mul_ddc),
                baseline_ddc=old_ddc, baseline_sha256=sha(old_ddc), library_db=LIB, library_sha256=sha(LIB), input_sdc=sdc,
                parent_rtl=parent or '', child_wrapper=wrapper or '')
    (directory/'inputs.tcl').write_text('\n'.join(f'set {k} {tcl(v)}' for k,v in values.items())+'\n')
    inputs=[mul_ddc,old_ddc,sdc,LIB,Path(DC),*list((directory/'sources').iterdir())]
    if parent: inputs += [parent,wrapper]
    save(directory/'inputs.json', {'mode':mode,'latency_cycles':latency,'period_ns':1,'cores':1,
         'hashes':{str(p):sha(p) for p in inputs},'no_retiming':True,'no_multicycle_exceptions_added':True})

def prepare_hls(directory):
    directory.mkdir(parents=True, exist_ok=False)
    for folder in ['src','include','test','blackbox']:
        shutil.copytree(BUILD/folder, directory/folder)
    # Remove only copied output files; original artifacts are never modified.
    for f in (directory/'test').glob('outputs_*'): f.unlink()
    for name in ['reports','support']: (directory/name).mkdir()
    support=directory/'support'
    for rel in ['kernels','tessera/cpp','tessera/tcl']:
        shutil.copytree(WS/rel, support/rel, ignore=shutil.ignore_patterns('__pycache__'))
    source=(BUILD/'design.tcl').read_text().replace(str(BUILD),str(directory))
    source=source.replace('set comb_chk 1','set comb_chk 0')
    # Utility code and source includes are snapshots; DesignWare models remain read-only original inputs.
    for rel in ['kernels','tessera/cpp','tessera/tcl']:
        source=source.replace(str(WS/rel),str(support/rel))
    (directory/'design.tcl').write_text(source)
    script=(WS/'build/l2_msm_padd_rcb/kernel.tcl').read_text()
    for rel in ['kernels','tessera/cpp','tessera/tcl']:
        script=script.replace(str(WS/rel),str(support/rel))
    script=script.replace('directive set -CLOCK_OVERHEAD 0','directive set -CLOCK_OVERHEAD 20')
    script=script.replace('directive set -OUTPUT_REGISTERS false','directive set -OUTPUT_REGISTERS true')
    (directory/'run.tcl').write_text(script+'\nexit 0\n')
    wrapper=f'''module {NEWREF} (clk, rst, x, y, z);
  input clk, rst;
  input [380:0] x, y;
  output [380:0] z;
  reg [380:0] x_q, y_q;
  always @(posedge clk) begin
    if (rst) begin x_q <= 381'b0; y_q <= 381'b0; end
    else begin x_q <= x; y_q <= y; end
  end
  {OLDREF}_top u (.clk(clk), .rst(rst), .x_rsc_dat(x_q), .y_rsc_dat(y_q),
    .z_rsc_dat(z), .x_triosy_lz(), .y_triosy_lz(), .z_triosy_lz());
endmodule
'''
    original=(BUILD/f'blackbox/wrapper/{OLDREF}_wrapper.v').read_text()
    bundled=(BUILD/f'blackbox/rtl/{OLDREF}.v').read_text()
    if original.strip() not in bundled: raise RuntimeError('Cannot locate original wrapper')
    (directory/f'blackbox/rtl/{OLDREF}.v').write_text(bundled.replace(original.strip(),wrapper.strip()))
    (directory/f'blackbox/wrapper/{OLDREF}_wrapper.v').write_text(wrapper)
    model=directory/'blackbox/impl/l1_mod_mul_impl.h'
    s=model.read_text().replace(str(BUILD),str(directory)).replace(str(WS/'kernels'),str(support/'kernels'))
    s=s.replace(f'.entity("{OLDREF}")', f'.entity("{NEWREF}")').replace('.latency(5)', '.latency(6)')
    s=s.replace('.clock_name("clk")', '.input_delay(0.03).delay(0.75).min_clock_period(1.0)\n            .clock_name("clk")')
    model.write_text(s)
    sourcefiles=[p for p in directory.rglob('*') if p.is_file()]
    save(directory/'source_sha256.json', {str(p.relative_to(directory)):sha(p) for p in sourcefiles})
    save(directory/'parameters.json',dict(clock_ns=1,clock_overhead_percent=20,registered_outputs=True,
        multiplier_latency=6,multiplier_input_delay_ns=0.03,multiplier_output_delay_ns=0.75,
        timing_note='Input register setup allowance and conservative output budget; DC validates actual timing.',
        padd_latency_limit_exclusive=20,ii=1))

def validate_hls(directory):
    spec=importlib.util.spec_from_file_location('arithmetic_audit',BASE/'audit/validate_arithmetic.py')
    a=importlib.util.module_from_spec(spec); spec.loader.exec_module(a)
    inputs=a.rows(directory/'test/samples.csv'); gold=a.rows(directory/'test/goldens.csv')
    if len(inputs)<64 or len(inputs)!=len(gold): raise RuntimeError('Insufficient vectors')
    for mode in ['cpp','rtl']:
        if a.rows(directory/f'test/outputs_{mode}.csv')!=gold: raise RuntimeError(mode+' mismatch')
    independent=[]
    for row in inputs:
        if len(row)!=8 or row[6]!=a.Q: raise RuntimeError('Unexpected field/vector format')
        value=a.affine_add(a.decode(row[:3]),a.decode(row[3:6]))
        independent.append([0,0] if value is None else list(value))
    if independent!=gold: raise RuntimeError('Independent affine reference mismatch')
    log=(directory/'catapult.log').read_text(errors='replace')
    if 'Simulation PASSED' not in log: raise RuntimeError('Missing RTL pass')
    errors=re.findall(r'Errors:\s*(\d+)',log)
    if not errors or any(int(n) for n in errors): raise RuntimeError('RTL simulation error summary')
    h=hls_metrics(directory/'reports/metrics.csv')
    h.update(samples=len(gold),native_pass=True,rtl_pass=True,independent_reference_pass=True)
    save(directory/'validation.json',h)
    if h['ii']!=1 or not 0<h['latency_cycles']<20: raise RuntimeError('HLS candidate outside II/latency target: '+str(h))
    return h

def main():
    ap=argparse.ArgumentParser(); ap.add_argument('--attempt',default='01'); ap.add_argument('--mode',choices=['auto','incremental','pipelined'],default='auto'); args=ap.parse_args()
    lock=(ROOT/'run.lock').open('a'); fcntl.flock(lock, fcntl.LOCK_EX|fcntl.LOCK_NB)
    state={'state':'preparing','pid':os.getpid(),'started_utc':now(),'candidates':{},'attempt':args.attempt}
    child=None
    def update():
        state['updated_utc']=now(); save(ROOT/'status.json',state); summary(state)
    def interrupted(signum,frame):
        if child is not None and child.poll() is None: child.terminate()
        raise KeyboardInterrupt('Interrupted')
    signal.signal(signal.SIGTERM,interrupted)
    def execute(command,cwd,logpath):
        nonlocal child
        with logpath.open('w') as log:
            child=subprocess.Popen(command,cwd=cwd,stdout=log,stderr=subprocess.STDOUT)
            state['active_pid']=child.pid; state['active_log']=str(logpath); update()
            while child.poll() is None:
                update(); time.sleep(10)
            rc=child.returncode; child=None
        return rc
    def dc_run(name,run,latency):
        item=state['candidates'].setdefault(name,{})
        item.update(state='dc_running',run_dir=str(run),latency_cycles=latency,started_utc=now())
        state.update(state='running',active=name); update()
        command=[sys.executable,str(run/'sources/guard.py'),'--min-free-gib','50','--',DC,'-f',str(run/'sources/repair.tcl')]
        rc=execute(command,run,run/'dc.log')
        errors=re.findall(r'^(?:Error:|Fatal:|PADD_REPAIR_FAILED:).*$',(run/'dc.log').read_text(errors='replace'),re.M)
        if rc or errors or not (run/'SUCCESS').exists():
            item.update(state='tool_failed',errors=errors[-15:],exit_code=rc); update(); return False
        passes={p.name:metrics(p) for p in sorted((run/'reports').glob('pass_*'))}
        if not passes: raise RuntimeError('No DC pass results')
        after=list(passes.values())[-1]
        item.update(state='timing_met' if after['setup_met'] else 'timing_failed',before=metrics(run/'reports/before'),
                    after=after,passes=passes,ended_utc=now(),mapped_ddc_sha256=sha(run/'results/mapped.ddc'))
        save(run/'result.json',item); update(); return after['setup_met']
    update()
    try:
        if args.mode in ['auto','incremental']:
            run=ROOT/'runs'/('incremental_'+args.attempt)
            prepare_dc(run,'incremental',12)
            if dc_run('incremental',run,12):
                state.update(state='complete',active='none',selected='incremental'); update(); return 0
        if args.mode in ['auto','pipelined']:
            name='registered_input_oh20'; hls=ROOT/'runs'/(name+'_'+args.attempt)
            state['candidates'][name]={'state':'hls_preparing','hls_dir':str(hls)}
            state.update(active=name,state='running'); update(); prepare_hls(hls)
            state['candidates'][name]['state']='hls_running'; update()
            if execute([CAT,'-shell','-file','run.tcl'],hls,hls/'catapult.log'):
                raise RuntimeError('Fallback Catapult failed: '+str(hls/'catapult.log'))
            h=validate_hls(hls); state['candidates'][name].update(hls=h,latency_cycles=h['latency_cycles']); update()
            spec=importlib.util.spec_from_file_location('pipeline_helpers',BASE/'dc/run_pipeline.py')
            helper=importlib.util.module_from_spec(spec); spec.loader.exec_module(helper)
            parent=hls/'parent_for_dc.v'; sol=hls/'Catapult/l2_msm_padd_rcb.v1'
            inv=helper.parent_rtl(sol/'rtl.v',sol/'concat_rtl.v','l2_msm_padd_rcb',NEWREF,parent)
            if inv['boundary_reference_count']!=12: raise RuntimeError('Expected twelve input-registered multipliers')
            save(hls/'dc_inventory.json',inv)
            wrapper=hls/'wrapper_for_dc.v'
            wrapper.write_text((hls/f'blackbox/wrapper/{OLDREF}_wrapper.v').read_text().replace(OLDREF+'_top','FIXEDMUL_l1_mod_mul'))
            run=ROOT/'runs'/('pipelined_dc_'+args.attempt)
            prepare_dc(run,'pipelined',h['latency_cycles'],parent,wrapper)
            closed=dc_run(name,run,h['latency_cycles'])
            state.update(state='complete' if closed else 'completed_timing_unmet',active='none',selected=name if closed else None)
        else: state.update(state='completed_timing_unmet',active='none')
        state['ended_utc']=now(); update(); return 0
    except BaseException as exc:
        state.update(state='failed',error=str(exc),ended_utc=now()); update(); traceback.print_exc(); return 1

if __name__=='__main__': sys.exit(main())
