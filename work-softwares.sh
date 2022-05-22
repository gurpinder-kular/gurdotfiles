#! /bin/bash
echo "##################################"
echo "Installing softwares."

sudo pacman -S docker docker-compose --noconfirm
sudo systemctl enable docker.service
sudo usermod -aG docker $USER
yay -S visual-studio-code-bin insomnia-bin mongodb-compass mailspring zoom --answerdiff None --answerclean None

