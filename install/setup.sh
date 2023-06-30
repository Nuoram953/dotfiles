#!/bin/bas

./symlink.sh
./aptinstall.sh

# Get all pgrades
sudo apt upgrade -yu


git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone --depth=1 ttps://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10kh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
