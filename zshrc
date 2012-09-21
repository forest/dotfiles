#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

# Cobble togther yadr and prezto until yard does it.
yadr=$HOME/.yadr

# source every zsh file in user's custom/zsh/before. This is useful for setting theme and plugins.
if [[ -d $yadr/custom/zsh/before ]]; then
  for config_file ($yadr/custom/zsh/before/*) source $config_file
fi

# Configuration
for config_file ($yadr/zsh/*.zsh) source $config_file

# ------------------
# zsh/after
# ==================
# source every zsh file in user's custom/zsh/after.
if [[ -d $yadr/custom/zsh/after ]]; then
  for config_file ($yadr/custom/zsh/after/*) source $config_file
fi

# Put secret configuration settings in ~/.secrets
if [[ -a ~/.secrets ]] then
  source ~/.secrets
fi
