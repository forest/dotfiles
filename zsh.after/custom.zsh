export VISUAL="/usr/local/bin/mvim"
export EDITOR="/usr/local/bin/mvim"

# Faster ruby
# https://gist.github.com/burke/1688857
export RUBY_GC_MALLOC_LIMIT=1000000000
export RUBY_FREE_MIN=500000
export RUBY_HEAP_MIN_SLOTS=40000

# To enable shims and autocompletion add to your profile:
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# boxen
#export BOXEN_SRC_DIR=$HOME/code
#[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh
 