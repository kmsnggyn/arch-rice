#!/usr/bin/env bash
set -euo pipefail

# Determine base paths
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
base_dir="$script_dir/.."
dotfiles_dir="$base_dir/dotfiles"
themes_dir="$base_dir/themes"

# Figure out active theme (via themes/current) or argument override
if [[ -n "${1:-}" ]]; then
  THEME="$1"
elif [[ -L "$themes_dir/current" ]]; then
  THEME="$(basename "$(readlink "$themes_dir/current")")"
else
  echo "❌ No theme specified and no 'themes/current' link found."
  exit 1
fi

theme_vars="$themes_dir/$THEME/theme.sh"
if [[ ! -f "$theme_vars" ]]; then
  echo "❌ Theme file not found: $theme_vars"
  exit 1
fi
source "$theme_vars"

echo "🎨 Rendering all templates for theme: $THEME"

# Build envsubst argument list
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
envsubs_args=$(printf '${%s} ' "${theme_variables[@]}")

# Find and render every *.tmpl under dotfiles_dir
find "$dotfiles_dir" -type f -name '*.tmpl' | while read -r tmpl; do
  rel="${tmpl#$dotfiles_dir/}"       # e.g. ".config/hypr/hyprland.conf.tmpl"
  out="$dotfiles_dir/${rel%.tmpl}"   # drop the .tmpl suffix
  mkdir -p "$(dirname "$out")"
  printf "⚙️  %s → %s\n" "$rel" "${rel%.tmpl}"
  envsubst "$envsubs_args" < "$tmpl" > "$out"
done

echo "✅ All templates rendered."

