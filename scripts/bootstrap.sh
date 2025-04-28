#!/bin/bash
set -e

echo "🚀 Starting fresh Arch setup..."

# 1. Install essential packages
echo "📦 Installing core packages..."
sudo pacman -Syu --noconfirm
sudo pacman -S --needed \
  git \
  curl \
  --noconfirm

# 2. Remove Firefox (if preinstalled)
echo "🗑️ Removing Firefox..."
sudo pacman -Rns firefox --noconfirm || echo "Firefox not installed. Skipping."

# 3. Clone your dotfiles
echo "📥 Cloning dotfiles repo..."
git clone git@github.com:kmsnggyn/dotfiles-pth.git ~/.dotfiles-pth

# 4. Run setup
echo "🔧 Running setup.sh..."
~/.dotfiles-pth/scripts/setup.sh

echo "✅ Bootstrap complete. Welcome to the rice."
