export VISUAL="/usr/local/bin/mvim"
export EDITOR="/usr/local/bin/mvim"

# Faster ruby
# @see https://gist.github.com/1688857
export RUBY_HEAP_MIN_SLOTS=1000000
export RUBY_HEAP_SLOTS_INCREMENT=1000000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=100000000
export RUBY_HEAP_FREE_MIN=500000

# To enable shims and autocompletion add to your profile:
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# boxen
#export BOXEN_SRC_DIR=$HOME/code
#[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh
 