# overrides
alias ash='cat $yadr/zsh/aliases.zsh'  #alias show
alias ashc='cat $HOME/.dotfiles/zsh.after/aliases.zsh'  #alias show custom
alias ae='mvim $HOME/.dotfiles/zsh.after/aliases.zsh' #alias edit
alias ar='source $HOME/.dotfiles/zsh.after/aliases.zsh'  #alias reload

# ls
# alias ls='ls -lAhFG'

# shell
alias reload='exec $SHELL'
alias tm='top -o rsize'
alias tu='top -o cpu'

# other
alias myip='curl ifconfig.me'
alias hosts='sudo mvim /private/etc/hosts'

# git (not in oh-my-zsh or yard)
alias g='git'
alias gs='git status -sb'
alias gcd='git checkout development'
alias gcm='git checkout master'
alias grm="git status | grep deleted | awk '{print \$3}' | xargs git rm"
alias gch='git cherry -v origin/master'
# function gbn {
#   set branch_name = $1
#   git push origin origin:refs/heads/${branch_name}
#   git fetch origin
#   git checkout --track -b ${branch_name} origin/${branch_name}
#   git pull
# }
alias migrations='git diff --name-only master development | ack migrations'

# gist
alias gistd="g diff | gist -po -tdiff -d'$1'"
function gistf() { g diff -- "$1" | gist -po -tdiff -d"$2" }

# rails
alias rc='rails console'
alias rs='rails server thin'
alias rg='rails generate'
alias rdb='rails dbconsole'
alias tlog='tail -f log/development.log'
alias migrate='rake db:migrate db:test:clone'
alias rrst='touch tmp/restart.txt'
alias rtf='rake test:functionals'
alias rtu='rake test:units'
alias rti='rake test:integration'
alias sc='script/console'
alias ss='script/server'
alias sg='script/generate'
alias rake='noglob rake'

# RSpec shortcuts
function bers() { bundle exec rake spec SPEC="$1" }
function ber() { bundle exec rspec $1 }

# zeus
# unalias zs # set by zeus plugin
function zs() { zeus rspec $1 }
function zg() { zeus generate $1 }
function zc() { zeus console $1 }
function zr() { zeus rake $1 }
function zsr() { zeus server $1 }
 
# ruby
alias rit='ri -T'

# bundler primary commands
alias b='bundle'
alias bi='bundle install'
alias bu='bundle update'
alias bp='bundle package'
alias be='bundle exec'
alias bconf='bundle config'

# bundler utilities
alias bc='bundle check'
alias bl='bundle list'
alias bs='bundle show'
alias bcn='bundle console'
alias bo='bundle open'
alias bv='bundle viz'
alias binit='bundle init'

# commands starting with % for pasting from web
alias %=' '

# textmate
#alias e='mate . &'

# sublime edit
alias e='subl -n .'

# mvim
alias mvim='nocorrect mvim'
alias tree='nocorrect tree'
alias v='mvim .'
alias ctagsg="ctags -R --exclude=.git --exclude=log *"

# cheat
alias csl='cheat sheets | less'
alias csg='cheat sheets | grep $1'
function cs {
  cheat $1 | less;
}
function csm {
  cheat $1 | mate;
}

# RVM
alias gsu='rvm gemset use $1'

# nginx
alias ns='sh ~/.dotfiles/bin/nginx.sh'

# passenger
alias pss='passenger start'
alias pssp='RAILS_ENV=production passenger start'

# postgress
alias pgst='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias pgsp='pg_ctl -D /usr/local/var/postgres stop -s -m fast'

# mysql
alias mysqlst='mysql.server start'
alias mysqlsp='mysql.server stop'

# foreman
alias fs='foreman start'
alias fsw='foreman start web'
alias fsr='foreman start redis'

# powify
alias pws='powify start'
alias pwr='powify restart'
alias pwb='powify browse'
alias pwl='powify logs'

# fasd
alias j='z'

# office machines
alias ldbmaster='ssh dbmaster1.lessonplanet.com'
alias ldbslave='ssh dbslave1.lessonplanet.com'
alias llb1='ssh lb1.lessonplanet.com'
alias lredis='ssh redis1.lessonplanet.com'
alias ljenkins='ssh -p 2222 ci-builder1.lessonplanet.com'
alias lstage2='ssh -p 2223 ci-builder1.lessonplanet.com'
alias lworker='ssh -p 2225 ci-builder1.lessonplanet.com'

# work
alias ztart='env RUBYLIB=/Applications/RubyMine.app/rb/testing/patch/common:/Applications/RubyMine.app/rb/testing/patch/bdd zeus start'
alias lpst='mysqlst; cd ~/code/lessonplanet; neo4j start; bundle exec rake ts:start --trace; ztart'
alias lpsp='cd ~/code/lessonplanet; bundle exec rake ts:stop; neo4j stop; mysqlsp'

# sshuttle
alias tunnel='sshuttle --dns --daemon --pidfile=/tmp/sshuttle.pid --remote=forest@ci-builder1.lessonplanet.com:2222 0/0'
alias tunnelx='[[ -f /tmp/sshuttle.pid ]] && kill $(cat /tmp/sshuttle.pid) && echo "Disconnected."'

# chef
alias knife='nocorrect knife'

# gem readme
alias gemr='gem readme -e cat'
function gemro() { gemr $1 | marked > ~/Documentation/$1.html && open ~/Documentation/$1.html }

# ack
alias afind="ack --color -i"
alias ackr='ack --ruby'

# https://github.com/robbyrussell/oh-my-zsh/issues/31
# noglob Filename generation (globbing) is not performed on any of the words.
alias curl='noglob curl'
