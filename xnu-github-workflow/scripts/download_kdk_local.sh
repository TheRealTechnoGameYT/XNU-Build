#!/usr/bin/env bash
# Helper to attach a local kdk.dmg and copy its .kdk into /Library/Developer/KDKs
set -euo pipefail
if [ $# -lt 1 ]; then
  echo "Usage: $0 <path-to-kdk.dmg>"
  exit 1
fi
DMG="$1"
if [ ! -f "$DMG" ]; then
  echo "File not found: $DMG"
  exit 1
fi
echo "Mounting $DMG..."
MOUNT=$(hdiutil attach "$DMG" -nobrowse -mountpoint /Volumes/_kdk_temp -quiet || true)
sudo mkdir -p /Library/Developer/KDKs
if ls /Volumes/_kdk_temp/*.kdk >/dev/null 2>&1; then
  sudo cp -R /Volumes/_kdk_temp/*.kdk /Library/Developer/KDKs/
  echo "Copied .kdk files to /Library/Developer/KDKs/"
else
  echo "No .kdk files found in the DMG"
fi
hdiutil detach /Volumes/_kdk_temp -quiet || true
