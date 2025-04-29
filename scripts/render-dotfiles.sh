#!/usr/bin/env bash
set -euo pipefail

# Usage: render-dotfiles.sh [theme]
THEME="${1:-prometheus-1}"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
base_dir="$script_dir/.."
dotfiles_dir="$base_dir/dotfiles"
themes_dir="$base_dir/themes"
theme_vars="$themes_dir/$THEME/theme.sh"

echo "🎨 Rendering dotfiles for theme: $THEME"

if [[ ! -f "$theme_vars" ]]; then
  echo "❌ Theme file not found: $theme_vars"
  exit 1
fi

# Load all exports (colors, ARGB variants, GTK/Icon settings, etc.)
source "$theme_vars"

# List of vars to pass to envsubst
theme_variables=(
  BORDER0 BORDER1 BDRAD BDTHK MGN MGN_IN BARWD BARHT
  BG FG CURSOR
  BLACK RED GREEN YELLOW BLUE MAGENTA CYAN WHITE
  BLACK_BR RED_BR GREEN_BR YELLOW_BR BLUE_BR MAGENTA_BR CYAN_BR WHITE_BR
  OPAC1 OPAC0 ALPHA_HEX
  BG_ARGB FG_ARGB BLACK_ARGB RED_ARGB GREEN_ARGB YELLOW_ARGB BLUE_ARGB MAGENTA_ARGB CYAN_ARGB WHITE_ARGB
  BLACK_BR_ARGB RED_BR_ARGB GREEN_BR_ARGB YELLOW_BR_ARGB BLUE_BR_ARGB MAGENTA_BR_ARGB CYAN_BR_ARGB WHITE_BR_ARGB
)

echo "🔧 Debugging environment variables:"
for v in "${theme_variables[@]}"; do
  printf "  %s=%s\n" "$v" "${!v}"
done

# Map all your .tmpl → rendered files under dotfiles_dir
declare -A files=(
  ["$dotfiles_dir/.config/hypr/hyprland.conf.tmpl"]="$dotfiles_dir/.config/hypr/hyprland.conf"
  ["$dotfiles_dir/.config/waybar/config.jsonc.tmpl"]    ="$dotfiles_dir/.config/waybar/config.jsonc"
  ["$dotfiles_dir/.config/waybar/style.css.tmpl"]      ="$dotfiles_dir/.config/waybar/style.css"
  ["$dotfiles_dir/.config/walker/themes/prometheus.css.tmpl"]  ="$dotfiles_dir/.config/walker/themes/prometheus.css"
  ["$dotfiles_dir/.config/walker/themes/prometheus.toml.tmpl"]="$dotfiles_dir/.config/walker/themes/prometheus.toml"
  ["$dotfiles_dir/.config/kitty/kitty.conf.tmpl"]      ="$dotfiles_dir/.config/kitty/kitty.conf"
)

# Render each template in-place
for in_tmpl in "${!files[@]}"; do
  out_conf="${files[$in_tmpl]}"
  if [[ -f "$in_tmpl" ]]; then
    mkdir -p "$(dirname "$out_conf")"
    echo "⚙️  Rendering $(basename "$in_tmpl") → $(basename "$out_conf")"
    envsubst "$(printf '${%s} ' "${theme_variables[@]}")" < "$in_tmpl" > "$out_conf"
    echo "✅ Rendered: $out_conf"
  else
    echo "⚠️  Template missing: $in_tmpl"
  fi
done

echo "✅ All templates rendered."

