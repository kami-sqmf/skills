---
name: implement
description: "Implement one ticket or a small piece of work from a plan, in this context window, driving tdd and closing with /plan-review and a results report. Use when the user types /implement, says \"做這張工單\", \"實作這個\", or passes a single ticket."
disable-model-invocation: true
---

Talk to the user in Traditional Chinese.

Implement the work the user described, or the ticket they passed. If they passed a ticket reference, read it (and its plan) and state its title before starting. If the reference is ambiguous, ask.

1. **Contract.** If the work changes shared types or interfaces, change those first yourself.
2. **Build.** Call the Skill tool with "tdd". Its seams are the situations listed for this ticket in the plan's 狀態展開. Run type checks and single test files regularly, and the full suite once at the end.
3. **Review.** Call the Skill tool with "plan-review", fixed point = where this work started.
4. **Check and live-test** with the commands and method in the project layer (`docs/agents/workflow.md`), if it defines them.
5. **Report.** Write the results report described in `implement-plan` (step "Results report") for this one piece of work, and record it in the plan.

Do not commit or push unless the user asks. When they ask, commit to the current branch.
