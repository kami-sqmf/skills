---
name: which
description: Ask which skill or flow fits your situation right now. A router over the user's skills, organised by the four parts of the workflow. Use when the user types /which or says "我該用哪個", "下一步要做什麼", "用哪個 skill".
disable-model-invocation: true
---

# Which

Talk to the user in Traditional Chinese. Answer with the one or two commands that fit, why, and what the user will see. Before stating what a skill does or recommending a step be skipped, read that skill's SKILL.md: the map below is for orientation only.

The user cares about four parts. Technical details (tests, git, worktrees, check commands) run in the background and never need routing.

## 1. 規劃（研究、解釋）

The main road from an idea to a buildable plan. Keep these steps in **one unbroken context window** (no `/compact` before `/to-batches` finishes), so the interview, research, plan and batches build on the same thinking.

1. **`/askme`**: the question-card interview. Only decisions that are the user's get a card; technical trade-offs are decided and listed. Inside a project it also writes `GLOSSARY.md` and ADRs.
2. **`research`**: a round of parallel research agents writing cited reports to `docs/research/<feature>/`. Comes back for more rounds when the user brainstorms, challenges a design, or the machine is free for experiments.
3. **`/to-plan`**: writes `docs/plans/<feature>/plan.md` (8 sections). For a big build it runs **`/health-check`** on the affected area first.
4. **`/expand-states`**: every situation each feature will meet, each paired with a test or offline fixture.
5. **`/to-batches`**: tickets grouped into ordered batches, each ticket declaring what blocks it.

Around the main road:

- **`brainstorm`**: genuinely different ideas from several angles, picked on a card. Feeds research.
- **`explain`**: in-depth explanation of how something works or why it's designed that way; draws diagrams on request. Changes nothing.
- **`prototype`**: a throwaway program for a design question that talk can't settle (state logic, or a UI you have to see).
- **`/wayfinder`**: for an effort too big and foggy for one session. Charts decision tickets and resolves them one by one, then hands off to `/to-plan`.
- **`/to-questionnaire`**: when the missing answer is in someone else's head; writes them a questionnaire.

## 2. 審查

- **`/plan-review`**: one agent finds issues (follows the standards, follows the plan), a second judges them into 必修 / 建議 / 小毛病. Only 必修 is fixed; at most 2 rounds, then a card. `/implement` and `/implement-plan` run it for you.

## 3. 實作成果

- **`/implement-plan`**: the whole plan in one command, batch by batch (contract, implement, review, check, live test), with an HTML results report after every batch.
- **`/implement`**: one ticket or a small piece of work in this window, same steps, same report.

## 4. 下次如何改進

- **`/retro`**: after a build, especially one that went sideways. Writes memory and live-testing notes itself, then suggests changes to the agent's environment (checks, standards, steering files) for the user to pick.
- **`/health-check`**: a visual HTML report of where the code could be made deeper and easier to change. Picking one starts an `/askme` interview.

## Other starting points

- **Something is broken and resists a first look** → **`diagnosing-bugs`**: builds a command that goes red on this bug before any theory, then fixes with a regression test. Follow with `/retro`.
- **Issues someone else opened** → **`/triage`**.
- **A message from the agent didn't land** → **`/wait-what`**: re-explains in plain words with the glossary's terms.
- **Learning a concept over several sessions** → **`/teach`**.
- **Writing an article** → **`writing-fragments`** to mine raw material, then **`writing-shape`** (paragraph by paragraph) or **`writing-beats`** (beat by beat).
- **A step only a human can do** (credentials, DNS, a third-party dashboard) → **`wizard`**.

## Between phases

At a boundary between phases, in this order of preference: continue; `/clear` when nothing here matters next; **`/handoff`** to move to another tool, folder or person; a subagent for a tightly scoped task; `/compact` when the window is getting long (around 150k tokens). See [PHASE-BOUNDARIES.md](PHASE-BOUNDARIES.md).

## First time in a project

**`/setup-project`**: decides the project layer (tracker, checks, live testing, deployment, which agents do what) and writes it to `docs/agents/`.
