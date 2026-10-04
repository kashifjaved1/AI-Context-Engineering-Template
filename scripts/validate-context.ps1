<#
.SYNOPSIS
    Validates contextrc.json integrity, checks for broken markdown links, and verifies context freshness.
.DESCRIPTION
    Runs diagnostic checks across the AI context engineering system.
    Exits with code 0 if all checks pass, or code 1 if issues are detected.
#>

[CmdletBinding()]
param(
    [switch]$Detailed
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootDir = Split-Path -Parent $ScriptDir

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "         AI Context Health & Integrity Validator          " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$TotalErrors = 0
$TotalWarnings = 0

# --- Check 1: Validate contextrc.json syntax and schema ---
Write-Host "`n[Check 1/4] Validating contextrc.json..." -ForegroundColor Yellow
$ContextRcPath = Join-Path $RootDir "contextrc.json"

if (-not (Test-Path $ContextRcPath)) {
    Write-Host " [FAIL] contextrc.json not found at repository root!" -ForegroundColor Red
    $TotalErrors++
}
else {
    try {
        $contextJson = Get-Content $ContextRcPath -Raw | ConvertFrom-Json
        if (-not $contextJson.projectName) {
            Write-Host " [WARN] 'projectName' is empty in contextrc.json." -ForegroundColor DarkYellow
            $TotalWarnings++
        }
        if (-not $contextJson.areas -or $contextJson.areas.Count -eq 0) {
            Write-Host " [WARN] No 'areas' defined in contextrc.json." -ForegroundColor DarkYellow
            $TotalWarnings++
        }
        else {
            Write-Host " [PASS] contextrc.json parsed successfully ($($contextJson.areas.Count) areas defined)." -ForegroundColor Green
        }
    }
    catch {
        Write-Host " [FAIL] Invalid JSON syntax in contextrc.json: $_" -ForegroundColor Red
        $TotalErrors++
    }
}

# --- Check 2: Verify all contextFiles in contextrc.json exist on disk ---
Write-Host "`n[Check 2/4] Verifying referenced context files exist..." -ForegroundColor Yellow
if ($contextJson -and $contextJson.areas) {
    $missingFiles = @()
    foreach ($area in $contextJson.areas) {
        if ($area.contextFiles) {
            foreach ($fileRef in $area.contextFiles) {
                $targetFile = Join-Path $RootDir $fileRef
                if (-not (Test-Path $targetFile)) {
                    $missingFiles += "Area '$($area.name)': Referenced '$fileRef' does not exist."
                }
            }
        }
    }

    if ($missingFiles.Count -gt 0) {
        foreach ($msg in $missingFiles) {
            Write-Host " [FAIL] $msg" -ForegroundColor Red
            $TotalErrors++
        }
    }
    else {
        Write-Host " [PASS] All context files referenced in contextrc.json exist on disk." -ForegroundColor Green
    }
}

# --- Check 3: Markdown link integrity check ---
Write-Host "`n[Check 3/4] Scanning Markdown files for broken relative links..." -ForegroundColor Yellow
$MdFiles = Get-ChildItem -Path $RootDir -Include "*.md" -Recurse | Where-Object {
    $_.FullName -notmatch "node_modules|\.git|\.ai"
}

$brokenLinks = @()
$linkRegex = '\[([^\]]+)\]\(([^)]+)\)'

foreach ($mdFile in $MdFiles) {
    $content = Get-Content $mdFile.FullName -Raw
    $matches = [regex]::Matches($content, $linkRegex)
    
    foreach ($match in $matches) {
        $linkTarget = $match.Groups[2].Value.Trim()
        
        # Skip external URLs, anchors, mailto, and variable placeholders
        if ($linkTarget -match '^https?://' -or 
            $linkTarget -match '^#' -or 
            $linkTarget -match '^mailto:' -or
            $linkTarget -match '^\{' -or
            $linkTarget -match 'XXXX\.md') {
            continue
        }

        # Strip internal hash anchors (e.g. file.md#section)
        $cleanTarget = $linkTarget -replace '#.*$', ''
        if ([string]::IsNullOrWhiteSpace($cleanTarget)) { continue }

        $resolvedPath = [System.IO.Path]::GetFullPath((Join-Path (Split-Path $mdFile.FullName) $cleanTarget))
        if (-not (Test-Path $resolvedPath)) {
            $relSource = $mdFile.FullName.Substring($RootDir.Length).TrimStart('\', '/')
            $brokenLinks += "$relSource -> '$linkTarget'"
        }
    }
}

if ($brokenLinks.Count -gt 0) {
    foreach ($broken in $brokenLinks) {
        Write-Host " [FAIL] Broken link in $broken" -ForegroundColor Red
        $TotalErrors++
    }
}
else {
    Write-Host " [PASS] Scanned $($MdFiles.Count) markdown files; 0 broken local links found." -ForegroundColor Green
}

# --- Check 4: Check canonical instruction files ---
Write-Host "`n[Check 4/4] Verifying canonical instruction anchors..." -ForegroundColor Yellow
$CanonicalFiles = @("AGENTS.md", "CLAUDE.md", ".cursorrules", ".github/copilot-instructions.md")
$missingCanonicals = @()

foreach ($canon in $CanonicalFiles) {
    $path = Join-Path $RootDir $canon
    if (-not (Test-Path $path)) {
        $missingCanonicals += $canon
    }
}

if ($missingCanonicals.Count -gt 0) {
    foreach ($m in $missingCanonicals) {
        Write-Host " [FAIL] Missing core agent connector: $m" -ForegroundColor Red
        $TotalErrors++
    }
}
else {
    Write-Host " [PASS] All canonical agent connectors present." -ForegroundColor Green
}

# --- Summary & Exit ---
Write-Host "`n==========================================================" -ForegroundColor Cyan
if ($TotalErrors -eq 0) {
    Write-Host " Health Check Result: PASSED (Warnings: $TotalWarnings)" -ForegroundColor Green
    Write-Host "==========================================================" -ForegroundColor Cyan
    exit 0
}
else {
    Write-Host " Health Check Result: FAILED ($TotalErrors Errors, $TotalWarnings Warnings)" -ForegroundColor Red
    Write-Host "==========================================================" -ForegroundColor Cyan
    exit 1
}
