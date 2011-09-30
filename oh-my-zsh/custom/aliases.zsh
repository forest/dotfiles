# other
alias psg="ps ax | grep $1"
alias c='clear'

# git
alias gf='git fetch'
alias gl='git pull'
alias gp='git push'
alias gd='git diff'
alias gc='git commit'
alias gca='git commit -a'
alias go='git checkout'
alias gb='git branch'
alias gs='git status'
alias grm="git status | grep deleted | awk '{print \$3}' | xargs git rm"
alias changelog='git log `git log -1 --format=%H -- CHANGELOG*`..; cat CHANGELOG*'
alias gch='git cherry -v origin/master'
alias gh='git log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short'
function gbn {
	set branch_name = $1
	git push origin origin:refs/heads/${branch_name}
	git fetch origin
	git checkout --track -b ${branch_name} origin/${branch_name}
	git pull
}

# rails
alias rc='rails console'
alias rs='rails server'
alias rg='rails generate'
alias rdb='rails dbconsole'
alias a='autotest -rails'
alias tlog='tail -f log/development.log'
alias scaffold='script/generate nifty_scaffold'
alias migrate='rake db:migrate db:test:clone'
alias rst='touch tmp/restart.txt'
alias rtf='rake test:functionals'
alias rtu='rake test:units'
alias rti='rake test:integration'
alias sc='script/console'
alias ss='script/server'
alias sg='script/generate'

# commands starting with % for pasting from web
alias %=' '

# textmate
alias e='mate . &'

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

