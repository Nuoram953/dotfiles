#!/bin/bas

# ./aptinstall.sh
# ./pip.sh
./symlink.sh
./npm.sh

sudo apt upgrade -y

./plugins.sh
./scripts/hurl.sh

./neovim.sh

touch ~/.env_work.sh
touch ~/.aliases_work

#Oh My Zsh
chsh -s $(which fish)
