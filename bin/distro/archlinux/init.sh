#!/bin/bash

# bash ./user.sh

bash ../../../install/programs/yay.sh

bash ./packages.sh system
bash ./packages.sh dev

bash ../../../install/programs/neovim.sh

bash ./nvidia.sh
bash ./repos.sh
bash ./symlinks.sh
bash ./directories.sh

chsh -s $(which fish)
