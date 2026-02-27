#!/usr/bin/env bash
# download‑packages.sh
# -------------------------------------------------
# Usage:   ./download‑packages.sh /path/to/save
# -------------------------------------------------
set -euo pipefail

# ----- configuration -------------------------------------------------
# List every package you want to have offline.
PKGS=(
    docker.io
    docker-compose
    samba
    htop
    wget
    curl
    openssh-client        # provides ssh
    openssh-server        # provides sshd & sftp
    aria2
    tmux
    vlc
)

# -------------------------------------------------
# Argument: destination directory (will be created if missing)
DEST="${1:-offline-pkgs}"
mkdir -p "$DEST"

# Update the package index – requires internet
sudo apt-get update

# Download the .deb files for the packages themselves
echo "Downloading .deb files for the requested packages…"
for pkg in "${PKGS[@]}"; do
    sudo apt-get download -o=Dir::Cache::archives="$DEST" "$pkg"
done

# Download all dependencies needed to install those packages
echo "Resolving and downloading dependencies…"
sudo apt-get install --download-only -o=Dir::Cache::archives="$DEST" "${PKGS[@]}"

# Create a single tarball for easy transfer
TARFILE="offline‑packages-$(date +%Y%m%d%H%M%S).tar.gz"
tar -czf "$TARFILE" -C "$DEST" .
echo "Package archive created: $TARFILE"
echo "Transfer this file to the offline server and run the second script there."
