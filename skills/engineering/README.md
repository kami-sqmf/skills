# Engineering

整個流程見 [docs/kami/WORKFLOW.md](../../docs/kami/WORKFLOW.md)。

## User-invoked

- **[health-check](./health-check/SKILL.md)**: Scan a codebase for deepening opportunities, present them as a visual HTML report, then interview through whichever one the user picks. Never changes code.
- **[implement](./implement/SKILL.md)**: Implement one ticket or a small piece of work from a plan, in this context window, driving tdd and closing with /plan-review and a results report.
- **[implement-plan](./implement-plan/SKILL.md)**: Implement a whole plan from /to-plan and /to-batches in one run: batch by batch, parallel implementer subagents across the ready tickets, a capped review, checks and live tests, and an HTML results report after every batch.
- **[retro](./retro/SKILL.md)**: Conduct a retrospective on a coding session.
- **[setup-project](./setup-project/SKILL.md)**: Decide this project's layer the first time the agent works in it: where plans and tickets live, the check commands, how live testing works, how deployment works, and which agents do what. Writes docs/agents/ and an Agent skills block in CLAUDE.md.
- **[to-batches](./to-batches/SKILL.md)**: Break a plan into ordered batches of tracer-bullet tickets, each declaring the tickets that block it, written to docs/plans/<feature>/tickets/ (or a real tracker if the project uses one).
- **[to-plan](./to-plan/SKILL.md)**: Turn the current conversation, research and decisions into a plan document at docs/plans/<feature>/plan.md: no interview, just synthesis of what has already been discussed.
- **[triage](./triage/SKILL.md)**: Move issues and external PRs through a state machine of triage roles, categorise, verify, grill if needed, and write agent-ready briefs.
- **[wayfinder](./wayfinder/SKILL.md)**: Plan a huge chunk of work (more than one agent session can hold) as a shared map of decision tickets on your issue tracker, and resolve them one at a time until the way to the destination is clear.
- **[which](./which/SKILL.md)**: Ask which skill or flow fits your situation right now. A router over the user's skills, organised by the four parts of the workflow.

## Model-invoked

- **[codebase-design](./codebase-design/SKILL.md)**: Shared vocabulary for designing deep modules.
- **[diagnosing-bugs](./diagnosing-bugs/SKILL.md)**: Diagnosis loop for hard bugs and performance regressions.
- **[domain-modeling](./domain-modeling/SKILL.md)**: Build and sharpen a project's domain model.
- **[expand-states](./expand-states/SKILL.md)**: Before implementation, list every situation each feature in a plan will meet, how to detect it, what the app does and how it falls back, and pair each situation with a test or offline fixture.
- **[plan-review](./plan-review/SKILL.md)**: Review a batch of changes against the plan and the repo's standards without endless fix loops: one agent finds issues along two axes (follows the standards, follows the plan), a second judges each finding into 必修 / 建議 / 小毛病, and only 必修 blocks.
- **[pr](./pr/SKILL.md)**: Use when writing a PR body.
- **[prototype](./prototype/SKILL.md)**: Build a throwaway prototype to answer a design question.
- **[research](./research/SKILL.md)**: Investigate questions against high-trust primary sources with a round of parallel research agents, and capture the findings as cited Markdown files in the repo.
- **[tdd](./tdd/SKILL.md)**: Test-driven development.
- **[wizard](./wizard/SKILL.md)**: Generate an interactive bash wizard that walks a human through steps only they can perform.
