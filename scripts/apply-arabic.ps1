[CmdletBinding()]
param(
  [string]$HermesPath = (Join-Path $env:LOCALAPPDATA "hermes\hermes-agent"),
  [string]$Branch = "arabic-localization",
  [switch]$Build,
  [switch]$SkipVerify,
  [switch]$AllowDirty,
  [switch]$NoLanguageConfig
)

$ErrorActionPreference = "Stop"

function Invoke-Checked {
  param(
    [Parameter(Mandatory = $true)][string]$FilePath,
    [Parameter(ValueFromRemainingArguments = $true)][string[]]$Arguments
  )

  & $FilePath @Arguments
  if ($LASTEXITCODE -ne 0) {
    throw "Command failed: $FilePath $($Arguments -join ' ')"
  }
}

function Set-HermesArabicLanguage {
  param([Parameter(Mandatory = $true)][string]$ConfigPath)

  $configDir = Split-Path -Parent $ConfigPath
  if (-not (Test-Path $configDir)) {
    New-Item -ItemType Directory -Force -Path $configDir | Out-Null
  }

  if (-not (Test-Path $ConfigPath)) {
    "display:`n  language: ar`n" | Set-Content -Path $ConfigPath -Encoding UTF8
    return
  }

  $lines = [System.Collections.Generic.List[string]]::new()
  foreach ($line in Get-Content -Path $ConfigPath) {
    $lines.Add($line)
  }

  $out = [System.Collections.Generic.List[string]]::new()
  $inDisplay = $false
  $displayIndent = 0
  $sawDisplay = $false
  $languageSet = $false
  $inserted = $false

  foreach ($line in $lines) {
    if ($inDisplay -and $line -match '^\S') {
      if (-not $languageSet) {
        $out.Add("  language: ar")
        $inserted = $true
      }
      $inDisplay = $false
    }

    if ($line -match '^(\s*)display:\s*$') {
      $inDisplay = $true
      $displayIndent = $Matches[1].Length
      $sawDisplay = $true
      $languageSet = $false
      $out.Add($line)
      continue
    }

    if ($inDisplay -and $line -match '^(\s+)language\s*:') {
      $indent = $Matches[1]
      $out.Add("${indent}language: ar")
      $languageSet = $true
      continue
    }

    $out.Add($line)
  }

  if ($inDisplay -and -not $languageSet) {
    $out.Add("  language: ar")
    $inserted = $true
  }

  if (-not $sawDisplay) {
    if ($out.Count -gt 0 -and $out[$out.Count - 1].Trim() -ne "") {
      $out.Add("")
    }
    $out.Add("display:")
    $out.Add("  language: ar")
    $inserted = $true
  }

  $out | Set-Content -Path $ConfigPath -Encoding UTF8

  if ($inserted -or $languageSet) {
    Write-Host "Set display.language: ar in $ConfigPath"
  }
}

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$packageRoot = Resolve-Path (Join-Path $scriptRoot "..")
$patchPath = Join-Path $packageRoot "patches\desktop-arabic-localization.patch"

if (-not (Test-Path $patchPath)) {
  throw "Patch file not found: $patchPath"
}

if (-not (Test-Path $HermesPath)) {
  throw "Hermes path not found: $HermesPath"
}

$HermesPath = (Resolve-Path $HermesPath).Path
Push-Location $HermesPath
try {
  Invoke-Checked git rev-parse --show-toplevel | Out-Null

  $dirty = git status --porcelain
  if ($dirty -and -not $AllowDirty) {
    throw "Hermes checkout has uncommitted changes. Commit/stash them or rerun with -AllowDirty."
  }

  $branches = git branch --list $Branch
  if ($branches) {
    Invoke-Checked git switch $Branch
  } else {
    Invoke-Checked git switch -c $Branch
  }

  Invoke-Checked git apply --check --index $patchPath
  Invoke-Checked git apply --index $patchPath
  Write-Host "Applied Arabic localization patch."

  if (-not $NoLanguageConfig) {
    $hermesHome = Split-Path -Parent $HermesPath
    if ($env:HERMES_HOME) {
      $hermesHome = $env:HERMES_HOME
    }
    Set-HermesArabicLanguage -ConfigPath (Join-Path $hermesHome "config.yaml")
  }

  if (-not $SkipVerify) {
    Push-Location (Join-Path $HermesPath "apps\desktop")
    try {
      Invoke-Checked npm run typecheck
      Invoke-Checked npm run test:ui -- src/i18n/runtime.test.ts src/i18n/languages.test.ts src/i18n/context.test.tsx src/components/language-switcher.test.tsx
    } finally {
      Pop-Location
    }
  }

  if ($Build) {
    Invoke-Checked .venv\Scripts\python.exe -m hermes_cli.main desktop --build-only --force-build
    Write-Host "Desktop build complete: $HermesPath\apps\desktop\release\win-unpacked\Hermes.exe"
  }

  Write-Host "Arabic localization is ready."
} finally {
  Pop-Location
}
