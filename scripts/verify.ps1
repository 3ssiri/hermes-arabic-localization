[CmdletBinding()]
param(
  [string]$HermesPath = (Join-Path $env:LOCALAPPDATA "hermes\hermes-agent")
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

if (-not (Test-Path $HermesPath)) {
  throw "Hermes path not found: $HermesPath"
}

$desktopPath = Join-Path $HermesPath "apps\desktop"
if (-not (Test-Path $desktopPath)) {
  throw "Hermes Desktop path not found: $desktopPath"
}

Push-Location $desktopPath
try {
  Invoke-Checked npm run typecheck
  Invoke-Checked npm run test:ui -- src/i18n/runtime.test.ts src/i18n/languages.test.ts src/i18n/context.test.tsx src/components/language-switcher.test.tsx
} finally {
  Pop-Location
}

Write-Host "Arabic localization verification passed."
