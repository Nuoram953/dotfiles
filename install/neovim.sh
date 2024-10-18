#!/bin/bash

cd ~
git clone https://github.com/neovim/neovim
cd neovim && make CMAKE_BUILD_TYPE=Release
git checkout stable
sudo make install
