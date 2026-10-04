<#
.SYNOPSIS
    Interactive onboarding and bootstrap script for initializing a project from the AI Context Template.
.DESCRIPTION
    Configures contextrc.json, AGENTS.md, and project metadata for a new repository.
.PARAMETER ProjectName
    Name of the project (e.g., "billing-service").
.PARAMETER Description
    Short description of what the project does.
.PARAMETER Stack
    Primary technology stack (e.g., "TypeScript / Node", ".NET / C#", "Python / FastAPI", "Go").
.PARAMETER NonInteractive
    Runs with supplied parameters without interactive prompts.
#>

[CmdletBinding()]
param(
    [string]$ProjectName,
    [string]$Description,
    [string]$Stack,
    [switch]$NonInteractive
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootDir = Split-Path -Parent $ScriptDir

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  AI Context Engineering Template - Project Initializer  " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# Gather Inputs
if (-not $NonInteractive) {
    if (-not $ProjectName) {
        $ProjectName = Read-Host "Enter Project Name (e.g., billing-service)"
    }
    if (-not $Description) {
        $Description = Read-Host "Enter Brief Description (e.g., Core billing and payment orchestration service)"
    }
    if (-not $Stack) {
        $Stack = Read-Host "Enter Primary Tech Stack (e.g., TypeScript / Node.js, .NET 9, Python / FastAPI)"
    }
}

if (-not $ProjectName) { $ProjectName = "my-project" }
if (-not $Description) { $Description = "Project using AI Context Engineering Template" }
if (-not $Stack) { $Stack = "Generic Polyglot" }

Write-Host "`nConfiguring project with:" -ForegroundColor Green
Write-Host " - Project Name: $ProjectName"
Write-Host " - Description:  $Description"
Write-Host " - Tech Stack:   $Stack`n"

# 1. Update contextrc.json
$ContextRcPath = Join-Path $RootDir "contextrc.json"
if (Test-Path $ContextRcPath) {
    try {
        $json = Get-Content $ContextRcPath -Raw | ConvertFrom-Json
        $json.projectName = $ProjectName
        $json.description = $Description
        $json | ConvertTo-Json -Depth 10 | Set-Content $ContextRcPath -Encoding UTF8
        Write-Host "[OK] Updated contextrc.json with project metadata." -ForegroundColor Green
    }
    catch {
        Write-Warning "Could not update contextrc.json: $_"
    }
}

# 2. Update CLAUDE.md placeholder
$ClaudePath = Join-Path $RootDir "CLAUDE.md"
if (Test-Path $ClaudePath) {
    $claudeContent = Get-Content $ClaudePath -Raw
    $updatedClaude = $claudeContent -replace "generic-project-template", $ProjectName
    Set-Content -Path $ClaudePath -Value $updatedClaude -Encoding UTF8
    Write-Host "[OK] Configured CLAUDE.md." -ForegroundColor Green
}

# 3. Ensure .ai directory and subfolders exist
$AiDir = Join-Path $RootDir ".ai"
if (-not (Test-Path $AiDir)) {
    New-Item -ItemType Directory -Path $AiDir -Force | Out-Null
    Write-Host "[OK] Created .ai workspace directory." -ForegroundColor Green
}

# 4. Create standard src and test directories if not existing
$SrcDir = Join-Path $RootDir "src"
$TestDir = Join-Path $RootDir "test"
if (-not (Test-Path $SrcDir)) { New-Item -ItemType Directory -Path $SrcDir -Force | Out-Null }
if (-not (Test-Path $TestDir)) { New-Item -ItemType Directory -Path $TestDir -Force | Out-Null }
Write-Host "[OK] Verified base src/ and test/ directories." -ForegroundColor Green

Write-Host "`nProject initialization complete! Next steps:" -ForegroundColor Cyan
Write-Host " 1. Review context/architecture/overview.md to describe your system architecture."
Write-Host " 2. Fill in domain terms in context/domain/glossary.md."
Write-Host " 3. Run 'pwsh ./scripts/validate-context.ps1' to verify context integrity."
