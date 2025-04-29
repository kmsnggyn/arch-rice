#!/usr/bin/env bash

# borders and margins
export BORDER0="#353535"
export BORDER1="#C2C2C2"
export BDRAD=10                   # radius
export BDTHK=2                   # thickness
export MGN=12                    # outside margin
export MGN_IN=$((MGN / 2))       # inside margin
export BARWD=$((1920 - 2 * MGN)) # bar width, based on 1920 width
export BARHT=36                  # bar height

# special
export BG="#212121"
export FG="#c8c8c8"
export CURSOR="#c8c8c8"

# normal
export BLACK="#2e2e2e"
export RED="#a54242"
export GREEN="#8c9440"
export YELLOW="#de935f"
export BLUE="#5f819d"
export MAGENTA="#85678f"
export CYAN="#5e8d87"
export WHITE="#707880"

# bright (_br)
export BLACK_BR="#414141"
export RED_BR="#cc6666"
export GREEN_BR="#b5bd68"
export YELLOW_BR="#f0c674"
export BLUE_BR="#81a2be"
export MAGENTA_BR="#b294bb"
export CYAN_BR="#8abeb7"
export WHITE_BR="#c5c8c6"

# opacity (0.0–1.0)
export OPAC1="${CS_OPAC1:-1.0}"
export OPAC0="${CS_OPAC2:-1}"

# Now generate ARGB versions for Hyprland (full opacity = 0xff)
for col in BLACK RED GREEN YELLOW BLUE MAGENTA CYAN WHITE \
  BLACK_BR RED_BR GREEN_BR YELLOW_BR BLUE_BR MAGENTA_BR CYAN_BR WHITE_BR BORDER0 BORDER1; do
  var="${col}"
  hex="${!var}"       # e.g. "#c5c8c6"
  hex_nop="${hex#\#}" # strips "#", gives "c5c8c6"
  export "${var}_ARGB=0xff${hex_nop}"
done
