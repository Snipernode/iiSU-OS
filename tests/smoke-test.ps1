$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$wsl = Get-Command wsl -ErrorAction SilentlyContinue

if (-not $wsl) {
    throw "WSL is required to run the Linux smoke test from Windows."
}

$repoRootUnix = (& wsl wslpath -a $repoRoot).Trim()
$quotedRepoRoot = "'" + $repoRootUnix.Replace("'", "'\''") + "'"

& wsl bash -lc "cd $quotedRepoRoot && bash tests/smoke-test.sh"

if ($LASTEXITCODE -ne 0) {
    throw "Smoke test failed."
}
