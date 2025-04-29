# Arch Rice Theme & Dotfiles Framework

A comprehensive, theme-driven dotfiles management framework for Arch Linux (or any distro). This repository provides:

- A **mirror** of selected dotfiles (`~/arch-rice/dotfiles/`) with templates (`*.tmpl`) and rendered outputs
- Per-theme configurations under `themes/<theme>/theme.sh` (colors, layout, GTK / icon settings)
- Scripts to **render**, **link**, and **clean up** your dotfiles into `~/.config/` and home
- A **bootstrap** script to install/update on fresh machines with optional backups

---

## 🌳 Repository Layout

```
~/arch-rice/
├── dotfiles/                     # Mirror of select $HOME files
│   ├── .config/                  # Mirrors ~/.config
│   │   ├── hypr/
│   │   │   ├── hyprland.conf.tmpl
│   │   │   └── hyprland.conf
│   │   ├── waybar/
│   │   │   ├── config.toml.tmpl
│   │   │   └── config.toml
│   │   └── ...                   # kitty, mako, wofi, gtk-3.0, gtk-4.0, etc.
│   ├── .bashrc.tmpl
│   ├── .bashrc
│   ├── .gitconfig.tmpl
│   └── .gitconfig
│
├── themes/                       # Theme definitions
│   └── prometheus-1/
│       ├── theme.sh              # Exports all colors/layouts/ARGB etc.
│       └── assets/               # e.g. wallpapers, icons, overrides
│
└── scripts/                      # Automation scripts
    ├── bootstrap.sh              # Clone/update, render, backup, link (interactive)
    ├── render-dotfiles.sh        # Render all *.tmpl → rendered files in dotfiles/
    ├── link-dotfiles.sh          # Symlink dotfiles → $HOME, with stale cleanup
    └── switch-theme.sh           # (Optional) Switch between themes and rerun render/link
```

---

## 📦 Prerequisites

- **bash** (v4+)
- **envsubst** (from GNU gettext)
- **git**
- **bc** (for opacity calculations)
- **ln**, **find**, **readlink** (standard Unix utilities)

Install on Arch with:
```bash
sudo pacman -S git bash gettext bc
```

---

## 🚀 Installation & Bootstrap

Clone and run the bootstrap script:

```bash
cd ~
git clone https://github.com/youruser/arch-rice.git
cd arch-rice
scripts/bootstrap.sh -r -b -l
```

Flags:
- `-r`: render all templates immediately (skip prompt)
- `-b`: backup existing dotfiles (`~/.config.backup/`) before linking
- `-l`: link rendered files into `$HOME` immediately

Interactive mode (no flags) will prompt at each phase.

---

## 🎨 Rendering Templates

To re-render after editing any `*.tmpl` or theme variables:

```bash
scripts/render-dotfiles.sh <theme-name>
```

Example:
```bash
scripts/render-dotfiles.sh prometheus-1
```

This:
1. Sources `themes/<theme-name>/theme.sh` (exports variables)
2. Runs `envsubst` on every file under `dotfiles/` ending in `.tmpl`
3. Writes rendered files alongside the templates

---

## 🔗 Linking & Stale Cleanup

**`link-dotfiles.sh`** does two things:

1. **Cleans up** stale symlinks in `$HOME` that point to removed files in `~/arch-rice/dotfiles`
2. **Recreates** per-file symlinks from `~/arch-rice/dotfiles/...` → `$HOME/...`

This ensures your home always reflects exactly what’s in your repo mirror.

---

## 🗂 Managing Themes

1. **Add** a new folder under `themes/`, e.g. `themes/solarized/`.
2. **Create** `theme.sh` exporting your color palette, layout vars, and ARGB variants.
3. **(Optional)** Add assets: `themes/solarized/assets/wallpaper.png`.
4. **Switch** by editing `scripts/switch-theme.sh` or symlinking `~/.config/themes/current/` → your theme folder.
5. **Rerun**:
   ```bash
   scripts/render-dotfiles.sh solarized
   scripts/link-dotfiles.sh
   ```

---

## 🖼 Wallpaper & Assets

Place per-theme assets under `themes/<name>/assets/`. You can reference them in templates:

```ini
# hyprland.conf.tmpl
wallpaper = "${THEME_ASSETS}/wallpaper-4k.png"
```

And set `export THEME_ASSETS="$HOME/arch-rice/themes/<name>/assets"` in `theme.sh`.

---

## 🔄 Auto-Render on Save (Optional)

Use `inotifywait` or an editor plugin to watch for changes and auto-run:

```bash
while inotifywait -e close_write -r dotfiles/* themes/*; do
  scripts/render-dotfiles.sh prometheus-1 && scripts/link-dotfiles.sh
done
```

---

## 🖥️ Per-Host Overrides

Create `themes/<name>/theme.local.sh` exporting/overriding variables for specific machines:

```bash
# theme.local.sh
export BARHT=32  # shorter bar on laptop screen
```

Modify `render-dotfiles.sh` to source `theme.local.sh` if present.

---

## 🏷️ Versioning & Releases

Use Git tags for stable theme snapshots:
```bash
git tag v1.0-prometheus
git push --tags
```

---

## 🙌 Contributing

- Fork & clone this repo
- Add your theme under `themes/`
- Build templates, test rendering/linking
- Send a PR!

---

## 📜 License

MIT © Seonggyun Kim
