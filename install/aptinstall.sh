#!/bin/bash


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

install awscli
install curl
install exfat-utils
install file
install git
install htop
install nmap
install openvpn
install zsh
install build-essential
install libreadline-dev
install unzip
install exa
install npm
install expect
install sed
install ripgrep
install python3-pip
install jq
install ruby-full
install ninja-build
install gettext
install cmake
install go-lang
install bat
install fd-find
install git-delta
install mysql-client
install fzf
install gettext
install xclip
# install openjdk-17-jdk #No need to always install java stuff

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

curl -sS https://starship.rs/install.sh | sh

curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

