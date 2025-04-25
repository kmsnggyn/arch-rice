#!/usr/bin/env bash

# ─── Files to watch ───────────────────────────────────────────────────
CONFIG_FILES=(
  "$HOME/.config/themes/current/theme.sh"               # Theme file
  "$HOME/.config/waybar/config.jsonc.tmpl"               # Waybar config template
  "$HOME/.config/waybar/style.css.tmpl"                  # Waybar style template
  "$HOME/.config/hypr/hyprland.conf.tmpl"                # Hyprland config template
  "$HOME/.config/kitty/kitty.conf.tmpl"                  # Kitty config template
  "$HOME/.config/walker/themes/prometheus.css.tmpl"
  "$HOME/.config/walker/themes/prometheus.toml.tmpl"
  "$HOME/.config/walker/config.toml"
)

# ─── Check if all required files exist ───────────────────────────────
for file in "${CONFIG_FILES[@]}"; do
  if [ ! -f "$file" ]; then
    echo "❌ Error: File not found: $file"
    exit 1
  fi
done

echo "✅ All files are present. Starting watch loop..."

# ─── Main loop ───────────────────────────────────────────────────────
while true; do
  # Wait for any of the files to be modified, while excluding temporary and backup files
  changed=$(inotifywait -e modify --exclude '\.swp$|\.bak$|~$|\.tmp$' --format '%w%f' "${CONFIG_FILES[@]}")

  # Render dotfiles (this will regenerate the config files)
  echo "Rendering dotfiles..."
  ~/.config/scripts/render-dotfiles.sh

  # Restart Waybar after rendering
  if pgrep -x "waybar" >/dev/null; then
    echo "Stopping Waybar..."
    killall waybar
    sleep 1  # Give it a moment to stop
  fi

  # Start Waybar again
  echo "Starting Waybar..."
  waybar & disown

  # Sleep for a moment to avoid excessive CPU usage
  sleep 0.5
done
