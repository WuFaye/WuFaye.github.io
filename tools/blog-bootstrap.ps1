[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
$themeDir = Join-Path $repoRoot "themes/next"
$nextCommit = "b062274e94d232ce05dded1a4965ceb63cf60d70"

Push-Location $repoRoot
try {
  if (-not (Test-Path $themeDir)) {
    git clone --depth 1 https://github.com/next-theme/hexo-theme-next.git $themeDir
  }

  git -C $themeDir fetch --depth 1 origin $nextCommit
  git -C $themeDir checkout $nextCommit

  Write-Host "NexT theme is ready at $nextCommit"
  Write-Host "Install dependencies with npm ci, then run npm run build."
}
finally {
  Pop-Location
}
