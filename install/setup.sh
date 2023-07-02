#!/bin/bas

./aptinstall.sh
./symlink.sh

# Get all pgrades
sudo apt upgrade -y

./plugins.sh

#Oh My Zsh
chsh -s $(which zsh)
