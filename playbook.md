# Playbook: agent-driven design search with Tessera

This playbook tells you how to set up a multi-agent design search in a Tessera directory. It works for any kernel. The first use was SW PADDs and modular multipliers on BN254 and BLS12-381 (see `plans/plan.md`).

The method is simple. Agents change only sweep knobs. They screen designs with Catapult and confirm them with DC. A strong verifier checks every winner before the next phase starts.

## 1. Set up the folder

Make an `agents/` folder at the root of the Tessera directory. Keep all AI files in it.

| Path | Contents |
|---|---|
| `README.md` | Index of the folder and the scope of the experiment |
| `audit.md` | Log of decisions, one line each, with the date |
| `learnings.md` | Knob hints for your kernels. These are directions, not targets. |
| `plans/plan.md` | The plan (template in section 2) |
| `sweeps/` | All sweep files that the agents write |
| `results/` | One CSV for each lane, and the final CSV |
| `notes/` | One notes file for each lane, and `verify.md` |
| `workflows/<name>/workflow.js` | The workflow script |

## 2. Write the plan

Keep the plan short and high level. Let the agents find the details. The plan has these parts.

1. **Goal table.** Write one row for each final design: kernel, parameters (for example the field), and the goal.
   - Write the goal as a rule that a script can check. Examples: "exactly 27 cycles, then minimum DC area", "minimum latency", "minimum area at 8 cycles or less".
2. **Common settings.** Technology, clock period, II, and any fixed parameter choices.
3. **Inputs.** The starting sweeps, `learnings.md`, and the Catapult reference, if you have one.
4. **Phases.** Use the phase list in section 3.
5. **Agents.** Use the table in section 4.
6. **Guardrails.** Use the list in section 5.

## 3. Phases

1. **Setup.** Copy the starting sweeps into `agents/sweeps/`, one for each target. Run each with one design to `--to rtl`. This makes sure that every sweep loads.
2. **Search lanes.** Run one lane for each target, in parallel. Each lane does these steps:
   1. Screen candidates with Catapult only (`--to rtl`).
   2. Send to DC (`--to syn`) only the candidates that meet the goal and look better than the best result.
   3. Change one knob per candidate, so that you know which knob gave the gain.
   4. Record each candidate in the lane CSV: knobs, cycles, Catapult area, DC area, slack, pass or fail.
   5. Stop after 3 rounds with no gain of more than 1%, or at the deadline.
3. **Dependent lanes (optional).** Use these when a target comes from another winner. An example is a modmul latency that comes from the modmul inside a PADD. Start them only after the verifier passes the winner that they depend on.
4. **Final runs.** Run each final design through `gls` and `pwr` one time only. Write `results/final.csv` and `notes/summary.md`.

After each search phase and after the final runs, the verifier checks the winners (section 4).

## 4. Agents

| Agent | Model | Effort | Job |
|---|---|---|---|
| setup | Sonnet | low | Write the sweep files. Do the smoke runs. |
| lane (one for each target) | Opus | medium | Search for one target |
| verifier | Opus | high | Check each winner against its reports |
| final | Sonnet | medium | Do the final `gls`/`pwr` runs. Write the summary. |

The verifier reads the Catapult and DC reports itself. It does not trust the lane. It checks these items:

1. The latency in the Catapult report meets the goal.
2. Catapult meets timing, and the DC slack is 0 or more.
3. The area in the CSV matches the DC report.
4. For the final designs, GLS passes all samples and the power report exists.
5. The lane obeyed the guardrails.

If a check fails, the verifier writes the problem to `notes/verify.md`. A fix agent then corrects it, and the verifier checks again. Allow a maximum of 3 rounds. After that, the workflow continues with the best result and records the problem. It never stops at a gate.

## 5. Guardrails

Put these rules in the prompt of each agent.

1. Edit only files in `agents/`. Never edit the framework, the kernel code, or the configuration file.
2. Never edit the test or verification files.
3. Never read or write anything outside the Tessera directory.
4. Do not use git commands.
5. Change only sweep knobs: sweep keys, `deps`, `catapult` directives, and `flags`.
6. Do not run past `syn` during the search. Only the final designs go to `gls` and `pwr`, because GLS writes very large VCD files.
7. Obey the thread budget. Catapult uses 1 thread for each run. DC uses about 8 (`-p 8`). Divide the total budget between the parallel lanes.
8. A design passes only if Catapult meets timing and DC slack is 0 or more. "0.00 VIOLATED" is a failure.
9. Do not delete builds that another lane uses.
10. Obey the time guard. After the deadline, start no new candidates. Let the runs in progress finish.

Add guardrails for your own kernels. Examples from the first run: "Montgomery reduction only" and "no `CLUSTER` directives".

## 6. Lessons from the first run

1. **Rank on DC, not Catapult.** Catapult area was about 2 times the DC area for the modmul. Use Catapult only to screen.
2. **Check blackboxed children alone.** A child can pass inside its parent but fail DC when you build it alone. Build each child alone and run DC on it before you accept the parent.
3. **Near misses are common.** Many designs failed DC by 0.01 ns or less. Run DC again with more `syn_passes` before you change the design. For a large design, each pass can take more than one hour.
4. **Do not re-run a built design with `--to rtl`.** Tessera runs Catapult again and deletes the DC reports of that design.
5. **Plan for long DC runs.** DC took 40 to 60 minutes for a 1M µm² design and about 2 hours for a 1.9M µm² design, for each pass. Set the deadline with this in mind.
6. **Keep the deadline in a file.** If the prompt holds the deadline, you cannot change it while agents run. Tell the agents to read the deadline from a file, for example `agents/deadline.txt`.
7. **Be careful when you resume a workflow.** The resume uses cached results only for the agent calls that come before the first changed call. If parallel lanes call agents in a different order, finished agents can run again. Pass finished results in through `args` to prevent this.
8. **Agents can break guardrails.** In the first run, the setup agent read a directory outside the Tessera directory. The verifier checks the guardrails, but it is better to state each rule clearly in each prompt.

## 7. Start a new search

1. Make the `agents/` folder (section 1).
2. Write `learnings.md` with the hints that you have for your kernels. It can be empty.
3. Write `plans/plan.md` (section 2). Fill in the goal table, the thread budget, and the deadline.
4. Copy `workflows/padd_mmul/workflow.js` from the first run and change the lanes and targets.
5. Read the plan and the script one more time. Then start the workflow.
