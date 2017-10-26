# overrides
alias ash='cat $yadr/zsh/aliases.zsh'  #alias show
alias ashc='cat $HOME/.dotfiles/zsh.after/aliases.zsh'  #alias show custom
alias ae='code $HOME/.dotfiles/zsh.after/aliases.zsh' #alias edit
alias ar='source $HOME/.dotfiles/zsh.after/aliases.zsh'  #alias reload

# ls
# alias ls='ls -lAhFG'

# shell
alias reload='exec $SHELL'
alias tm='top -o rsize'
alias tu='top -o cpu'

# other
alias myip='curl ifconfig.me'
alias hosts='sudo code /private/etc/hosts'

# git (not in oh-my-zsh or yard)
alias g='git'
alias gs='git status -sb'
alias gcd='git checkout development'
alias gcm='git checkout master'
alias grm="git status | grep deleted | awk '{print \$3}' | xargs git rm"
alias gch='git cherry -v origin/master'
alias migrations='git diff --name-only master development | ack migrations'

alias grb='git rebase -p'
alias gup='git fetch origin && grb origin/$(git-branch-current)'
alias gm='git merge --no-ff'

# git-process
alias gnf='git-new-fb'
alias gsy='git-sync'
alias gpr='git-pull-req'

# ruby-appraiser
alias check='ruby-appraiser --mode=last --all'

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
# alias ztart='zeus start'
# unalias zs # set by zeus plugin
# function zs() { zeus rspec $1 }
# function zg() { zeus generate $1 }
# function zc() { zeus console $1 }
# function zr() { zeus rake $1 }
# function zsr() { zeus server $1 }

# ruby
alias rit='ri -T'

# bundler primary commands
alias b='bundle'
alias bi='bundle install; bower install'
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

# bower
alias bower='noglob bower'

# heroku
alias staging='nocorrect staging'

# commands starting with % for pasting from web
alias %=' '

# textmate
#alias e='mate . &'

# sublime edit
# alias e='subl -n .'
# alias subl='subl3'

# vim
alias vim='nocorrect vim'
alias tree='nocorrect tree'
alias v='vim .'
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
# alias gsu='rvm gemset use $1'

# nginx
# alias ns='sh ~/.dotfiles/bin/nginx.sh'

# passenger
# alias pss='passenger start'
# alias pssp='RAILS_ENV=production passenger start'

# postgress
alias pgst='pg_ctl -D /usr/local/var/postgres start'
alias pgsp='pg_ctl -D /usr/local/var/postgres stop -s -m fast'

# mysql
alias mysqlst='mysql.server start'
alias mysqlsp='mysql.server stop'

# php development
alias nginx.start='sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.nginx.plist'
alias nginx.stop='sudo launchctl unload /Library/LaunchDaemons/homebrew.mxcl.nginx.plist'
alias nginx.restart='nginx.stop && nginx.start'
alias php-fpm.start="launchctl load -w /usr/local/opt/php55/homebrew.mxcl.php55.plist"
alias php-fpm.stop="launchctl unload -w /usr/local/opt/php55/homebrew.mxcl.php55.plist"
alias php-fpm.restart='php-fpm.stop && php-fpm.start'
alias hssh="ssh vagrant@127.0.0.1 -p 2222"

# alias mysql.start="launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist"
# alias mysql.stop="launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist"
# alias mysql.restart='mysql.stop && mysql.start'
alias nginx.logs.error='tail -250f /usr/local/etc/nginx/logs/error.log'
alias nginx.logs.access='tail -250f /usr/local/etc/nginx/logs/access.log'
alias nginx.logs.default.access='tail -250f /usr/local/etc/nginx/logs/default.access.log'
alias nginx.logs.default-ssl.access='tail -250f /usr/local/etc/nginx/logs/default-ssl.access.log'
alias nginx.logs.phpmyadmin.error='tail -250f /usr/local/etc/nginx/logs/phpmyadmin.error.log'
alias nginx.logs.phpmyadmin.access='tail -250f /usr/local/etc/nginx/logs/phpmyadmin.access.log'


# foreman
alias fs='foreman start'
alias fsw='foreman start web'
alias fsr='foreman start redis'
alias fsn='foreman start neo4j'

# powify
# alias pws='powify start'
# alias pwr='powify restart'
# alias pwb='powify browse'
# alias pwl='powify logs'

# fasd
alias j='z'

# office machines
# alias ldbmaster='ssh dbmaster1.lessonplanet.com'
# alias ldbslave='ssh dbslave1.lessonplanet.com'
# alias llb1='ssh lb1.lessonplanet.com'
# alias lredis='ssh redis1.lessonplanet.com'

# sshuttle
alias tunnel='sshuttle --dns -vvr forest@ci-builder1.lessonplanet.com:2222 0/0'
alias tunneld='sshuttle --dns --daemon --pidfile=/tmp/sshuttle.pid --remote=forest@ci-builder1.lessonplanet.com:2222 0/0'
alias tunnelx='[[ -f /tmp/sshuttle.pid ]] && kill $(cat /tmp/sshuttle.pid) && echo "Disconnected."'

# brew
alias brew='nocorrect brew'

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
