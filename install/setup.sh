#!/bin/bas

./aptinstall.sh
./pip.sh
./symlink.sh

# Get all pgrades
sudo apt upgrade -y

./plugins.sh
./scripts/hurl.sh

#Oh My Zsh
chsh -s $(which zsh)

# ./neovim.sh
