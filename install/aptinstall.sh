#!/bin/bash


sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update

curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

function install {
  which $1 &> /dev/null

  if [ $? -ne 0 ]; then
    echo "Installing: ${1}..."
    sudo apt install -y $1
  else
    echo "Already installed: ${1}"
  fi
}

# Basics
install awscli
install curl
install exfat-utils
install file
install git
install htop
install nmap
install openvpn
install tmux
install neovim
install zsh
install build-essential
install libreadline-dev
install unzip
install exa
install npm
install expect

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
