#!/bin/bash
set -e

echo "🎨 Rendering dotfiles from templates..."

# Load current theme variables
theme_vars="$HOME/.config/themes/current/theme.sh"

if [ ! -f "$theme_vars" ]; then
  echo "❌ Theme file not found: $theme_vars"
  exit 1
fi

source "$theme_vars"

# Define your templated files here
declare -A files=(
  ["$HOME/.config/hypr/hyprland.conf.tmpl"]="$HOME/.config/hypr/hyprland.conf"
  ["$HOME/.config/waybar/config.jsonc.tmpl"]="$HOME/.config/waybar/config.jsonc"
  ["$HOME/.config/walker/themes/prometheus.css.tmpl"]="$HOME/.config/walker/themes/prometheus.css"
  ["$HOME/.config/walker/themes/prometheus.toml.tmpl"]="$HOME/.config/walker/themes/prometheus.toml"
)

for input in "${!files[@]}"; do
  output="${files[$input]}"
  if [ -f "$input" ]; then
    echo "⚙️  Rendering: $(basename "$input") → $(basename "$output")"
    envsubst <"$input" >"$output"
  else
    echo "⚠️  Template not found: $input"
  fi
done

echo "✅ Render complete."
