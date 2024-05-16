#!/bin/bas

./aptinstall.sh
./pip.sh
./symlink.sh
./npm.sh

# Get all pgrades
sudo apt upgrade -y

./plugins.sh
./scripts/hurl.sh

#Oh My Zsh
chsh -s $(which zsh)

#jira-cli
go install github.com/ankitpokhrel/jira-cli/cmd/jira@latest
jira init
