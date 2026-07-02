[CmdletBinding()]
param(
  [int]$Port = 4000
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot

Push-Location $repoRoot
try {
  Write-Host "Serving $repoRoot at http://127.0.0.1:$Port"
  Write-Host "Press Ctrl+C to stop."
  python -m http.server $Port
}
finally {
  Pop-Location
}
