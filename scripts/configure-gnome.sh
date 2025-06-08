#!/bin/bash
#
# Author   : Gaston Gonzalez
# Date     : 16 March 2024
# Updated  : 8 June 2025
# Purpose  : Configure GNOME

et-log "Configuring GNOME..."

cp ../overlay/usr/share/glib-2.0/schemas/90_ubuntu-settings.gschema.override \
  /usr/share/glib-2.0/schemas/

cp ../overlay/usr/share/icons/*.png \
  /usr/share/icons/
chmod 644 /usr/share/icons/et-*.png

glib-compile-schemas /usr/share/glib-2.0/schemas/

# Lock screen to one orientation
gsettings set org.gnome.settings-daemon.peripherals.touchscreen orientation-lock true
