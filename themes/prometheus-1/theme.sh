#!/usr/bin/env bash

# File: theme.sh
# Theme variables for the "prometheus-1" scheme
# Located in themes/prometheus-1/theme.sh

# Borders and margins
export BORDER0="#353535"
export BORDER1="#C2C2C2"
export BDRAD=10                   # radius (px)
export BDTHK=2                    # thickness (px)
export MGN=12                     # outside margin (px)
export MGN_IN=$((MGN / 2))        # inside margin (px)
export BARWD=$((1920 - 2 * MGN))  # bar width for 1920px screen
export BARHT=36                   # bar height (px)

# Special colors
export BG="#212121"
export FG="#c8c8c8"
export CURSOR="#c8c8c8"

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
export CYAN_BR="#8abeb7b"
export WHITE_BR="#c5c8c6"

# Opacity (0.0–1.0)
export OPAC1="0.9"
export OPAC0="0.8"

# Compute alpha hex from OPAC1
alpha_dec=$(echo "$OPAC1 * 255" | bc -l)
alpha_int=$(printf "%.0f" "$alpha_dec")
export ALPHA_HEX=$(printf '%02x' "$alpha_int")

# Generate ARGB variants using ALPHA_HEX for all base colors including BG and FG
for col in BG FG BLACK RED GREEN YELLOW BLUE MAGENTA CYAN WHITE \
           BLACK_BR RED_BR GREEN_BR YELLOW_BR BLUE_BR MAGENTA_BR CYAN_BR WHITE_BR \
           BORDER0 BORDER1; do
  hex="${!col}"
  hex_nop="${hex#\#}"
  export "${col}_ARGB=0x${ALPHA_HEX}${hex_nop}"
done

# GTK & Icon theme settings
export GTK_THEME_NAME="PrometheusDark"
export GTK_FONT="Inter 11"
export GTK_SELECTION_BG="$ACCENT"
export GTK_SUCCESS_BG="#50FA7B"
export ICON_THEME_NAME="Papirus"

