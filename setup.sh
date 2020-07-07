#!/usr/bin/env bash

# Install Homebrew
curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install

# Install asdf
brew install asdf

# Install direnv
asdf plugin-add direnv
asdf install direnv 2.21.3
asdf global  direnv 2.21.3

# Cheat Sheets
curl https://cht.sh/:cht.sh > ~/bin/cht.sh
chmod +x ~/bin/cht.sh
