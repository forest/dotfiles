# set or override options. two of my favorite are below.
#

# set the prompt
# autoload -Uz promptinit
# promptinit
# prompt steeef

# Automatically cd to frequently used directories http://robots.thoughtbot.com/post/10849086566/cding-to-frequently-used-directories-in-zsh
# setopt auto_cd
# cdpath=($HOME/code)

# Fancy globbing http://linuxshellaccount.blogspot.com/2008/07/fancy-globbing-with-zsh-on-linux-and.html
# setopt extendedglob

export GOPATH=$HOME/.go
export GOOGLE_CLOUD_SDK_PATH=$HOME/code/google-cloud-sdk
export JAVA_HOME=$(/usr/libexec/java_home)
export JIRA_HOME=~/code/jira_home
export PHPPATH=$(brew --prefix homebrew/php/php56)
# export HOMEBREW_PREFIX=/usr/local
export HOMEBREW_CELLAR=/usr/local/Cellar
export ERL_LIBS=$HOME/.kiex/elixirs/elixir-master/lib/elixir/lib

export PATH="./bin:./.bin:$HOME/bin:$HOME/.bin:/usr/local/homebrew/bin:$GOPATH/bin:$GOOGLE_CLOUD_SDK_PATH/bin:/usr/local:/usr/local/bin:/usr/local/sbin:$PATH"
#export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"
#export DYLD_LIBRARY_PATH="/usr/local/mysql/lib:$DYLD_LIBRARY_PATH"
export MSGMERGE_PATH="/usr/local/Cellar/gettext/0.18.1.1/bin/msgmerge"

# use .localrc for settings specific to one system
[[ -f ~/.localrc ]] && source ~/.localrc

# @see http://vim.1045645.n5.nabble.com/MacVim-and-PATH-tt3388705.html#a3392363
# Ensure MacVim has same shell as Terminal
# if [[ -a /etc/zshenv ]]; then
#   sudo mv /etc/zshenv /etc/zprofile
# fi

source /usr/local/share/zsh/site-functions/_aws

test -s "$HOME/.kiex/scripts/kiex" && source "$HOME/.kiex/scripts/kiex"

autoload bashcompinit
bashcompinit
source $HOME/.dotfiles/config/gh_complete.sh
