#!/usr/bin/env bash
set -euo pipefail

BASE="$HOME/arch-rice/dotfiles"
find "$BASE" -type f \! -name '*.tmpl' | while read -r src; do
  rel="${src#$BASE/}"           # e.g. .config/kitty/theme.conf
  dst="$HOME/$rel"
  mkdir -p "$(dirname "$dst")"
  ln -sf "$src" "$dst"
  echo "  • $dst → $src"
done

