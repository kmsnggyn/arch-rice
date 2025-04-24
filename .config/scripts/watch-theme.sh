#!/usr/bin/env bash

# ─── Logging helpers ──────────────────────────────────────────────────
timestamp() { date '+%Y-%m-%d %H:%M:%S'; }

log_start() {
  echo "[$(timestamp)] ▶ Starting watch-theme"
}

log_stop() {
  echo "[$(timestamp)] ⏹ Stopping watch-theme"
}

log_change() {
  echo "[$(timestamp)] ✎ Change detected in: $1"
}

log_reload() {
  echo "[$(timestamp)] ↻ Reloading configs and restarting Waybar"
}

# ─── Files to watch ───────────────────────────────────────────────────
CONFIG_FILES=(
  "$HOME/.config/waybar/config.jsonc.tmpl"
  "$HOME/.config/waybar/style.css.tmpl"
  "$HOME/.config/hypr/hyprland.conf.tmpl"
  "$HOME/.config/themes/sg/theme.sh"
)

# ─── Cleanup on exit ─────────────────────────────────────────────────
trap 'log_stop; killall waybar && waybar & disown' EXIT

# ─── Main loop ───────────────────────────────────────────────────────
log_start

while true; do
  # wait for any of the files to be modified
  changed=$(inotifywait -e modify --format '%w%f' "${CONFIG_FILES[@]}")
  log_change "$changed"

  # regenerate your dotfiles
  ~/.config/scripts/render-dotfiles.sh

  # restart Waybar
  log_reload() {
  echo "[$(timestamp)] ↻ Reloading configs and restarting Waybar"
  echo "[$(timestamp)] ↻ Reloading configs and restarting Waybar" >> ~/.cache/theme-render.log
}
  killall waybar 2>/dev/null || true
  sleep 0.2
  waybar & disown
done
