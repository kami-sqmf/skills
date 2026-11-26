# kami-skills

我的 agent 工作流，從 [mattpocock/skills](https://github.com/mattpocock/skills) fork 出來改寫。

- **整個流程**：[docs/kami/WORKFLOW.md](docs/kami/WORKFLOW.md)
- **不知道用哪個指令**：在 Claude Code 打 `/which`
- **全域規則**（語言、提問卡、什麼要問我、要求不寫進產品）：[global/CLAUDE.md](global/CLAUDE.md)，安裝時會寫進 `~/.claude/CLAUDE.md`

## 四大塊

| 大塊 | 指令 |
|---|---|
| 1. 規劃（研究、解釋） | `/askme`、`brainstorm`、`explain`、`research`、`/to-plan`、`/expand-states`、`/to-batches` |
| 2. 審查 | `/plan-review` |
| 3. 實作成果 | `/implement-plan`、`/implement` |
| 4. 下次如何改進 | `/retro`、`/health-check` |

第一次在某個專案用：`/setup-project`。

## 安裝（每台機器各做一次，之後自動更新）

這個 repo 本身就是一個公開的 plugin 市集，任何機器都能直接加入，不需要登入 GitHub。

**Claude Code**（Windows、SSH 主機、Mac 都一樣）：

```
claude plugin marketplace add kami-sqmf/skills
claude plugin install kami@kami
```

桌面版也可以在「新增市集」填 `kami-sqmf/skills`。plugin 會在每次開新對話時載入全域規則（`global/CLAUDE.md`）。

**Codex**：

```
codex plugin marketplace add kami-sqmf/skills
codex plugin add kami@kami
```

更新：Claude Code 會自動更新；Codex 跑 `codex plugin marketplace upgrade`。只有 `.claude-plugin/plugin.json` 的版本號變了才會更新。

**不想用 plugin 的機器**：改跑 `scripts/install.ps1`（Windows）或 `scripts/install.sh`（Linux、macOS），用連結的方式裝進 `~/.claude/skills`，並把全域規則寫進 `~/.claude/CLAUDE.md`。兩種方式擇一，不要同時用，否則每個 skill 會出現兩次。

## 來源

最初 fork 自 [mattpocock/skills](https://github.com/mattpocock/skills)（MIT 授權，見 `LICENSE`），之後不再同步上游。
