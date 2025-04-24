#!/bin/bash
set -e

echo "📦 Finalizing dotfiles..."

declare -a components=("hypr" "waybar" "kitty" "walker" "scripts")

for comp in "${components[@]}"; do
  src="$HOME/.dotfiles-pth/.config/$comp"
  dest="$HOME/.config/$comp"

  if [ -L "$dest" ]; then
    echo "🔁 Replacing symlinked $dest with real copy..."
    rm "$dest"
  elif [ -d "$dest" ]; then
    echo "📁 Backing up existing $dest to $dest.backup"
    mv "$dest" "$dest.backup"
  fi

  cp -r "$src" "$dest"
done

echo "✅ Dotfiles have been finalized into ~/.config"
echo "🧼 You can now safely delete ~/.dotfiles-pth if you wish."
