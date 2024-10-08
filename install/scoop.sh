#!/bin/bash
#

cmd.exe /C "scoop bucket add extras"

function install {
  which $1 &> /dev/null

  if [ $? -ne 0 ]; then
    echo "Installing: ${1}..."
    scoop install $1
  else
    echo "Already installed: ${1}"
  fi
}

install delta
install lazydocker
install lazygit
install terraform
