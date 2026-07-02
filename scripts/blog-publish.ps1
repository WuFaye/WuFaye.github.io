[CmdletBinding()]
param(
  [string]$Message = ""
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot

if ([string]::IsNullOrWhiteSpace($Message)) {
  $Message = "update blog " + (Get-Date -Format "yyyy-MM-dd HH:mm")
}

$status = git -C $repoRoot status --porcelain
if (-not $status) {
  Write-Host "No changes to publish."
  exit 0
}

git -C $repoRoot add -A
git -C $repoRoot commit -m $Message
git -C $repoRoot push
