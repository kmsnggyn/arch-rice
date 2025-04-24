#!/bin/bash
set -e

echo "🧼 Finalizing dotfiles – converting symlinks to real folders..."

for link in "$HOME/.config/"*; do
  # Only process symlinks
  if [ -L "$link" ]; then
    target=$(readlink "$link")

    # Only process symlinks pointing to ~/.dotfiles-pth
    if [[ "$target" == $HOME/.dotfiles-pth/* ]]; then
      comp=$(basename "$link")
      src="$target"
      dest="$HOME/.config/$comp"

      echo "🔁 Replacing symlinked $comp with real files..."

      rm "$dest"
      cp -r "$src" "$dest"
      echo "✅ Finalized $comp"
    fi
  fi
done
