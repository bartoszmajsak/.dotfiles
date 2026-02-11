#!/bin/bash
set -euo pipefail

# --- Config ---
API_URL="https://cursor.com/api/download?platform=linux-x64&releaseTrack=stable"
ICON_URL="https://avatars.githubusercontent.com/u/126759922"
INSTALL_DIR="$HOME/Applications/cursor"
CURSOR_APP_IMAGE="$INSTALL_DIR/cursor.AppImage"
CURSOR_ICON="$INSTALL_DIR/cursor-icon.png"
DESKTOP_FILE="$HOME/.local/share/applications/cursor.desktop"
WRAPPER_SYS="/usr/local/bin/cursor"
WRAPPER_USER="$HOME/.local/bin/cursor"

# --- Helpers ---
need_cmd() {
  command -v "$1" >/dev/null 2>&1 || { echo "Missing dependency: $1" >&2; exit 1; }
}

# --- Checks ---
need_cmd curl
need_cmd jq
need_cmd wget

# --- Fetch latest download URL ---
echo "Fetching latest Cursor release info..."
json=$(curl -fsSL "$API_URL")
download_url=$(echo "$json" | jq -r '.downloadUrl')

if [[ -z "$download_url" || "$download_url" == "null" ]]; then
  echo "Failed to retrieve downloadUrl from API: $API_URL" >&2
  exit 1
fi

# --- Prepare directories ---
mkdir -p "$INSTALL_DIR"

# --- Download AppImage ---
echo "Downloading Cursor AppImage from:"
echo "  $download_url"
# show a progress bar; follow redirects if any
wget --progress=bar:force:noscroll -O "$CURSOR_APP_IMAGE" "$download_url"
chmod +x "$CURSOR_APP_IMAGE"
echo "✔ AppImage saved to $CURSOR_APP_IMAGE"

# --- Create launcher wrapper that adds --no-sandbox ---
create_wrapper() {
  local path="$1"
  mkdir -p "$(dirname "$path")"
  cat > "$path" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
APPIMAGE_PATH="__APPIMAGE_PATH__"
exec "$APPIMAGE_PATH" --no-sandbox "$@"
EOF
  # Inject the real AppImage path safely
  sed -i "s#__APPIMAGE_PATH__#$(printf '%q' "$CURSOR_APP_IMAGE")#g" "$path"
  chmod +x "$path"
}

EXEC_PATH=""
if sudo -n true 2>/dev/null; then
  echo "Creating system-wide wrapper at $WRAPPER_SYS (using sudo)..."
  tmpfile="$(mktemp)"
  create_wrapper "$tmpfile"
  sudo mv "$tmpfile" "$WRAPPER_SYS"
  EXEC_PATH="$WRAPPER_SYS"
else
  echo "No passwordless sudo detected. Attempting sudo for system-wide wrapper..."
  if sudo true; then
    echo "Creating system-wide wrapper at $WRAPPER_SYS..."
    tmpfile="$(mktemp)"
    create_wrapper "$tmpfile"
    sudo mv "$tmpfile" "$WRAPPER_SYS"
    EXEC_PATH="$WRAPPER_SYS"
  else
    echo "Falling back to user wrapper at $WRAPPER_USER"
    create_wrapper "$WRAPPER_USER"
    EXEC_PATH="$WRAPPER_USER"
  fi
fi
echo "✔ Wrapper created at $EXEC_PATH (adds --no-sandbox)"

# --- Download icon (best-effort) ---
echo "Fetching icon..."
wget -q -O "$CURSOR_ICON" "$ICON_URL" || echo "Icon download failed; continuing."

# --- Create .desktop entry ---
mkdir -p "$(dirname "$DESKTOP_FILE")"
cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=Cursor
Exec=$EXEC_PATH %U
TryExec=$EXEC_PATH
Icon=$CURSOR_ICON
Type=Application
Categories=Utility;Development;
Terminal=false
StartupNotify=true
EOF
echo "✔ Desktop entry created at $DESKTOP_FILE"

# --- Refresh desktop database / menus (best-effort) ---
if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database "$HOME/.local/share/applications" || true
fi
if command -v xdg-desktop-menu >/dev/null 2>&1; then
  xdg-desktop-menu forceupdate || true
fi

echo
echo "✅ Cursor installed."
echo "   AppImage: $CURSOR_APP_IMAGE"
echo "   Launcher: $EXEC_PATH (always runs with --no-sandbox)"
echo "   Menu entry: $DESKTOP_FILE"
echo
echo "You should now find 'Cursor' in your applications menu."
echo "Or run: $(printf '%q' "$EXEC_PATH")"