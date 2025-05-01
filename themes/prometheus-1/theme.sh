#!/usr/bin/env bash

# File: theme.sh
# Theme variables for the "prometheus-1" scheme
# Located in themes/prometheus-1/theme.sh

# ─────────────────────────────────────────────────────────────────────────────
# Borders and margins
export BORDER0="#353535"
export BORDER1="#C2C2C2"
export BDRAD=10                   # radius (px)
export BDTHK=2                    # thickness (px)
export MGN=8                    # outside margin (px)
export MGN_IN=$((MGN / 2))        # inside margin (px)
export BARWD=$((1920 - 2 * MGN))  # bar width for 1920px screen
export BARHT=36                   # bar height (px)

# ─────────────────────────────────────────────────────────────────────────────
# Special colors
export BG="#212121"
export FG="#c8c8c8"

# Normal colors
export BLACK="#2e2e2e"
export RED="#a54242"
export GREEN="#8c9440"
export YELLOW="#de935f"
export BLUE="#5f819d"
export MAGENTA="#85678f"
export CYAN="#5e8d87"
export WHITE="#707880"

# Bright variants (_BR)
export BLACK_BR="#414141"
export RED_BR="#cc6666"
export GREEN_BR="#b5bd68"
export YELLOW_BR="#f0c674"
export BLUE_BR="#81a2be"
export MAGENTA_BR="#b294bb"
export CYAN_BR="#8abeb7"
export WHITE_BR="#c5c8c6"

# ─────────────────────────────────────────────────────────────────────────────
# Opacity (0.0–1.0)
export OPAC1=0.995   # nearly opaque
export OPAC0=0.9     # more transparent

# Compute hex from opacity floats: FF=1.0, 00=0.0
float_to_int() {
  # usage: float_to_int 0.995
  awk -v v="$1" 'BEGIN { printf "%d", v*255 + 0.5 }'
}

for VAR in OPAC1 OPAC0; do
  VAL=${!VAR}
  DEC=$(float_to_int "$VAL")
  HEX=$(printf '%02X' "$DEC")
  export "${VAR}_HEX"="$HEX"
done
# e.g. OPAC1_HEX="FE", OPAC0_HEX="E6"

# ─────────────────────────────────────────────────────────────────────────────
# Generate ARGB variants using OPAC1_HEX for all base colors
for col in BG FG BLACK RED GREEN YELLOW BLUE MAGENTA CYAN WHITE \
           BLACK_BR RED_BR GREEN_BR YELLOW_BR BLUE_BR MAGENTA_BR CYAN_BR WHITE_BR \
           BORDER0 BORDER1; do
  hex="${!col}"
  hex_nop="${hex#\#}"
  export "${col}_ARGB"="0x${OPAC1_HEX}${hex_nop}"
done

# ─────────────────────────────────────────────────────────────────────────────
# GTK & Icon theme settings
export GTK_THEME_NAME="PrometheusDark"
export GTK_FONT="Inter 11"
export GTK_SELECTION_BG="$CYAN_BR"
export GTK_SUCCESS_BG="#50FA7B"
export ICON_THEME_NAME="Papirus"
