#!/bin/bash

# bash ./user.sh

bash ../../../install/programs/yay

bash ./packages.sh system
bash ./packages.sh dev

bash ../../../install/programs/neovim
bash ../../../install/programs/tpm
bash ../../../install/programs/fisher

bash ./nvidia.sh
bash ./repos.sh
bash ./symlinks.sh
bash ./directories.sh

chsh -s $(which fish)
