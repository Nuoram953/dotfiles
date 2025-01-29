#!/bin/bash

cd ~
if [ ! -d "neovim" ]; then
    echo "Cloning Neovim repository..."
    git clone https://github.com/neovim/neovim
else
    echo "Neovim directory already exists, skipping clone..."
fi
cd neovim 
make distclean
rm -rf build
make CMAKE_BUILD_TYPE=Release
git checkout main
sudo make install
