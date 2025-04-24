#!/bin/bash
set -e

#!/bin/bash
set -e

echo "🌱 Fresh Arch setup started..."

# 1. Install essential packages
echo "📦 Installing core packages..."
sudo pacman -Syu --noconfirm
sudo pacman -S --needed \
  git \
  base-devel \
  libinput \
  kitty \
  zsh \
  zenity \
  wget \
  unzip \
  curl \
  --noconfirm

# 2. Symlink config folders

# Remove existing config if it exists and is not already a symlink
if [ -e "$HOME/.config/hypr" ] && [ ! -L "$HOME/.config/hypr" ]; then
  echo "⚠️ Backing up existing ~/.config/hypr"
  mv ~/.config/hypr ~/.config/hypr.backup
fi

# Create symlink
ln -sf ~/.dotfiles-pth/.config/hypr ~/.config/hypr

echo "🔗 Linking config folders..."
ln -sf ~/.dotfiles-pth/.config/hypr ~/.config/hypr
ln -sf ~/.dotfiles-pth/.config/waybar ~/.config/waybar
ln -sf ~/.dotfiles-pth/.config/kitty ~/.config/kitty
ln -sf ~/.dotfiles-pth/.config/walker ~/.config/walker
ln -sf ~/.dotfiles-pth/.config/scripts ~/.config/scripts

# 3. Copy themes instead of symlinking
echo "🎨 Copying themes to ~/.config"
cp -r ~/.dotfiles-pth/.config/themes ~/.config/

# 4. Symlink only the active theme as 'current'
ln -sf ~/.config/themes/prometheus ~/.config/themes/current

# 5. Render templates
echo "🛠️ Rendering templates..."
~/.config/scripts/render-dotfiles.sh

echo "✅ Setup complete. You may now rice in peace."
