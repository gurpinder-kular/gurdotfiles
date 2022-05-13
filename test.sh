#! /bin/bash

sed -i '/^auth       include      system-local-login$/a auth       optional     pam_gnome_keyring.so' ./login
sed -i '/^session    include      system-local-login$/a session    optional     pam_gnome_keyring.so auto_start
' ./login
# sed -i "$ a session    optional     pam_gnome_keyring.so auto_start
# " ./login
# sed -i "$ a auth       optional     pam_gnome_keyring.so" ./login
