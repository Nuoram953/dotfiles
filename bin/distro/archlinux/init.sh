#!/bin/bash

bash ./packages.sh
bash ./nvidia.sh
bash ./repos.sh
bash ./symlinks.sh
bash ./directories.sh

chsh -s $(which fish)
