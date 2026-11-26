<#
.SYNOPSIS
  Install kami-skills on Windows: link every skill into ~/.claude/skills and
  keep the house rules block in ~/.claude/CLAUDE.md up to date.

.DESCRIPTION
  - Each skill under skills/engineering, skills/productivity and skills/personal
    becomes a directory junction in ~/.claude/skills (no admin rights needed),
    so `git pull` keeps installed skills current. Re-run after adding, removing
    or renaming a skill.
  - An existing real folder with the same name is moved to
    ~/.claude/skills-backup/<timestamp>/ first, never deleted.
  - Junctions pointing into this repo that no longer match a skill are removed.
  - The block between the kami-skills markers in ~/.claude/CLAUDE.md is replaced
    with global/CLAUDE.md; anything else in that file is left alone.

.EXAMPLE
  pwsh -File scripts/install.ps1
#>
[CmdletBinding()]
param([switch] $DryRun)

$ErrorActionPreference = 'Stop'
$repo = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$dest = Join-Path $HOME '.claude\skills'
$backup = Join-Path $HOME ('.claude\skills-backup\' + (Get-Date -Format 'yyyyMMdd-HHmmss'))
New-Item -ItemType Directory -Force $dest | Out-Null

function Do-Action([string] $what, [scriptblock] $action) {
    if ($DryRun) { Write-Output "[dry-run] $what" } else { & $action; Write-Output $what }
}

# 1. Collect skills.
$skills = foreach ($bucket in 'engineering', 'productivity', 'personal') {
    Get-ChildItem (Join-Path $repo "skills\$bucket") -Directory |
        Where-Object { Test-Path (Join-Path $_.FullName 'SKILL.md') }
}
$names = $skills | ForEach-Object { $_.Name }
$dupes = $names | Group-Object | Where-Object Count -gt 1
if ($dupes) { throw "Duplicate skill names: $($dupes.Name -join ', ')" }

# 2. Link each skill.
foreach ($s in $skills) {
    $target = Join-Path $dest $s.Name
    $item = Get-Item -LiteralPath $target -Force -ErrorAction SilentlyContinue
    if ($item -and $item.LinkType -eq 'Junction' -and $item.Target -eq $s.FullName) { continue }
    if ($item -and $item.LinkType) {
        Do-Action "relink $($s.Name)" { $item.Delete() }
    } elseif ($item) {
        Do-Action "back up existing $($s.Name) -> $backup" {
            New-Item -ItemType Directory -Force $backup | Out-Null
            Move-Item -LiteralPath $target -Destination (Join-Path $backup $s.Name)
        }
    }
    Do-Action "link $($s.Name)" { New-Item -ItemType Junction -Path $target -Target $s.FullName | Out-Null }
}

# 3. Remove stale junctions that point into this repo.
Get-ChildItem $dest -Force | Where-Object { $_.LinkType -eq 'Junction' -and "$($_.Target)".StartsWith($repo) -and $_.Name -notin $names } |
    ForEach-Object { $j = $_; Do-Action "remove stale link $($j.Name)" { $j.Delete() } }

# 4. House rules block in ~/.claude/CLAUDE.md.
$globalFile = Join-Path $HOME '.claude\CLAUDE.md'
$block = (Get-Content -Raw -Encoding utf8 (Join-Path $repo 'global\CLAUDE.md')).TrimEnd()
$current = if (Test-Path $globalFile) { Get-Content -Raw -Encoding utf8 $globalFile } else { '' }
$pattern = '(?s)<!-- kami-skills:start.*?<!-- kami-skills:end -->'
$updated = if ($current -match $pattern) { [regex]::Replace($current, $pattern, [System.Text.RegularExpressions.MatchEvaluator] { $block }) }
           elseif ($current.Trim()) { $current.TrimEnd() + "`n`n" + $block + "`n" }
           else { $block + "`n" }
if ($updated -ne $current) {
    Do-Action "update house rules in $globalFile" { [IO.File]::WriteAllText($globalFile, $updated, [Text.UTF8Encoding]::new($false)) }
}

Write-Output "installed $($skills.Count) skills into $dest"
