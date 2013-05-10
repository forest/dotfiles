# set or override options. two of my favorite are below.
#

# set the prompt
# autoload -Uz promptinit
# promptinit
# prompt steeef

# Automatically cd to frequently used directories http://robots.thoughtbot.com/post/10849086566/cding-to-frequently-used-directories-in-zsh
setopt auto_cd
cdpath=($HOME/code)

# Fancy globbing http://linuxshellaccount.blogspot.com/2008/07/fancy-globbing-with-zsh-on-linux-and.html
setopt extendedglob

export PATH="./bin:$HOME/bin:$HOME/.bin:/usr/local/homebrew/bin:/usr/local/heroku/bin:/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:$PATH"
#export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"
#export DYLD_LIBRARY_PATH="/usr/local/mysql/lib:$DYLD_LIBRARY_PATH"
export MSGMERGE_PATH="/usr/local/Cellar/gettext/0.18.1.1/bin/msgmerge"

# use .localrc for settings specific to one system
[[ -f ~/.localrc ]] && source ~/.localrc

# @see http://vim.1045645.n5.nabble.com/MacVim-and-PATH-tt3388705.html#a3392363
# Ensure MacVim has same shell as Terminal
if [[ -a /etc/zshenv ]]; then
  sudo mv /etc/zshenv /etc/zprofile
fi
