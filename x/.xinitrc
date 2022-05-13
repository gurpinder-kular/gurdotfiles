#!/bin/sh

# xresources
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

# gnome keyring
eval $(gnome-keyring-daemon --start)
export SSH_AUTH_SOCK

# polkit
/usr/bin/lxqt-policykit-agent &

# picom
picom --config ~/.config/picom.conf --experimental-backends &

# applets
nm-applet &
volumeicon &

# wallpaper
nitrogen --restore &

# awesome
awesome 
