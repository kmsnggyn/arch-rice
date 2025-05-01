# Updated `render-dotfiles.sh`
#!/usr/bin/env bash
set -euo pipefail

# Usage: render-dotfiles.sh [-t theme] [app1 app2 ...]
#   -t, --theme  Specify theme name (defaults to symlink at themes/current)
#   If no apps are passed, all .tmpl files are rendered.

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
base_dir="$script_dir/.."
dotfiles_dir="$base_dir/dotfiles"
themes_dir="$base_dir/themes"

# --- Parse options ---
THEME_ARG=""
APPS=()
while (( "$#" )); do
  case "$1" in
    -t|--theme)
      shift
      THEME_ARG="$1"
      ;;
    -* )
      echo "❌ Unknown option: $1" >&2
      exit 1
      ;;
    * )
      APPS+=("$1")
      ;;
  esac
  shift
done

# --- Determine theme ---
if [[ -n "$THEME_ARG" ]]; then
  THEME="$THEME_ARG"
elif [[ -L "$themes_dir/current" ]]; then
  THEME="$(basename "$(readlink "$themes_dir/current")")"
else
  echo "❌ No theme specified and no 'themes/current' link found." >&2
  exit 1
fi

theme_vars="$themes_dir/$THEME/theme.sh"
if [[ ! -f "$theme_vars" ]]; then
  echo "❌ Theme file not found: $theme_vars" >&2
  exit 1
fi
source "$theme_vars"

echo "🎨 Rendering templates for theme: $THEME${APPS:+, apps: ${APPS[*]}}"

# --- Environment for envsubst ---
theme_variables=(
  BORDER0 BORDER1 BDRAD BDTHK MGN MGN_IN BARWD BARHT
  BG FG CURSOR
  BLACK RED GREEN YELLOW BLUE MAGENTA CYAN WHITE
  BLACK_BR RED_BR GREEN_BR YELLOW_BR BLUE_BR MAGENTA_BR CYAN_BR WHITE_BR
  OPAC1 OPAC0 OPAC1_HEX OPAC0_HEX
  BG_ARGB FG_ARGB BLACK_ARGB RED_ARGB GREEN_ARGB YELLOW_ARGB BLUE_ARGB MAGENTA_ARGB CYAN_ARGB WHITE_ARGB
  BLACK_BR_ARGB RED_BR_ARGB GREEN_BR_ARGB YELLOW_BR_ARGB BLUE_BR_ARGB MAGENTA_BR_ARGB CYAN_BR_ARGB WHITE_BR_ARGB
  BORDER0_ARGB BORDER1_ARGB
)
envsubs_args=$(printf '${%s} ' "${theme_variables[@]}")

# --- Walk .tmpl files and render ---
find "$dotfiles_dir" -type f -name '*.tmpl' | while read -r tmpl; do
  # if apps filter is set, skip unmatched
  if (( ${#APPS[@]} )); then
    match=false
    for app in "${APPS[@]}"; do
      if [[ "$tmpl" == *".config/$app/"* ]]; then
        match=true
        break
      fi
    done
    $match || continue
  fi

  rel="${tmpl#$dotfiles_dir/}"
  out="$dotfiles_dir/${rel%.tmpl}"
  mkdir -p "$(dirname "$out")"
  printf "⚙️  %s → %s\n" "$rel" "${rel%.tmpl}"
  envsubst "$envsubs_args" < "$tmpl" > "$out"
done

echo "✅ Templates rendered."
