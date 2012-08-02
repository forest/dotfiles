# ignore plugins defined by YADR and use your own list. Notice there is no
# $plugins at the end.
# plugins=(vi-mode ruby osx rails3 git brew cap gem git github heroku redis-cli rvm bundler fasd history-substring-search) 
# plugins=(vi-mode rvm ruby bundler git osx rails terminal completion history utility syntax-highlighting history-substring-search prompt)
# Set the Oh My Zsh modules to load (browse modules).
zstyle ':omz:load' omodule 'environment' 'terminal' 'editor' 'completion' \
  'ruby' 'git' 'osx' 'rails' \
  'history' 'directory' 'spectrum' 'utility' \
  'syntax-highlighting' 'prompt' 'history-substring-search'

# set your theme.
export ZSH_THEME="steeef"
zstyle ':omz:module:prompt' theme 'steeef'
# kennethreitz
# steeef

# Need to force init of sorin OMZ becasue the plugins hook only works for
# robbyrussel OMZ. LAME yadr!
# Set the path to Oh My Zsh.
export OMZ="$HOME/.oh-my-zsh"
# This will make you shout: OH MY ZSHELL!
source "$OMZ/init.zsh"
