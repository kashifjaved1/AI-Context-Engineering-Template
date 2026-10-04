<#
.SYNOPSIS
    Generates a compact, token-efficient repository map for AI prompts and LLM context windows.
.DESCRIPTION
    Scans repository files, skips ignored directories (.git, node_modules, build outputs),
    and formats a clean tree structure.
.PARAMETER OutputFile
    Optional path to write the output file (defaults to stdout, or .ai/repo-map.txt if -SaveToAiDir is passed).
.PARAMETER SaveToAiDir
    Saves the output to .ai/repo-map.txt automatically.
.PARAMETER MaxDepth
    Maximum folder depth to traverse (default: 4).
#>

[CmdletBinding()]
param(
    [string]$OutputFile,
    [switch]$SaveToAiDir,
    [int]$MaxDepth = 4
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootDir = Split-Path -Parent $ScriptDir

$IgnorePatterns = @(
    "^\.git$",
    "^node_modules$",
    "^dist$",
    "^build$",
    "^bin$",
    "^obj$",
    "^out$",
    "^\.venv$",
    "^venv$",
    "^\.idea$",
    "^\.vscode$",
    "^\.ai$"
)

function Get-FolderTree {
    param(
        [string]$Path,
        [int]$CurrentDepth,
        [string]$Indent
    )

    if ($CurrentDepth -gt $MaxDepth) { return }

    $items = Get-ChildItem -Path $Path -Force | Where-Object {
        $name = $_.Name
        $skip = $false
        foreach ($pattern in $IgnorePatterns) {
            if ($name -match $pattern) { $skip = $true; break }
        }
        -not $skip
    } | Sort-Object { -not $_.PSIsContainer }, Name

    foreach ($item in $items) {
        if ($item.PSIsContainer) {
            $script:OutputLines += "$Indent📁 $($item.Name)/"
            Get-FolderTree -Path $item.FullName -CurrentDepth ($CurrentDepth + 1) -Indent "$Indent  "
        }
        else {
            $script:OutputLines += "$Indent📄 $($item.Name)"
        }
    }
}

$script:OutputLines = @(
    "# Repository Map for AI Context",
    "# Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')",
    "# Root: $(Split-Path -Leaf $RootDir)",
    ""
)

Get-FolderTree -Path $RootDir -CurrentDepth 1 -Indent ""

$ResultText = $script:OutputLines -join "`n"

if ($SaveToAiDir) {
    $AiDir = Join-Path $RootDir ".ai"
    if (-not (Test-Path $AiDir)) { New-Item -ItemType Directory -Path $AiDir -Force | Out-Null }
    $OutputFile = Join-Path $AiDir "repo-map.txt"
}

if ($OutputFile) {
    Set-Content -Path $OutputFile -Value $ResultText -Encoding UTF8
    Write-Host "[OK] Repository map saved to $OutputFile" -ForegroundColor Green
}
else {
    Write-Output $ResultText
}
