[CmdletBinding()]
param(
  [int]$Port = 4000
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot

Push-Location $repoRoot
try {
  Write-Host "Serving Hexo at http://127.0.0.1:$Port"
  Write-Host "Press Ctrl+C to stop."
  .\node_modules\.bin\hexo.cmd server -p $Port
}
finally {
  Pop-Location
}
