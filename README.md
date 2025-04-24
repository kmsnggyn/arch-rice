# Fresh Arch setup

## 🛠️ Setup Scripts
- `scripts/setup.sh` – installs packages, creates symlinks, sets theme
- `scripts/finalize-dotfiles.sh` – copies configs into ~/.config and removes symlink dependency

1. Touchpad settings
- Disable tap to drag
- Enable three finger drag

2. Set up the envsubst theme managing system
- ~/.config/scripts/render-dotfiles.sh
- ~/.config/scrpits/watch-theme.sh
- ~/.config/themes/current (as a symlink to the theme of choice)
- ~/.config/themes/prometheus/theme.sh  (the default theme)
- ~/.config/themes/vars.list

3. Set up `.tmpl` files using `envsubst`
- Set up .tmpl files
  - ~/.config/hypr/hyprland.conf
  - ~/.config/hypr/hyprland.conf.tmpl
  - ~/.config/waybar/config.jsonc
  - ~/.config/waybar/config.jsonc.tmpl
  - ~/.config/walker/themes/prometheus.css
  - ~/.config/walker/themes/prometheus.css.tmpl
  - ~/.config/walker/themes/prometheus.toml
  - ~/.config/walker/themes/prometheus.toml.tmpl

