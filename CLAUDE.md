This repo holds the user's agent skills. It started as a fork of mattpocock/skills and no longer tracks upstream. The workflow it implements is described in `docs/kami/WORKFLOW.md`; read it before changing a skill.

Skills live in bucket folders under `skills/`, and all of them are installed:

- `engineering/`: planning, implementation, review and upkeep.
- `productivity/`: interviews, ideas, explanations, writing.
- `personal/`: the user's own skills.

Rules for editing skills here:

- `SKILL.md` bodies are in English; everything the user reads (replies, question cards, plans, reports) is in Traditional Chinese. Every user-facing skill says so near the top, and its `description` carries the Chinese phrases the user actually says.
- The user's global rules are in `global/CLAUDE.md` (decisions split, question cards, commit only on request, no requirements written into the product). Don't repeat them at length in each skill; a skill only spells out what is specific to it.
- When you add, rename or remove a skill: update the bucket `README.md`, the `/which` router (`skills/engineering/which/SKILL.md`) and the skill table in `docs/kami/WORKFLOW.md`, then re-run `scripts/install.ps1` (Windows) or `scripts/install.sh`.
- Every skill that dispatches a subagent says to start it with a fresh context window.
- No em-dashes in English prose; no 破折號 in Chinese prose.
- Keep `LICENSE`: the MIT licence requires keeping the original notice.
