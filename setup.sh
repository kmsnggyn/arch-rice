#!/bin/bash
set -e

echo "🌱 Fresh Arch setup started..."

# 1. Install essential packages
sudo pacman -S --needed hyprland waybar kitty zsh git base-devel wget --noconfirm

# 2. Clone your dotfiles (if not already there)
# git clone git@github.com:kmsnggyn/arch-rice.git ~/Documents/arch-rice

# 3. Symlink config folders
echo "🔗 Linking config folders..."
ln -sf ~/Documents/arch-rice/.config/hypr ~/.config/hypr
ln -sf ~/Documents/arch-rice/.config/waybar ~/.config/waybar
ln -sf ~/Documents/arch-rice/.config/kitty ~/.config/kitty
ln -sf ~/Documents/arch-rice/.config/walker ~/.config/walker
ln -sf ~/Documents/arch-rice/.config/scripts ~/.config/scripts

# 4. Set up theme symlink
echo "🎨 Setting theme to Prometheus..."
ln -sf ~/.config/themes/prometheus ~/.config/themes/current

# 5. Render templates using envsubst
echo "🛠️ Rendering templates..."
~/.config/scripts/render-dotfiles.sh

echo "✅ Setup complete. Please restart your session or source configs."
