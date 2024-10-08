#!/bin/sh

#######################################################
# bootstrap.sh
# This script sets up a laptop the way that I like it.
#######################################################

set -e

dir=~/dotfiles
olddir=~/dotfiles_old

fancy_echo() {
  local fmt="$1"; shift

  printf "\n$fmt\n" "$@"
}

# fancy_echo "Setting MacOs defaults..."
# source ~/dotfiles/set-defaults.sh

if ! command -v brew >/dev/null; then
  fancy_echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew tap homebrew/bundle
fi

if ! command -v git >/dev/null; then
  brew install git
fi

if [ ! -d "$HOME/bin" ]; then
  fancy_echo "Creating bin directory..."
  mkdir ~/bin
fi

fancy_echo "Updating Homebrew..."
brew update
brew bundle --file=$HOME/dotfiles/Brewfile

fancy_echo "Linking dotfiles..."
env RCRC=$HOME/dotfiles/rcrc rcup

# install ohmyzsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


# if [[ ! $(psql -U postgres -c '\du' | grep 'postgres') ]]
# then
#   fancy_echo "Setting up postgres"
#   # ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
#   # launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
#   pg_ctl -D /usr/local/var/postgres start
#   createuser -s postgres
# fi
