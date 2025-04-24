#!/usr/bin/env bash
set -euo pipefail

# 1) Load your palette and opacity
source ~/.config/themes/current/theme.sh

# Import env variables:
VARS=$(tr '\n' ' ' < ~/.config/themes/vars.list)


echo "[INFO] Rendering with vars:"
echo "$VARS"

# 2) Render Hyprland
envsubst "$VARS" \
  <~/.config/hypr/hyprland.conf.tmpl \
  >~/.config/hypr/hyprland.conf

# 3) Render Waybar
envsubst "$VARS" \
  <~/.config/waybar/style.css.tmpl \
  >~/.config/waybar/style.css

envsubst "$VARS" \
  <~/.config/waybar/config.jsonc.tmpl \
  >~/.config/waybar/config.jsonc

# 4) Render Walker
envsubst "$VARS"\
  <~/.config/walker/themes/theme.css.tmpl \
  >~/.config/walker/themes/theme.css

envsubst "$VARS"\
  <~/.config/walker/themes/theme.toml.tmpl \
  >~/.config/walker/themes/theme.toml


# 4) Render Geany


echo "✅ All templates rendered with CS_* values."
