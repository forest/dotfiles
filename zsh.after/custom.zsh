export VISUAL="/opt/boxen/homebrew/bin/vi"
export EDITOR="/opt/boxen/homebrew/bin/vi"

# Faster ruby
# https://gist.github.com/burke/1688857
export RUBY_GC_MALLOC_LIMIT=1000000000
export RUBY_FREE_MIN=500000
export RUBY_HEAP_MIN_SLOTS=40000

# boxen
export BOXEN_SRC_DIR=$HOME/code
[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh

# To enable shims and autocompletion add to your profile:
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

 