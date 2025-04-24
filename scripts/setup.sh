#!/bin/bash
set -e

echo "🌱 Starting Arch dotfiles setup..."

# ----------------------------------------
# 1. Install essential packages
# ----------------------------------------

echo "📦 Installing core packages..."
sudo pacman -Syu --noconfirm
sudo pacman -S --needed \
  git \
  base-devel \
  kitty \
  zsh \
  zenity \
  wget \
  unzip \
  curl \
  --noconfirm
yay -S --needed libinput-three-finger-drag

# ----------------------------------------
# 2. Interactive config folder linking
# ----------------------------------------

echo ""
echo "📋 Scanning available components in ~/.dotfiles-pth/.config/..."
echo "Select which ones to link (y/n):"

for src in "$HOME/.dotfiles-pth/.config/"*; do
  comp=$(basename "$src")
  target="$HOME/.config/$comp"

  read -rp "🛠️  Sync $comp? [y/N]: " answer
  case "$answer" in
  [yY][eE][sS] | [yY])
    # Back up existing folder or symlink
    if [ -L "$target" ]; then
      echo "🧹 Removing symlink: $target"
      rm "$target"
    elif [ -e "$target" ]; then
      backup="${target}.backup"
      if [ -e "$backup" ]; then
        timestamp=$(date +%s)
        backup="${backup}_${timestamp}"
      fi
      echo "📁 Backing up existing $target → $backup"
      mv "$target" "$backup"
    fi

    echo "✅ Linking $target → $src"
    ln -sf "$src" "$target"
    ;;
  *)
    echo "⏩ Skipping $comp"
    ;;
  esac
done

# ----------------------------------------
# 3. Copy themes and set current
# ----------------------------------------

echo ""
echo "🎨 Copying themes into ~/.config/themes..."

if [ -e "$HOME/.config/themes" ] && [ ! -L "$HOME/.config/themes" ]; then
  backup="$HOME/.config/themes.backup"
  if [ -e "$backup" ]; then
    timestamp=$(date +%s)
    backup="${backup}_${timestamp}"
  fi
  echo "📁 Backing up existing ~/.config/themes → $backup"
  mv "$HOME/.config/themes" "$backup"
fi

cp -r ~/.dotfiles-pth/.config/themes ~/.config/

echo "🔁 Setting current theme → prometheus"
ln -sf ~/.config/themes/prometheus ~/.config/themes/current

# ----------------------------------------
# 4. Render template files
# ----------------------------------------

echo ""
echo "🛠️ Rendering templates using theme variables..."
~/.config/scripts/render-dotfiles.sh

echo ""
echo "✅ Setup complete. Your system is now riced and ready."
