#!/usr/bin/env bash
set -euo pipefail

# ─── Base dirs ───────────────────────────────────────────────────────────
BASE_DIR="$HOME/arch-rice"
DOTFILES_DIR="$BASE_DIR/dotfiles"
SCRIPTS_DIR="$BASE_DIR/scripts"

# ─── Templates to watch ───────────────────────────────────────────────────
CONFIG_FILES=(
  "$DOTFILES_DIR/.config/waybar/config.jsonc.tmpl"
  "$DOTFILES_DIR/.config/waybar/style.css.tmpl"
  "$DOTFILES_DIR/.config/hypr/hyprland.conf.tmpl"
  "$DOTFILES_DIR/.config/kitty/kitty.conf.tmpl"
)

# ─── Verify they exist ────────────────────────────────────────────────────
for file in "${CONFIG_FILES[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "❌ Error: Template not found: $file"
    exit 1
  fi
done

echo "✅ Templates found. Starting watch loop..."

# ─── Watch & reload ───────────────────────────────────────────────────────
while true; do
  changed=$(inotifywait -e modify \
    --exclude '\.swp$|\.bak$|~$|\.tmp$' \
    --format '%w%f' "${CONFIG_FILES[@]}")
  echo "🔄 Change detected: $changed"

  # Render all your templates
  echo "🎨 Rendering dotfiles..."
  "$SCRIPTS_DIR/render-dotfiles.sh"

  # Restart Waybar
  if pgrep -x waybar >/dev/null; then
    echo "🛑 Stopping Waybar..."
    killall waybar
    sleep 1
  fi
  echo "🔗 Starting Waybar..."
  waybar & disown

  # throttle
  sleep 0.5
done

