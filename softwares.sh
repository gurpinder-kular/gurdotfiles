#! /bin/bash
echo "##################################"
echo "Installing softwares."

sudo pacman -S flameshot mousepad evince gimp obs-studio mpv shotcut libreoffice-fresh bitwarden --noconfirm
yes y | yay -S spotify --answerdiff None --answerclean None

