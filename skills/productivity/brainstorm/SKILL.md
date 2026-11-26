---
name: brainstorm
description: Generate genuinely different, project-grounded ideas, then let the user pick which to pursue. Use when the user says "Brainstorm", "brainstorm 一下", "發想", "有什麼點子", "還有什麼做法", or asks for options or ideas before deciding.
---

# Brainstorm

Talk to the user in Traditional Chinese. Ideas, labels and the question card are all in Traditional Chinese.

Your first ideas are the most *typical* ones, not the best ones (mode collapse). Asking the same prompt for "more" mostly repeats them. Your own ranking of ideas is close to chance. This skill works around all three: vary the **angle**, not the count; ask for the uncommon tail explicitly; and let the user pick.

## 0. Frame (don't ask the user)

- Write the problem in one sentence, plus the **criteria** a good idea must meet (for example: no extra live-testing cost, fits in one batch). Derive criteria from the conversation, the spec and the project; don't ask for them.
- Read the relevant code, docs and plans first. Every idea must say where it lands in this project.
- Ideas the user already mentioned are **seeds**: label them "你的種子" and carry them through.

## 1. Pick angles

Pick 3 or 4 angles that are independent of each other. Mix kinds:

- **People**: the end user, the operator, the maintainer, someone trying to abuse it
- **Axes**: cheapest, smallest change, biggest effect, a completely different approach
- **Constraints**: no new dependency, frontend only, done in a day

Never use famous-person personas ("what would Steve Jobs do"): the effect is negligible.

## 2. Diverge

For each angle:

1. List 10 one-line titles that are clearly different from each other.
2. Tag each one 常見 / 少見 / 冷門 by how typical you think it is.
3. Add 5 more that are 冷門 and don't repeat anything above.

**Scale.** For an ordinary topic (a small feature, a UI tweak, naming), do every angle yourself in this context. For a big one (a new version's direction, architecture, or the user says "深入 Brainstorm"), give each angle to its own subagent with a fresh context window, briefed with the problem, the criteria and pointers to the files to read. Angles that need heavy repo reading can go to a Codex subagent (see the `codex-subagents` skill). You do steps 0, 3, 4 and 5.

## 3. Converge

1. **Dedupe**: merge ideas that mean the same thing.
2. **Mark the default**: the obvious idea everyone would think of gets labelled "預設方案". Keep it; it is the baseline the others beat or don't.
3. **Filter**: compare pairwise against the criteria and drop the clearly weak ones, one line of reason each. Filter, don't rank: dropping the obviously bad is the only judgement you are reliable at.
4. **Group**: what survives goes into 2 to 4 groups of 2 to 4 ideas each. At least one 冷門 idea must survive somewhere; if none does, say why.

## 4. Present

One line per idea, numbered across groups:

```
3. 計時器剩 5 分鐘時變色提醒 ── 改 TimerBar.svelte｜成本低｜少見
```

Number, what it does, where it lands, cost (低 / 中 / 高), how typical. Under each group heading, one line on what the group has in common.

End with 「我最推 a、b、c」 and one reason each, tied to the criteria. Then list the dropped ideas in one collapsed line each, so the user can rescue one.

## 5. Card

Ask with one question card (`AskUserQuestion`): one question per group, `multiSelect: true`, the group's ideas as options, your recommended ones first with "(Recommended)". The user picks which to pursue.

Stop and wait. Only after the user picks do you research, prototype or plan the chosen ideas. If they pick nothing, ask in one line whether to brainstorm again from different angles.
