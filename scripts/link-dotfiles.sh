#!/usr/bin/env bash
set -euo pipefail

BASE="$HOME/arch-rice/dotfiles"

# 1) Cleanup stale symlinks in $HOME that point into the mirror but no longer exist
echo "🧹 Cleaning up stale symlinks in \$HOME..."
find "$HOME" -type l | while read -r link; do
  target=$(readlink -f "$link" || true)
  if [[ "$target" == "$BASE/"* ]] && [[ ! -e "$target" ]]; then
    echo "🗑 Removing stale symlink: $link → $target"
    rm "$link"
  fi
done

# 2) Recreate symlinks for all current dotfiles
echo "🔗 Linking dotfiles from $BASE to \$HOME"
find "$BASE" -type f \! -name '*.tmpl' | while read -r src; do
  rel="${src#$BASE/}"           # e.g. .config/kitty/theme.conf
  dst="$HOME/$rel"
  mkdir -p "$(dirname "$dst")"
  ln -sf "$src" "$dst"
  echo "  • $dst → $src"
done

echo "✅ link-dotfiles.sh complete."

