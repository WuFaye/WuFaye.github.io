[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot

git -C $repoRoot pull --ff-only
git -C $repoRoot status --short --branch
