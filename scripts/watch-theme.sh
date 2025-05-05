#!/usr/bin/env bash
set -u -o pipefail

# ─── Resolve dirs ─────────────────────────────────────────────────────────
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
base_dir="$script_dir/.."
dotfiles_dir="$base_dir/dotfiles"
themes_dir="$base_dir/themes"

# ─── Determine current theme ───────────────────────────────────────────────
if [[ -L "$themes_dir/current" ]]; then
  THEME="$(basename "$(readlink "$themes_dir/current")")"
else
  echo "No 'themes/current' symlink found – run switch-theme.sh first." >&2
  exit 1
fi

echo "Watching templates for theme '$THEME'…"

# ─── Locate swaync binaries ───────────────────────────────────────────────
SWAYNC_BIN="$(dirname "$(command -v swaync 2>/dev/null || true)")"
if [[ -z "$SWAYNC_BIN" || ! -x "$SWAYNC_BIN/swaync" || ! -x "$SWAYNC_BIN/swaync-client" ]]; then
  echo "Cannot locate swaync in your PATH. Install it or add it to PATH." >&2
  exit 1
fi

# ─── Directories to watch ─────────────────────────────────────────────────
WATCH_DIRS=(
  "$dotfiles_dir/.config/waybar"
  "$dotfiles_dir/.config/hypr"
  "$dotfiles_dir/.config/kitty"
  "$dotfiles_dir/.config/swaync"
  "$dotfiles_dir/.config/wofi"
)

# ─── Startup check ─────────────────────────────────────────────────────────
for d in "${WATCH_DIRS[@]}"; do
  [[ -d "$d" ]] || { echo "Watch directory missing: $d" >&2; exit 1; }
done

# ─── Helper functions ───────────────────────────────────────────────────────
restart_swaync() {
  pkill -x swaync 2>/dev/null || true
  "$SWAYNC_BIN/swaync" &
}

reload_swaync() {
  restart_swaync
  "$SWAYNC_BIN/swaync-client" -rs

  # ─── Test notifications for Spotify and Thunderbird ──────────────────────
  notify-send \
    -a Spotify \
    -i spotify \
    --hint=string:desktop-entry:spotify \
    "Spotify: Playback paused" \
    "Track \"Hotel California\" has been paused."

  notify-send \
    -a Thunderbird \
    -i thunderbird \
    --hint=string:desktop-entry:thunderbird \
    "Thunderbird: New message" \
    "From: alice@example.com\nSubject: Meeting notes"
}

restart_waybar() {
  if pgrep -x waybar &>/dev/null; then
    killall waybar && sleep 0.5
  fi
  waybar & disown
}

reload_hyprland() {
  hyprctl reload &>/dev/null && echo "Hyprland reloaded." || echo "hyprctl reload failed." >&2
}

reload_kitty() {
  if pkill -SIGUSR1 -x kitty &>/dev/null; then
    echo "Kitty config reloaded."
  else
    echo "No running kitty instances to reload." >&2
  fi
}

# ─── Initial start of swaync ───────────────────────────────────────────────
restart_swaync

# ─── Monitor for writes and moves ─────────────────────────────────────────
inotifywait -m -r \
  -e close_write,moved_to \
  --format '%w%f' \
  "${WATCH_DIRS[@]}" |
while read -r path; do
  [[ "$path" == *.tmpl ]] || continue
  echo "Detected change in template: $path"

  case "$path" in
    "$dotfiles_dir/.config/waybar/"*)
      echo "→ Waybar templates changed. Regenerating + restarting Waybar…"
      if "$script_dir/render-dotfiles.sh" -t "$THEME" waybar; then
        restart_waybar
        echo "Waybar restarted."
      else
        echo "Waybar render failed—continuing." >&2
      fi
      ;;

    "$dotfiles_dir/.config/hypr/"*)
      echo "→ Hyprland templates changed. Regenerating + reloading Hyprland…"
      if "$script_dir/render-dotfiles.sh" -t "$THEME" hypr; then
        reload_hyprland
      else
        echo "Hyprland render failed—continuing." >&2
      fi
      ;;

    "$dotfiles_dir/.config/kitty/"*)
      echo "→ Kitty templates changed. Regenerating + reloading Kitty…"
      if "$script_dir/render-dotfiles.sh" -t "$THEME" kitty; then
        reload_kitty
      else
        echo "Kitty render failed—continuing." >&2
      fi
      ;;

    "$dotfiles_dir/.config/swaync/"*)
      echo "→ SwayNC templates changed. Regenerating + reloading SwayNC…"
      if "$script_dir/render-dotfiles.sh" -t "$THEME" swaync; then
        reload_swaync
        echo "SwayNC reloaded."
      else
        echo "SwayNC render failed—continuing." >&2
      fi
      ;;

    "$dotfiles_dir/.config/wofi/"*)
      echo "→ Wofi templates changed. Regenerating Wofi…"
      if "$script_dir/render-dotfiles.sh" -t "$THEME" wofi; then
        echo "Wofi config regenerated."
      else
        echo "Wofi render failed—continuing." >&2
      fi
      ;;

    *) echo "→ Change in unrecognized dir: $path";;
  esac

  # debounce rapid saves
  sleep 0.5
done
