#!/bin/bas

# ./aptinstall.sh
# ./pip.sh
./symlink.sh
./npm.sh

# Get all pgrades
sudo apt upgrade -y

./plugins.sh
./scripts/hurl.sh

./neovim.sh

# Create optinal files that is used in zsh config
touch ~/.env_work.sh
touch ~/.aliases_work

#Oh My Zsh
chsh -s $(which zsh)

#jira-cli
go install github.com/ankitpokhrel/jira-cli/cmd/jira@latest
jira init
