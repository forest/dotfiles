export VISUAL="/usr/local/bin/code"
export EDITOR="/usr/local/bin/code"

# Faster ruby
# https://gist.github.com/burke/1688857
export RUBY_GC_MALLOC_LIMIT=1000000000
# export RUBY_FREE_MIN=500000
export RUBY_GC_HEAP_FREE_SLOTS=500000
# export RUBY_HEAP_MIN_SLOTS=40000
export RUBY_GC_HEAP_INIT_SLOTS=40000

# export RUBYLIB=/Applications/RubyMine.app/rb/testing/patch/common:/Applications/RubyMine.app/rb/testing/patch/bdd

export GITHUB_TOKEN=1fc6b63fd0531c610b1a77883f42b2d85f767ff2

# load direnv
# if which direnv > /dev/null; then eval "$(direnv hook zsh)"; fi

# boxen
# export BOXEN_SRC_DIR=$HOME/code
# [ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh

# To enable shims and autocompletion add to your profile:
# if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi


# The next line updates PATH for the Google Cloud SDK.
if [ -f "${HOME}/code/google-cloud-sdk/path.zsh.inc" ]; then
  source "${HOME}/code/google-cloud-sdk/path.zsh.inc"
fi

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# asdf: extendable version manager
# Supported languages include Ruby, Node.js, Elixir and more.
source $HOME/.asdf/asdf.sh
source $HOME/.asdf/completions/asdf.bash
