#!/bin/bash
set -euo pipefail

API_URL="https://cursor.com/api/download?platform=linux-x64&releaseTrack=stable"
INSTALL_DIR="$HOME/Applications/cursor"
CURSOR_APP_IMAGE="$INSTALL_DIR/cursor.AppImage"

# Check dependencies
for cmd in curl jq wget; do
  command -v "$cmd" >/dev/null 2>&1 || {
    echo "Missing required command: $cmd" >&2
    exit 1
  }
done

# Fetch latest release info
echo "Checking for updates..."
json=$(curl -fsSL "$API_URL")
download_url=$(echo "$json" | jq -r '.downloadUrl')
version=$(echo "$json" | jq -r '.version')

if [[ -z "$download_url" || "$download_url" == "null" ]]; then
  echo "Failed to retrieve download URL from $API_URL" >&2
  exit 1
fi

echo "Latest Cursor version: $version"
echo "Downloading from: $download_url"

# Ensure install dir exists
mkdir -p "$INSTALL_DIR"

# Download to a temp file first
tmpfile=$(mktemp)
wget --progress=bar:force:noscroll -O "$tmpfile" "$download_url"

# Replace old AppImage
mv "$tmpfile" "$CURSOR_APP_IMAGE"
chmod +x "$CURSOR_APP_IMAGE"

echo "✔ Cursor updated to version $version"
echo "Executable: $CURSOR_APP_IMAGE"