#!/usr/bin/env bash
# ~/.config/colors/colors-sg.sh
# Central “colors‑sg” palette for all your configs

# borders and margins
export CS_BORDER0="#353535"
export CS_BORDER1="#C2C2C2"
export BDRAD=8		# radius
export BDTHK=2		# thickness
export MGN=8	# outside margin
export MGN_IN=$((MGN/2))	# inside margin
export BARWD=$((1920-2*MGN))	# bar width, based on 1920 width
export BARHT=36				# bar height

# special
export CS_BG="#212121"
export CS_FG="#c8c8c8"
export CS_CURSOR="#c8c8c8"

# normal
export CS_BLACK="#2e2e2e"
export CS_RED="#a54242"
export CS_GREEN="#8c9440"
export CS_YELLOW="#de935f"
export CS_BLUE="#5f819d"
export CS_MAGENTA="#85678f"
export CS_CYAN="#5e8d87"
export CS_WHITE="#707880"

# bright (_br)
export CS_BLACK_BR="#414141"
export CS_RED_BR="#cc6666"
export CS_GREEN_BR="#b5bd68"
export CS_YELLOW_BR="#f0c674"
export CS_BLUE_BR="#81a2be"
export CS_MAGENTA_BR="#b294bb"
export CS_CYAN_BR="#8abeb7"
export CS_WHITE_BR="#c5c8c6"

# opacity (0.0–1.0)
export CS_OPAC1="${CS_OPAC1:-1.0}"
export CS_OPAC0="${CS_OPAC2:-1}"


# Now generate ARGB versions for Hyprland (full opacity = 0xff)
for col in BLACK RED GREEN YELLOW BLUE MAGENTA CYAN WHITE \
           BLACK_BR RED_BR GREEN_BR YELLOW_BR BLUE_BR MAGENTA_BR CYAN_BR WHITE_BR BORDER0 BORDER1; do
  var="CS_${col}"
  hex="${!var}"                # e.g. "#c5c8c6"
  hex_nop="${hex#\#}"          # strips "#", gives "c5c8c6"
  export "${var}_ARGB=0xff${hex_nop}"
done
