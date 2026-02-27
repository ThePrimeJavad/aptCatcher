#!/usr/bin/env bash
# install‑offline.sh
# -------------------------------------------------
# Usage:   ./install‑offline.sh offline‑packages.tar.gz
# -------------------------------------------------
set -euo pipefail

# ----- configuration -------------------------------------------------
# Directory where the .deb files will be unpacked
WORKDIR="/tmp/offline-install" ؟؟؟؟؟؟؟؟؟؟؟؟
# -------------------------------------------------

ARCHIVE="${1:-offline-packages.tar.gz}"

# Create work directory and extract the archive
mkdir -p "$WORKDIR"
tar -xzf "$ARCHIVE" -C "$WORKDIR"

# Tell dpkg where to look for local packages
echo "Installing packages from $WORKDIR …"
sudo dpkg -i "$WORKDIR"/*.deb || true   # ignore errors for missing deps

# Resolve any missing dependencies using the local cache
echo "Fixing missing dependencies…"
sudo apt-get -f install -y

echo "All packages should now be installed."
