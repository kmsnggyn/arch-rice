#!/usr/bin/env bash
set -euo pipefail

# Usage: render-dotfiles.sh [theme]
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
base_dir="$script_dir/.."
themes_dir="$base_dir/themes"
dotfiles_dir="$base_dir/dotfiles"

# Determine which theme to render
if [[ -n "${1:-}" ]]; then
  THEME="$1"
elif [[ -L "$themes_dir/current" ]]; then
  THEME="$(basename "$(readlink "$themes_dir/current")")"
else
  echo "❌ No theme specified and no 'themes/current' symlink found."
  exit 1
fi

theme_vars="$themes_dir/$THEME/theme.sh"
if [[ ! -f "$theme_vars" ]]; then
  echo "❌ Theme file not found: $theme_vars"
  exit 1
fi

echo "🎨 Rendering dotfiles for theme: $THEME"
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
  BORDER0_ARGB BORDER1_ARGB
)

# Debug
echo "🔧 Debugging environment variables:"
for v in "${theme_variables[@]}"; do
  printf "  %s=%s\n" "$v" "${!v}"
done

# Map templates → outputs
declare -A files=(
  ["$dotfiles_dir/.config/hypr/hyprland.conf.tmpl"]   ="$dotfiles_dir/.config/hypr/hyprland.conf"
  ["$dotfiles_dir/.config/waybar/config.jsonc.tmpl"] ="$dotfiles_dir/.config/waybar/config.jsonc"
  ["$dotfiles_dir/.config/waybar/style.css.tmpl"]    ="$dotfiles_dir/.config/waybar/style.css"
  ["$dotfiles_dir/.config/kitty/kitty.conf.tmpl"]    ="$dotfiles_dir/.config/kitty/kitty.conf"
  # add more mappings as needed...
)

# Render each template
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
