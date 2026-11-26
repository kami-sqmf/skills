---
name: plan-review
description: "Review a batch of changes against the plan and the repo's standards without endless fix loops: one agent finds issues along two axes (follows the standards, follows the plan), a second judges each finding into 必修 / 建議 / 小毛病, and only 必修 blocks. Use when the user types /plan-review, says \"審核\", \"對照計畫審查\", or when /implement or /implement-plan reaches its review step."
---

Talk to the user in Traditional Chinese.

Review the diff between `HEAD` and a fixed point. The review must end: a careful reviewer always finds something, so finding and judging are split, only 必修 blocks, and re-review is capped.

## 1. Pin the scope

- **Fixed point**: whatever the user or the calling skill said (a commit, branch, tag, `main`). If none was given, use the start of the current batch; ask only if that can't be determined.
- Capture `git diff <fixed-point>...HEAD` and `git log <fixed-point>..HEAD --oneline` once. Confirm the ref resolves and the diff is non-empty before going further.
- **The plan**: `docs/plans/<feature>/plan.md`, the batch's tickets, and the plan's 驗收指標. If there is no plan, the plan axis reports "no plan available".
- **Out of scope**: anything outside this batch's diff and acceptance criteria goes on the 「下次再說」 list, not into this review.

## 2. Gather the standards

Search the repo for every file that documents how code should be written (`CODING_STANDARDS.md`, `CONTRIBUTING.md`, `CLAUDE.md`, `AGENTS.md`, lint configs' comments). These are the standards axis's sources.

On top of whatever the repo documents, the Standards axis always carries the **smell baseline** below: a fixed set of Fowler code smells (_Refactoring_, ch.3) that applies even when a repo documents nothing. Two rules bind it:

- **The repo overrides.** A documented repo standard always wins; where it endorses something the baseline would flag, suppress the smell.
- **Always a judgement call.** Each smell is a labelled heuristic ("possible Feature Envy"), never a hard violation. Like any standard here, skip anything tooling already enforces.

Each smell reads *what it is* → *how to fix*; match it against the diff:

- **Mysterious Name**: a function, variable, or type whose name doesn't reveal what it does or holds. → rename it; if no honest name comes, the design's murky.
- **Duplicated Code**: the same logic shape appears in more than one hunk or file in the change. → extract the shared shape, call it from both.
- **Feature Envy**: a method that reaches into another object's data more than its own. → move the method onto the data it envies.
- **Data Clumps**: the same few fields or params keep travelling together (a type wanting to be born). → bundle them into one type, pass that.
- **Primitive Obsession**: a primitive or string standing in for a domain concept that deserves its own type. → give the concept its own small type.
- **Repeated Switches**: the same `switch`/`if`-cascade on the same type recurs across the change. → replace with polymorphism, or one map both sites share.
- **Shotgun Surgery**: one logical change forces scattered edits across many files in the diff. → gather what changes together into one module.
- **Divergent Change**: one file or module is edited for several unrelated reasons. → split so each module changes for one reason.
- **Speculative Generality**: abstraction, parameters, or hooks added for needs the spec doesn't have. → delete it; inline back until a real need shows.
- **Message Chains**: long `a.b().c().d()` navigation the caller shouldn't depend on. → hide the walk behind one method on the first object.
- **Middle Man**: a class or function that mostly just delegates onward. → cut it, call the real target direct.
- **Refused Bequest**: a subclass or implementer that ignores or overrides most of what it inherits. → drop the inheritance, use composition.

One more standard always applies, whatever the repo says: **the user's requirements and boundaries never appear in the product**. UI text, user-facing docs and code comments describe the product only; anything that relays the conversation ("as requested, X is disabled", "note: this must not…", `// user asked for green`) is a finding, and always 必修.

## 3. Find (one agent)

Dispatch one finder with a fresh context window: by default a Codex subagent in the newest Astra model, read-only (see `codex-subagents`). The project layer (`docs/agents/workflow.md`) may name a different finder.

Its brief carries: the diff command and commit list, the standards files, the smell baseline above pasted in full, the plan and tickets paths, and the focus areas (never your own conclusions). It reports every finding with:

- **Axis**: 規範 (violates a documented standard or a baseline smell) or 計畫 (missing or partial requirement, behaviour nobody asked for, or a requirement implemented wrongly). Quote the standard or the plan line.
- **Where**: file and hunk.
- **Failure scenario**: the concrete input or state that leads to the wrong result. A finding with no scenario is still reported, marked "no scenario".

## 4. Judge (a second agent)

Dispatch a judge with a fresh context window: by default a Claude subagent on the Fable model. It gets the finder's report, the diff, the plan and the severity table, and for each finding it checks that the problem really exists in the code, then assigns one level:

| 級別 | 什麼算 | 怎麼處理 |
|---|---|---|
| 必修 | It breaks; it violates the plan; data loss; a security problem; the user's requirements written into the product | Fixed in this batch |
| 建議 | Better quality, but nothing breaks | Fix only if it's a one-line change in code already being touched; never blocks |
| 小毛病 | Naming, style, personal preference | Not fixed; recorded |

Findings with no failure scenario are at most 建議. Findings the judge can't reproduce in the code are dropped, with a one-line reason.

## 5. Fix and re-review

1. Fix only the 必修 findings (yourself, or one implementer subagent briefed with just those findings).
2. Re-review **only what the fixes changed**, with the same find-then-judge pair.
3. At most **2 rounds**. If round 2 still has 必修, stop and ask the user on one question card: fix further, accept as is, or move it to the next batch.

## 6. Report

- 必修: how many, all fixed or not.
- 建議 and 小毛病: how many, and where they were recorded (the plan's 未決事項 or the batch record), so `/retro` can turn recurring ones into standards or automated checks.
- 「下次再說」: what was out of scope.

Keep the two axes separate in the report: code that follows every standard can still implement the wrong thing, and the reverse. Don't let one axis mask the other.
