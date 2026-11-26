---
name: research
description: Investigate questions against high-trust primary sources with a round of parallel research agents, and capture the findings as cited Markdown files in the repo. Use when the user wants a topic researched, says "深入研究", "調查", "查一下", "分析利弊", "提更好的方式", or when docs, specs, licences, prices or repo facts need gathering before a decision.
---

Talk to the user in Traditional Chinese. You coordinate and synthesise; the research agents do the reading. Start every agent with a fresh context window and run them in the background, so you keep working while they read.

## Plan the round

Split the question into 2 to 6 independent sub-questions and give each to its own agent:

- **Web and documents** (official specs, papers, licences, pricing, API docs, design comparisons): a Claude subagent.
- **The repo and the machine** (which files a change touches, compatibility risk, measuring data, simulators, prototype scripts, real generation comparisons): a Codex subagent in the newest Astra model, read-only (see the `codex-subagents` skill). The project layer (`docs/agents/workflow.md`) may set a different split.

When the round exists to choose between designs (the user challenged a design, or there are competing approaches), split by **constraint** instead of by sub-question: give each agent the same problem and a different constraint ("smallest change", "most flexible", "cheapest to run"), so they come back with genuinely different designs to compare with numbers.

## Every brief has six parts

1. **Shared background**: the files to read first (earlier reports, the plan, related docs) and the decisions already made, one per line.
2. **Read-only rule**: don't change the repo, don't commit, don't build. If a build is truly needed, follow the project layer's rule for it.
3. **Output path and file name**: by default `docs/research/<feature>/<agent>-<NN>-<topic>.md`; scripts in `scripts/`, data in `data/`. Match the repo's own convention if it already has one.
4. **What to measure**: the metrics, sample sizes and control groups. Simulations of at least 10,000 runs report a 95% interval.
5. **Privacy**: the user's private data is summarised as statistics only; quote at most one sentence per passage; keys come only from environment variables.
6. **Report format**: the report's path, plus at most 10 lines of key findings.

Every claim in a report cites the source that owns it (official docs, source code, the spec, a first-party API), never a secondary write-up of it.

## Rounds

Research is rarely one round. Typical triggers:

| Round | Triggered by |
|---|---|
| First | The user hands over raw material or a new topic |
| Second | A `brainstorm` picked directions to look into |
| Third | The user challenged a design (split by constraint, see above) |
| Experiment | There are candidate approaches and the machine is free to run them |

New conditions the user adds mid-round ("test both") join the running round; don't restart it.

## After each round

1. Update the plan: the research index (each report's path and a one-line conclusion) and any decision the findings change.
2. Reply with: the conclusion (「維持」 or 「改成 X」, with the numbers behind it), what changed in the plan, and at most one thing the user needs to do.

If the research needs something only the user can provide (a form-gated download, an account), open the reply with exactly what to do and the path to put it in, say what it will and won't prove once you have it, and carry on with everything else.
