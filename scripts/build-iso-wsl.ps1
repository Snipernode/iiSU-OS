$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$repoRootUnix = (& wsl wslpath -a $repoRoot).Trim()
$quotedRepoRoot = "'" + $repoRootUnix.Replace("'", "'\''") + "'"

& wsl -u root bash -lc "apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y live-build xorriso isolinux syslinux-common syslinux-efi syslinux-utils grub-pc-bin grub-efi-amd64-bin mtools dosfstools squashfs-tools debootstrap"

if ($LASTEXITCODE -ne 0) {
    throw "Failed to install ISO build dependencies in WSL."
}

& wsl -u root bash -lc "cd $quotedRepoRoot && bash scripts/build-iso.sh"

if ($LASTEXITCODE -ne 0) {
    throw "ISO build failed."
}
