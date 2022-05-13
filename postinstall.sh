#! /bin/bash
sudo pacman -Syyu --noconfirm
echo `##################################`
echo `Installing TWM env.`
sudo pacman -S xorg-server xorg-xinit xorg-xclipboard xclip xterm stow lxappearance qt5ct pcmanfm-qt bluez bluez-utils blueberry picom file-roller feh awesome kitty nitrogen playerctl pavucontrol ranger rofi rofi-calc rofi-emoji imagemagick breeze breeze-gtk breeze-icons gnome-keyring libsecret polkit lxqt-policykit network-manager-applet volumeicon libimobiledevice udisks2 ntfs-3g noto-fonts noto-fonts-emoji ttf-hack ttf-fira-sans ttf-fira-code ttf-font-awesome ttf-iosevka-nerd ttf-ibm-plex ttf-input zsh starship go rust python2 --noconfirm

# dot files
stow */

homepath="~/"
yaypath="/home/"$USER"/yay"
git clone https://aur.archlinux.org/yay.git $yaypath
cd $yaypath
makepkg -si

yay -S ttf-recursive surfn-icons-git

# enable services
sudo systemctl enable bluetooth.service

# fix bluetooth icon
gsettings set org.blueberry use-symbolic-icons false

# keyring 
sudo sed -i '/^auth       include      system-local-login$/a auth       optional     pam_gnome_keyring.so' /etc/pam.d/login
sudo sed -i '/^session    include      system-local-login$/a session    optional     pam_gnome_keyring.so auto_start
' /etc/pam.d/login

#env 
sudo sed -i '$ a QT_QPA_PLATFORMTHEME=qt5ct' /etc/environment

# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# oh my zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

rm -rf ~/.zshrc
rm -rf ~/.zprofile

cd /home/$USER/gurdotfiles/

stow zsh

# make zsh the default
sudo chsh -s /usr/bin/zsh

