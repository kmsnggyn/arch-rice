#!/usr/bin/env bash
set -euo pipefail

# Usage: bootstrap.sh [-r] [-b] [-l]
#   -r  Render templates immediately (skip prompt)
#   -b  Backup existing dotfiles before linking
#   -l  Link dotfiles into $HOME immediately (skip prompt)
# If you omit -r or -l, it will ask interactively.

RENDER=false
BACKUP=false
LINK=false

while getopts ":rblh" opt; do
  case "$opt" in
    r) RENDER=true ;;
    b) BACKUP=true ;;
    l) LINK=true ;;
    h) echo "Usage: $0 [-r] [-b] [-l]"; exit 0 ;;
    *) echo "Invalid option: -$OPTARG"; exit 1 ;;
  esac
done

# Resolve paths
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
base_dir="$script_dir/.."
cd "$base_dir"

# 1) Clone or update the repo
if [[ ! -d "$base_dir/.git" ]]; then
  echo "📥 Cloning arch-rice into $base_dir"
  git clone <https://github.com/kmsnggyn/arch-rice.git> "$base_dir"
else
  echo "🔄 Updating arch-rice"
  git pull
fi

# 2) Render templates?
if ! $RENDER; then
  read -p "Render templates now? [Y/n] " resp
  [[ -z "$resp" || "$resp" =~ ^[Yy] ]] && RENDER=true
fi
if $RENDER; then
  echo "🎨 Rendering templates..."
  "$script_dir/render-dotfiles.sh" prometheus-1
fi

# 3) Backup existing files?
if $BACKUP; then
  echo "💾 Backing up existing dotfiles to ~/.config.backup"
  mkdir -p "$HOME/.config.backup"
  find dotfiles -type f \! -name '*.tmpl' | while read -r f; do
    target="$HOME/${f#dotfiles/}"
    if [[ -e $target && ! -L $target ]]; then
      dest="$HOME/.config.backup/${f#dotfiles/}"
      mkdir -p "$(dirname "$dest")"
      mv "$target" "$dest"
      echo "  • $target → $dest"
    fi
  done
fi

# 4) Link dotfiles?
if ! $LINK; then
  read -p "Link dotfiles into ~/ now? [Y/n] " resp
  [[ -z "$resp" || "$resp" =~ ^[Yy] ]] && LINK=true
fi
if $LINK; then
  echo "🔗 Creating symlinks..."
  "$script_dir/link-dotfiles.sh"
fi

echo "✅ Bootstrap complete!"

