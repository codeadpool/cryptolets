export const meta = {
  name: 'msm-pe-bls381-dc',
  description: 'Search sweep knobs so the BLS12-381 MSM PE meets DC timing at 1 ns, with the PADD search winner',
  phases: [
    { title: 'Baseline', detail: 'PE sweep from the PADD winner, reuse check, syn' },
    { title: 'Sort', detail: 'group the failing paths' },
    { title: 'Search', detail: 'one lane per failing group, verify, merge' },
    { title: 'Final', detail: 'child check, gls and pwr, summary' },
  ],
}

// args: { deadline: <unix time>, padd_sweep: 'agents/sweeps/<winner>.yaml', padd_period: 1.0 }
if (!args || !args.deadline || !args.padd_sweep) throw new Error('pass args.deadline and args.padd_sweep')
const PADD_PERIOD = args.padd_period || 1.0

const ROOT = '/home/gk2657/cryptolets_alhad_isca27'
const PY = `${ROOT}/.venv/bin/python -m tessera`
const PLAN = 'agents/plans/msm_pe/plan.md'
const PADD_LEARN = 'agents/plans/rcb_padd/learnings_alg7_16cyc.md'
const THREADS = 40
const MAX_FIX_ROUNDS = 3

const RULES = (threads) => `
Context: you work in the Tessera directory ${ROOT}. Run Tessera as \`cd ${ROOT} && ${PY} ...\`.
Read ${PLAN} before you start. For PADD knobs, also read ${PADD_LEARN}. The plan is the authority.

Guardrails (all are hard rules):
1. Edit only files in agents/. Never edit tessera/, kernels/ (kernel.yaml too), reference/, config.yaml or sweeps/.
2. Never edit test or verification files. Never change kernel, test, framework or reference code.
3. Never read or write anything outside ${ROOT}.
4. Do not use git commands.
5. Change only sweep knobs of l3_msm_pe, l2_point_add_rcb and its children: sweep keys, variants, deps, catapult directives, flags.
6. BLS12-381 only, Alg. 7 only, Montgomery only, fixed q, rc and coef. Keep l2_point_add_rcb blackboxed in the PE, and l1_mod_mul, l1_mod_cmul in the PADD.
7. Never use CLUSTER directives, in any form.
8. Do not run past syn unless your task says gls/pwr. Do not rename or delete anything in build/.
9. Threads: you have ${threads}. Catapult runs use -t ${threads} -p 1. DC runs use -t ${threads} -p 5.
10. Never run a design that already has DC results again with --to rtl. Tessera deletes its DC reports.
11. Do not start a PE DC run until its PADD has passed DC alone.
12. Read the deadline (unix time) from agents/deadline.txt before each new candidate. After it, start no new candidates; let running ones finish.
13. A design passes only if Catapult meets timing, DC slack >= 0, and the DC QoR report has no violating path. "slack 0.00 VIOLATED" is a failure.
14. Latency is not a goal. Pass timing first, then minimum area.

Long runs: PE Catapult takes about 1 h 45 min, and DC can take hours. Start each Tessera run in the background with nohup, log to agents/notes/, and poll with short commands (each under 10 minutes).
`

const RESULT = {
  type: 'object',
  properties: {
    pass: { type: 'boolean' },
    sweep: { type: 'string' },
    pe_hash: { type: 'string' },
    padd_hash: { type: 'string' },
    pe_wns: { type: 'number' },
    violating_paths: { type: 'number' },
    pe_dc_area: { type: 'number' },
    padd_passes_alone: { type: 'boolean' },
    notes: { type: 'string' },
  },
  required: ['pass', 'sweep', 'pe_hash', 'padd_hash', 'pe_wns', 'violating_paths', 'pe_dc_area', 'padd_passes_alone', 'notes'],
}

const GROUPS = {
  type: 'object',
  properties: {
    groups: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          name: { type: 'string', enum: ['padd_inside', 'pe_to_padd', 'pe_logic', 'pe_ports'] },
          paths: { type: 'number' },
          worst_slack: { type: 'number' },
          example: { type: 'string' },
        },
        required: ['name', 'paths', 'worst_slack', 'example'],
      },
    },
  },
  required: ['groups'],
}

const VERDICT = {
  type: 'object',
  properties: { pass: { type: 'boolean' }, problems: { type: 'array', items: { type: 'string' } } },
  required: ['pass', 'problems'],
}

const verify = (what, r, phase) => agent(`${RULES(4)}
You are the verifier. Do not trust the claims below; read the Catapult and DC reports yourself under build/.
Check, as in the plan: Catapult meets timing; PE DC WNS >= 0 with no violating path; the PADD (and its children${what === 'final' ? '' : ' if new'}) meets DC alone; the CSV area equals the DC report; the guardrails were obeyed${what === 'final' ? '; GLS passed all samples and the power report exists' : ''}.
Append your result to agents/notes/verify.md (workflow msm_pe, check, PASS/FAIL, problems).
Claim to check (${what}): ${JSON.stringify(r)}`,
  { label: `verify ${what}`, phase, schema: VERDICT, model: 'opus', effort: 'high' })

const LANE_TASK = {
  pe_to_padd: 'Give the PADD a port budget and period inside the PE (deps.l2_point_add_rcb.io_delay > 0, deps.l2_point_add_rcb.period). Each change is a new PADD build: run it to syn alone and make sure it passes before the PE DC run. Retune the PADD children knobs as in the PADD learnings if the new PADD fails.',
  pe_logic: 'Keep the baseline PADD. Change PE Catapult directives (catapult.l3_msm_pe.*, for example CLOCK_OVERHEAD) and flags.syn_passes.',
  pe_ports: 'Keep the baseline PADD. Change PE Catapult directives (catapult.l3_msm_pe.*) and flags.syn_passes for the paths to the PE ports.',
}

// One lane: search, then verify with up to MAX_FIX_ROUNDS fix rounds
async function runLane(group, threads, base) {
  let r = await agent(`${RULES(threads)}
You are MSM search lane "${group.name}". Phase 2 of the plan. The baseline is ${JSON.stringify(base)}.
Failing paths of your group: ${JSON.stringify(group)}.
Task: ${LANE_TASK[group.name]}
Write your sweeps as agents/sweeps/msm_${group.name}_*.yaml, notes to agents/notes/msm_${group.name}.md, and one CSV row per candidate to agents/results/msm_${group.name}.csv.
If no knob fixes your group, stop and write the remaining paths in your notes.
Return the best design (pass=true only if the whole PE passes), or your best attempt with pass=false.`,
    { label: `lane ${group.name}`, phase: 'Search', schema: RESULT, model: 'opus', effort: 'medium' })
  if (!r) return null

  for (let round = 1; round <= MAX_FIX_ROUNDS && r.pass; round++) {
    const v = await verify('lane', { lane: group.name, ...r }, 'Search')
    if (v && v.pass) break
    if (round === MAX_FIX_ROUNDS) { log(`${group.name}: verifier still failing after ${round} rounds`); r.pass = false; break }
    r = await agent(`${RULES(threads)}
You are the fix agent for MSM lane "${group.name}". The verifier found: ${JSON.stringify(v ? v.problems : ['verifier gave no result'])}
Previous result: ${JSON.stringify(r)}
Correct the CSV or notes, or run what is missing, within the guardrails. Return the corrected result.`,
      { label: `fix ${group.name} r${round}`, phase: 'Search', schema: RESULT, model: 'opus', effort: 'medium' }) || r
  }
  return { ...r, lane: group.name }
}

phase('Baseline')
const base = await agent(`${RULES(THREADS)}
You are the setup agent. Write ${args.deadline} as the first line of agents/deadline.txt (keep the comment lines).
Phase 0 of the plan: write agents/sweeps/msm_base.yaml from the PADD winner sweep ${args.padd_sweep}, with deps.l2_point_add_rcb period ${PADD_PERIOD} and io_delay 0 (plan section "Reuse of the PADD build").
Run --to gen and make sure the PADD is reused (already built). Then run --to syn. Record the results in agents/notes/msm_base.md and one line in agents/audit.md.`,
  { label: 'baseline', phase: 'Baseline', schema: RESULT, model: 'sonnet', effort: 'medium' })
if (!base) throw new Error('baseline agent died')
if (base.pass) {
  log('The baseline PE already passes DC; going to the final runs')
}

let best = base.pass ? base : null
let results = []
if (!best) {
  phase('Sort')
  const sorted = await agent(`${RULES(4)}
You are the sorter. Phase 1 of the plan. Read the DC timing reports of PE design ${base.pe_hash} (build/l3_msm_pe/${base.pe_hash}/reports/dc/). Sort the failing paths into the plan groups, as in the plan section "How to read the PE timing report". Write the result to agents/notes/msm_sort.md.`,
    { label: 'sort', phase: 'Sort', schema: GROUPS, model: 'opus', effort: 'medium' })
  const groups = (sorted ? sorted.groups : []).filter(g => g.paths > 0)
  log(`Failing groups: ${groups.map(g => `${g.name} (${g.paths})`).join(', ') || 'none'}`)

  if (groups.some(g => g.name === 'padd_inside')) {
    log('Paths inside the PADD fail: the PADD fails alone. Stopping; go back to the PADD search.')
    return { base, groups, stopped: 'padd_inside' }
  }

  phase('Search')
  const threads = Math.max(5, Math.floor(THREADS / Math.max(1, groups.length)))
  results = (await pipeline(groups, g => runLane(g, threads, base))).filter(Boolean)
  const passing = results.filter(r => r.pass).sort((a, b) => a.pe_dc_area - b.pe_dc_area)
  best = passing[0] || null

  // Each lane fixes only its own group, so the fixes can be needed together
  if (!best && results.length > 1) {
    const merged = await agent(`${RULES(THREADS)}
You are the merge agent. Phase 2 step 6 of the plan. No lane passes alone. Combine the best settings of these lanes into one sweep, agents/sweeps/msm_merge.yaml, and run it to syn.
Lanes: ${JSON.stringify(results)}`,
      { label: 'merge', phase: 'Search', schema: RESULT, model: 'opus', effort: 'medium' })
    if (merged && merged.pass) {
      const v = await verify('lane', { lane: 'merge', ...merged }, 'Search')
      if (v && v.pass) best = merged
    }
  }
}

if (!best) {
  log('No passing PE design; skipping the final runs')
  return { base, results }
}

phase('Final')
const fin = await agent(`${RULES(THREADS)}
You are the final agent. Phase 3 of the plan for PE design ${best.pe_hash} (sweep ${best.sweep}):
1. Build each child of the winner alone with its period and io_delay, to syn, and make sure it passes DC.
2. Run gls and pwr on the PE once.
3. Write agents/results/msm_final.csv and agents/notes/msm_summary.md with the sweep knobs of the winner. Add one line to agents/audit.md.
Winner: ${JSON.stringify(best)}`,
  { label: 'final', phase: 'Final', schema: RESULT, model: 'sonnet', effort: 'medium' })
const fv = fin ? await verify('final', fin, 'Final') : null

return { base, results, best, final: fin, final_verified: !!(fv && fv.pass) }
