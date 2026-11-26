<#
.SYNOPSIS
  Run one OpenAI Codex CLI subagent (`codex exec`) on Windows.

.DESCRIPTION
  - Picks the model by role (sol / astra / terra / luna) and resolves the newest
    listed model of that family from ~/.codex/models_cache.json, so the skill
    never goes stale when Codex ships a new generation. -Model overrides this.
  - Resolves codex.exe fresh from the Microsoft Store package every run (the Store
    auto-updates and deletes old versioned folders, so a cached path goes stale).
  - Feeds the brief file on stdin as raw bytes (no PowerShell 5.1 quoting or
    encoding damage to multi-line / Chinese briefs).
  - Captures stdout+stderr to a log and the agent's final message to -Report.
  - Adds --skip-git-repo-check automatically when -Dir is not inside a git repo.
  - Afterwards lists any %TEMP%\codex-security-artifacts-* folders the run created.

  Run it in the background (run_in_background) and wait for the completion
  notification; do not poll.

.EXAMPLE
  & "$HOME\.claude\skills\codex-subagents\scripts\Invoke-Codex.ps1" `
      -Brief D:\work\briefs\impl-a.md -Dir D:\repo -Report D:\work\reports\impl-a.md

.EXAMPLE
  # Independent read-only review with the newest Astra
  & "$HOME\.claude\skills\codex-subagents\scripts\Invoke-Codex.ps1" `
      -Brief review.md -Dir D:\repo -Report review-report.md -Role astra -Sandbox read-only

.EXAMPLE
  # Only print which model each role resolves to, then exit
  & "$HOME\.claude\skills\codex-subagents\scripts\Invoke-Codex.ps1" -ListModels
#>
[CmdletBinding(DefaultParameterSetName = 'Run')]
param(
    [Parameter(Mandatory, ParameterSetName = 'Run')] [string] $Brief,
    [Parameter(Mandatory, ParameterSetName = 'Run')] [string] $Dir,
    [Parameter(Mandatory, ParameterSetName = 'Run')] [string] $Report,
    [Parameter(ParameterSetName = 'Run')] [ValidateSet('sol', 'astra', 'terra', 'luna')] [string] $Role = 'sol',
    [Parameter(ParameterSetName = 'Run')] [string] $Model,
    [Parameter(ParameterSetName = 'Run')] [ValidateSet('read-only', 'workspace-write')] [string] $Sandbox = 'workspace-write',
    [Parameter(ParameterSetName = 'Run')] [ValidateSet('low', 'medium', 'high', 'xhigh', 'max', 'ultra')] [string] $Effort = 'high',
    [Parameter(ParameterSetName = 'Run')] [string] $Log,
    [Parameter(ParameterSetName = 'Run')] [switch] $Fast,
    [Parameter(ParameterSetName = 'Run')] [string[]] $AddDir = @(),
    [Parameter(ParameterSetName = 'Run')] [string[]] $ExtraConfig = @(),
    [Parameter(Mandatory, ParameterSetName = 'List')] [switch] $ListModels
)

$ErrorActionPreference = 'Stop'

# Used only when models_cache.json is missing or unreadable. Last checked 2026-11-27.
$fallback = @{ sol = 'gpt-6.2-sol'; astra = 'gpt-6.2-astra'; terra = 'gpt-6.1-terra'; luna = 'gpt-6-luna' }

function Resolve-RoleModel([string] $role) {
    $cache = Join-Path $HOME '.codex\models_cache.json'
    try {
        $models = (Get-Content -Raw -Encoding utf8 $cache | ConvertFrom-Json).models
        $best = $models |
            Where-Object { $_.visibility -eq 'list' -and $_.slug -match "^gpt-(\d+(?:\.\d+)?)-$role$" } |
            Sort-Object { [version]($_.slug -replace "^gpt-(\d+(?:\.\d+)?)-$role$", '$1' -replace '^(\d+)$', '$1.0') } -Descending |
            Select-Object -First 1
        if ($best) { return $best.slug }
    } catch { }
    return $fallback[$role]
}

if ($ListModels) {
    foreach ($r in 'sol', 'astra', 'terra', 'luna') { Write-Output ("{0,-6} -> {1}" -f $r, (Resolve-RoleModel $r)) }
    exit 0
}

function Quote([string] $s) { '"' + ($s -replace '"', '\"') + '"' }

if (-not $Model) { $Model = Resolve-RoleModel $Role }

$Brief = (Resolve-Path -LiteralPath $Brief).Path
$Dir = (Resolve-Path -LiteralPath $Dir).Path
$Report = [IO.Path]::GetFullPath($Report)
if (-not $Log) { $Log = [IO.Path]::ChangeExtension($Report, '.log') }
$Log = [IO.Path]::GetFullPath($Log)
$errLog = "$Log.stderr"
foreach ($p in @($Report, $Log)) {
    $parent = Split-Path -Parent $p
    if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Force $parent | Out-Null }
}

# 1. Resolve codex.exe fresh (never reuse a path from an earlier run).
$pkg = Get-AppxPackage OpenAI.Codex | Sort-Object Version -Descending | Select-Object -First 1
if (-not $pkg) { throw 'OpenAI.Codex Store package not found (Get-AppxPackage OpenAI.Codex).' }
$codex = Join-Path $pkg.InstallLocation 'app\resources\codex.exe'
if (-not (Test-Path $codex)) { throw "codex.exe not found at $codex" }

# 2. Git repo check.
$inGit = $false
$probe = $Dir
while ($probe) {
    if (Test-Path (Join-Path $probe '.git')) { $inGit = $true; break }
    $parentDir = Split-Path -Parent $probe
    if ($parentDir -eq $probe) { break }
    $probe = $parentDir
}

# 3. Build arguments.
$cliArgs = @('exec', '-m', $Model, '-c', "model_reasoning_effort=$Effort",
    '--sandbox', $Sandbox, '-C', (Quote $Dir), '-o', (Quote $Report))
if ($Fast) { $cliArgs += @('-c', 'service_tier=priority') }
if (-not $inGit) { $cliArgs += '--skip-git-repo-check' }
foreach ($d in $AddDir) { $cliArgs += @('--add-dir', (Quote ((Resolve-Path -LiteralPath $d).Path))) }
foreach ($kv in $ExtraConfig) { $cliArgs += @('-c', (Quote $kv)) }
$cliArgs += '-'   # read the brief from stdin

$started = Get-Date
$header = "[$($started.ToString('s'))] codex $($pkg.Version) role=$Role model=$Model sandbox=$Sandbox effort=$Effort fast=$([bool]$Fast) git=$inGit`n  dir=$Dir`n  brief=$Brief`n  report=$Report`n  log=$Log"
Write-Output $header

# 4. Run. Start-Process redirects stdin from the file as raw bytes.
$proc = Start-Process -FilePath $codex -ArgumentList ($cliArgs -join ' ') `
    -RedirectStandardInput $Brief -RedirectStandardOutput $Log -RedirectStandardError $errLog `
    -NoNewWindow -PassThru -Wait
$code = $proc.ExitCode
$elapsed = [int]((Get-Date) - $started).TotalSeconds

# 5. Summarise.
Write-Output "exit=$code elapsed=${elapsed}s"
if (Test-Path $Report) {
    Write-Output "report: $Report ($((Get-Item $Report).Length) bytes)"
} else {
    Write-Output "report: MISSING - see log tail"
}
$artifacts = Get-ChildItem $env:TEMP -Directory -Filter 'codex-security-artifacts-*' -ErrorAction SilentlyContinue |
    Where-Object { $_.LastWriteTime -ge $started }
foreach ($a in $artifacts) { Write-Output "artifacts written outside the workspace: $($a.FullName)" }
if ($code -ne 0 -or -not (Test-Path $Report)) {
    Write-Output '--- stderr tail ---'
    if (Test-Path $errLog) { Get-Content -Encoding utf8 -Tail 30 $errLog }
    Write-Output '--- stdout tail ---'
    if (Test-Path $Log) { Get-Content -Encoding utf8 -Tail 30 $Log }
}
exit $code
