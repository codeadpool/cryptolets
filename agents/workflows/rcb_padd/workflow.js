export const meta = {
  name: 'rcb-padd-bls381-16cyc',
  description: 'Search sweep knobs for a small BLS12-381 Alg. 7 PADD at 15-17 cycles that meets DC timing at 1 ns',
  phases: [
    { title: 'Setup', detail: 'write the starting sweeps, smoke runs to rtl' },
    { title: 'Search', detail: 'one lane per start point, then verify and check the children' },
    { title: 'Final', detail: 'gls and pwr on the winner, summary' },
  ],
}

// args: { deadline: <unix time> }. Pass start + 24 h, since the script cannot read the clock.
if (!args || !args.deadline) throw new Error('pass args.deadline as a unix time')

const ROOT = '/home/gk2657/cryptolets_alhad_isca27'
const PY = `${ROOT}/.venv/bin/python -m tessera`
const PLAN = 'agents/plans/rcb_padd/plan.md'
const LEARN = 'agents/plans/rcb_padd/learnings_alg7_16cyc.md'
const MAX_FIX_ROUNDS = 3

const LANES = [
  { name: 'nor381', start: 'mul_nor width 381, dep_period_ratio 0.85, dep_io_ratio 0.7, child io_delay 0.78, child CLOCK_OVERHEAD 0. Catapult scheduled this at 16 cycles; DC was never run.' },
  { name: 'kar48', start: 'mul_kar, base_mul_width 48, kar_base_mul_width 48, dep_period_ratio 0.9, dep_io_ratio 0.7, child io_delay 0.83, child CLOCK_OVERHEAD 0. This met DC at 15 cycles with the smallest area near 16 cycles.' },
]

const RULES = `
Context: you work in the Tessera directory ${ROOT}. Run Tessera as \`cd ${ROOT} && ${PY} ...\`.
Read ${PLAN} and ${LEARN} before you start. The plan is the authority.

Guardrails (all are hard rules):
1. Edit only files in agents/. Never edit tessera/, kernels/, reference/, config.yaml or sweeps/.
2. Never edit test or verification files.
3. Never read or write anything outside ${ROOT}.
4. Do not use git commands.
5. Change only sweep knobs: sweep keys, variants, deps, catapult directives, flags.
6. BLS12-381 only, Alg. 7 only, Montgomery only, fixed q, rc and coef (coef_type: fixed_coef, so the PE can reuse the PADD build). Plain modmul and cmul children.
7. Keep l1_mod_mul and l1_mod_cmul blackboxed in the PADD.
8. Never use CLUSTER directives, in any form.
9. Do not run past syn unless your task says gls/pwr.
10. Threads: each lane has 20. Catapult runs use -t 20 -p 1. DC runs use -t 20 -p 5.
11. Never run a design that already has DC results again with --to rtl. Tessera deletes its DC reports.
12. Do not delete builds.
13. Read the deadline (unix time) from agents/deadline.txt before each new candidate. After it, start no new candidates; let running ones finish.
14. A design passes only if Catapult meets timing, DC slack >= 0, and the DC QoR report has no violating path. "slack 0.00 VIOLATED" is a failure.

Long runs: DC can take hours. Start each Tessera run in the background with nohup, log to agents/notes/, and poll with short commands (each under 10 minutes).
`

const RESULT = {
  type: 'object',
  properties: {
    pass: { type: 'boolean' },
    sweep: { type: 'string', description: 'path of the sweep file of the best design' },
    design_hash: { type: 'string' },
    cycles: { type: 'number' },
    dc_area: { type: 'number' },
    wns: { type: 'number' },
    violating_paths: { type: 'number' },
    notes: { type: 'string' },
  },
  required: ['pass', 'sweep', 'design_hash', 'cycles', 'dc_area', 'wns', 'violating_paths', 'notes'],
}

const VERDICT = {
  type: 'object',
  properties: {
    pass: { type: 'boolean' },
    problems: { type: 'array', items: { type: 'string' } },
  },
  required: ['pass', 'problems'],
}

const verify = (what, r, phase) => agent(`${RULES}
You are the verifier. Do not trust the claims below; read the Catapult and DC reports yourself under build/.
Check, as in the plan: latency 15-17 and equal to the CSV; Catapult meets timing; DC WNS >= 0 with no violating path; the CSV area equals the DC report; the guardrails were obeyed${what === 'final' ? '; GLS passed all samples and the power report exists' : ''}${what === 'children' ? '; the l1_mod_mul and l1_mod_cmul of this design, built alone, meet DC timing' : ''}.
Append your result to agents/notes/verify.md (lane, check, PASS/FAIL, problems).
Claim to check (${what}): ${JSON.stringify(r)}`,
  { label: `verify ${what}`, phase, schema: VERDICT, model: 'opus', effort: 'high' })

// One lane: search, then verify with up to MAX_FIX_ROUNDS fix rounds, then the child check
async function runLane(lane) {
  let r = await agent(`${RULES}
You are search lane "${lane.name}". Start: ${lane.start}
Follow Phase 1 of the plan. Write your sweeps as agents/sweeps/${lane.name}_*.yaml, your notes to agents/notes/${lane.name}.md, and one CSV row per candidate to agents/results/${lane.name}.csv.
Return the best passing design (smallest DC area at 15-17 cycles), or your best attempt with pass=false.`,
    { label: `lane ${lane.name}`, phase: 'Search', schema: RESULT, model: 'opus', effort: 'medium' })
  if (!r) return null

  for (let round = 1; round <= MAX_FIX_ROUNDS; round++) {
    const v = await verify('lane', { lane: lane.name, ...r }, 'Search')
    if (v && v.pass) break
    if (round === MAX_FIX_ROUNDS) { log(`${lane.name}: verifier still failing after ${round} rounds; keeping best result`); r.pass = false; break }
    r = await agent(`${RULES}
You are the fix agent for lane "${lane.name}". The verifier found these problems: ${JSON.stringify(v ? v.problems : ['verifier gave no result'])}
Previous result: ${JSON.stringify(r)}
Correct the CSV or notes, or run what is missing, within the guardrails. Return the corrected result.`,
      { label: `fix ${lane.name} r${round}`, phase: 'Search', schema: RESULT, model: 'opus', effort: 'medium' }) || r
  }
  if (!r.pass) return r

  const c = await agent(`${RULES}
You are the child check for lane "${lane.name}". Follow Phase 2 of the plan for design ${r.design_hash} (sweep ${r.sweep}).
Write the child sweeps as agents/sweeps/${lane.name}_child_*.yaml and notes to agents/notes/${lane.name}_child.md.
Return the PADD result with pass=true only if both children meet DC timing alone; put the child WNS and violating paths in notes.`,
    { label: `children ${lane.name}`, phase: 'Search', schema: RESULT, model: 'sonnet', effort: 'medium' })
  const cv = c ? await verify('children', { lane: lane.name, ...c }, 'Search') : null
  return { ...r, lane: lane.name, pass: !!(c && c.pass && cv && cv.pass), child_notes: c ? c.notes : 'child check died' }
}

phase('Setup')
await agent(`${RULES}
You are the setup agent. Write ${args.deadline} as the first line of agents/deadline.txt (keep the comment lines).
The starting sweeps already exist: agents/sweeps/<lane>_start.yaml, one design each. Do not change them.
Run each to --to rtl (Phase 0), the two lanes in parallel with -t 20 -p 1 each. Record the result in agents/audit.md, one line each.
Lanes: ${JSON.stringify(LANES)}`,
  { label: 'setup', phase: 'Setup', model: 'sonnet', effort: 'low' })

phase('Search')
const results = (await pipeline(LANES, runLane)).filter(Boolean)

phase('Final')
const passing = results.filter(r => r.pass).sort((a, b) => a.dc_area - b.dc_area)
if (!passing.length) {
  log('No lane produced a passing design; skipping the final runs')
  return { results }
}
// Within 1% of the smallest area, a 16-cycle design wins
const best = passing.find(r => r.cycles === 16 && r.dc_area <= passing[0].dc_area * 1.01) || passing[0]

const fin = await agent(`${RULES}
You are the final agent. Follow Phase 3 of the plan for design ${best.design_hash} (sweep ${best.sweep}): run gls and pwr once, then write agents/results/final.csv and agents/notes/summary.md with the sweep knobs of the winner. Add one line to agents/audit.md.
Winner: ${JSON.stringify(best)}`,
  { label: 'final', phase: 'Final', schema: RESULT, model: 'sonnet', effort: 'medium' })
const fv = fin ? await verify('final', fin, 'Final') : null

return { results, best, final: fin, final_verified: !!(fv && fv.pass) }
