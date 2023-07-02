#!/bin/bas

./aptinstall.sh
./symlink.sh

# Get all pgrades
sudo apt upgrade -y


if [ -d ~/.tmux/plugins/tpm ]; then
    echo "Directory already exists. Skipping cloning."
else
    echo "Directory does not exists. Cloning repo..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [ -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
    echo "Directory already exists. Skipping cloning."
else
    echo "Directory does not exists. Cloning repo..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi


if [ -d ~/.oh-my-zsh/custom/themes/powerlevel10k ]; then
    echo "Directory already exists. Skipping cloning."
else
    echo "Directory does not exists. Cloning repo..."
    git clone --depth=1 ttps://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

if [ -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
    echo "Directory already exists. Skipping cloning."
else
    echo "Directory does not exists. Cloning repo..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi
