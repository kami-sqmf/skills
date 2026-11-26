---
name: explain
description: Explain in depth how something works or why a design is the way it is, without changing anything. Use when the user says "展開說明", "詳細講", "解釋一下", "怎麼運作", "為什麼要這樣", "圖解", "畫給我看", "why X", or asks how a part of the project or plan works.
---

# Explain

Talk to the user in Traditional Chinese, in full sentences, using the project's `GLOSSARY.md` terms where they exist.

An explanation changes nothing. Don't edit code, plans or docs while explaining, even when you spot something worth fixing: mention it in one line at the end instead.

## Shape

Lead with the answer in one sentence. Then pick the shape that fits:

**When there is a plan or prior version** (the user asks about something you or they designed):

1. **原本**: how the original or current version does it.
2. **原計畫**: how the earlier plan meant to do it.
3. **現在**: how the current plan changes it, and why.

**When it's a mechanism** (how a module, library or flow works):

1. **是什麼**: what it is and what it's for.
2. **怎麼運作**: the steps, in order, at the level the user needs.
3. **為什麼這樣設計**: the trade-off it makes, and the alternative it beat.

**When it's a "why X?"**: answer with the **source** (the user's own document said so, or you added it), the **reason**, and the **alternative**. Say plainly which one it is: a rule you added is open to challenge in a way the user's own rule is not.

## Rules

- **Concrete first.** Ground every abstract point in this project's code, files or data: a file path, a real value, a real case.
- **Draw when it's a flow or a structure, and always when the user says "圖解" or "畫給我看".** A sequence of steps, a state machine or a containment hierarchy gets a diagram (inline visual if the harness has one, otherwise a small text diagram). Say in one line what the diagram shows.
- **Mark your sources.** Say which facts you read from the code or docs, and which are your inference.
- **Stop at what was asked.** No unrequested tour of neighbouring parts.
- **No closing question by default.** If the user is still confused they will ask, or use `/wait-what`. The one exception: if explaining surfaced something that is the user's decision (it changes the goal, the scope, or something the user specified), ask it with a question card (`AskUserQuestion`), not a trailing line of text.
