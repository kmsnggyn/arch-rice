#!/bin/bash
set -e

echo "🎨 Rendering dotfiles from templates..."

# Load current theme variables
theme_vars="$HOME/.config/themes/current/theme.sh"

if [ ! -f "$theme_vars" ]; then
  echo "❌ Theme file not found: $theme_vars"
  exit 1
fi

# Source the theme variables (already exported in theme.sh)
source "$theme_vars"

# Create a list of the theme-related environment variables (updated without quotes)
theme_variables=(
  BORDER0
  BORDER1
  BDRAD
  BDTHK
  MGN
  MGN_IN
  BARWD
  BARHT

  BG
  FG
  CURSOR

  BLACK
  RED
  GREEN
  YELLOW
  BLUE
  MAGENTA
  CYAN
  WHITE
  BLACK_BR
  RED_BR
  GREEN_BR
  YELLOW_BR
  BLUE_BR
  MAGENTA_BR
  CYAN_BR
  WHITE_BR

  OPAC1
  OPAC0

  BORDER0_ARGB
  BORDER1_ARGB
  BLACK_ARGB
  RED_ARGB
  GREEN_ARGB
  YELLOW_ARGB
  BLUE_ARGB
  MAGENTA_ARGB
  CYAN_ARGB
  WHITE_ARGB
  BLACK_BR_ARGB
  RED_BR_ARGB
  GREEN_BR_ARGB
  YELLOW_BR_ARGB
  BLUE_BR_ARGB
  MAGENTA_BR_ARGB
  CYAN_BR_ARGB
  WHITE_BR_ARGB
)

# Debugging environment variables
echo "Debugging environment variables:"
for var in "${theme_variables[@]}"; do
  printf "%s = %s\n" "$var" "${!var}"
done

# Define your templated files here
declare -A files=(
  ["$HOME/.config/hypr/hyprland.conf.tmpl"]="$HOME/.config/hypr/hyprland.conf"
  ["$HOME/.config/waybar/config.jsonc.tmpl"]="$HOME/.config/waybar/config.jsonc"
  ["$HOME/.config/waybar/style.css.tmpl"]="$HOME/.config/waybar/style.css"
  ["$HOME/.config/walker/themes/prometheus.css.tmpl"]="$HOME/.config/walker/themes/prometheus.css"
  ["$HOME/.config/walker/themes/prometheus.toml.tmpl"]="$HOME/.config/walker/themes/prometheus.toml"
  ["$HOME/.config/kitty/kitty.conf.tmpl"]="$HOME/.config/kitty/kitty.conf"
)

# Process each template file
for input in "${!files[@]}"; do
  output="${files[$input]}"
  if [ -f "$input" ]; then
    echo "⚙️  Rendering: $(basename "$input") → $(basename "$output")"

    # Check if the output file is writable before overwriting
    if [ -w "$output" ] || [ ! -e "$output" ]; then
      # Pass the specific theme-related variables to envsubst
      envsubst "$(printf '${%s} ' "${theme_variables[@]}")" < "$input" > "$output"
      echo "✅ File rendered: $output"
    else
      echo "❌ Unable to write to $output. Check permissions."
    fi
  else
    echo "⚠️  Template not found: $input"
  fi
done

echo "✅ Render complete."
