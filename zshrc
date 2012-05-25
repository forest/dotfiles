# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# sunrise
ZSH_THEME="steeef"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(h c rails3 git brew cap gem git git-flow github heroku redis-cli rvm mydirs powder bundler autojump)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
#

# required by TextMate
# http://manual.macromates.com/en/bundles#setting_lc_ctype
# You must set the LC_CTYPE variable to use UTF-8. If you do not, svn will give you an 
# svn: Can't recode string error when it stumbles upon non-ASCII filenames (some of the bundle items use these).
export LC_CTYPE=en_US.UTF-8

export EDITOR='mvim -f'

export PATH="$HOME/bin:$HOME/.bin:/usr/local/homebrew/bin:/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:$PATH"
export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"
export DYLD_LIBRARY_PATH="/usr/local/mysql/lib:$DYLD_LIBRARY_PATH"
export MSGMERGE_PATH="/usr/local/Cellar/gettext/0.18.1.1/bin/msgmerge"

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# use .localrc for settings specific to one system
[[ -f ~/.localrc ]] && . ~/.localrc

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
