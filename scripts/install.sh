#!/usr/bin/env bash
# Install kami-skills on Linux or macOS: symlink every skill into
# ~/.claude/skills and keep the house rules block in ~/.claude/CLAUDE.md
# up to date. Existing real folders with the same name are moved to
# ~/.claude/skills-backup/<timestamp>/, never deleted. Re-run after adding,
# removing or renaming a skill. Pass --dry-run to only print what it would do.
set -euo pipefail

DRY=0; [ "${1:-}" = "--dry-run" ] && DRY=1
REPO="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$HOME/.claude/skills"
BACKUP="$HOME/.claude/skills-backup/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$DEST"

run() { if [ "$DRY" = 1 ]; then echo "[dry-run] $*"; else eval "$@"; fi; }

names=()
for bucket in engineering productivity personal; do
  for dir in "$REPO/skills/$bucket"/*/; do
    [ -f "$dir/SKILL.md" ] || continue
    name="$(basename "$dir")"; src="${dir%/}"; target="$DEST/$name"
    names+=("$name")
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$src" ]; then continue; fi
    if [ -L "$target" ]; then run "rm '$target'"
    elif [ -e "$target" ]; then run "mkdir -p '$BACKUP' && mv '$target' '$BACKUP/$name'"; fi
    run "ln -s '$src' '$target'"; echo "link $name"
  done
done

dupes="$(printf '%s\n' "${names[@]}" | sort | uniq -d)"
[ -z "$dupes" ] || { echo "Duplicate skill names: $dupes" >&2; exit 1; }

for link in "$DEST"/*; do
  [ -L "$link" ] || continue
  case "$(readlink "$link")" in "$REPO"/*) ;; *) continue ;; esac
  name="$(basename "$link")"
  printf '%s\n' "${names[@]}" | grep -qx "$name" || { run "rm '$link'"; echo "remove stale link $name"; }
done

GLOBAL="$HOME/.claude/CLAUDE.md"
BLOCK_FILE="$REPO/global/CLAUDE.md"
if [ "$DRY" = 1 ]; then echo "[dry-run] update house rules in $GLOBAL"; else
  python3 - "$GLOBAL" "$BLOCK_FILE" <<'PY'
import io, os, re, sys
path, block_path = sys.argv[1], sys.argv[2]
block = io.open(block_path, encoding="utf-8").read().rstrip()
cur = io.open(path, encoding="utf-8").read() if os.path.exists(path) else ""
pat = re.compile(r"<!-- kami-skills:start.*?<!-- kami-skills:end -->", re.S)
new = pat.sub(lambda m: block, cur) if pat.search(cur) else ((cur.rstrip() + "\n\n" if cur.strip() else "") + block + "\n")
if new != cur:
    io.open(path, "w", encoding="utf-8").write(new); print("update house rules in", path)
PY
fi

echo "installed ${#names[@]} skills into $DEST"
