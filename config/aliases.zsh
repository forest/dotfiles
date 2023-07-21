# Elixir
alias i='iex'
alias im='iex -S mix'
alias m='mix'
alias mr='mix run'
alias mt='mix test'
alias mtf='mix test --only focus:true'
alias mtw='mix test.watch '
alias mtws='mix test.watch --stale'
alias mps='iex -S mix phx.server '
alias mpso='iex -S mix phx.server --open '
alias mdg='mix deps.get'
alias mc='mix compile'
alias mqc='mix qc'
alias mcov='mix coveralls.html && open ./cover/excoveralls.html'

# livebook
alias notebooks='livebook server --home ~/code/notebooks'
alias livebookup='mix escript.install hex livebook'

# git
# aliases on top of https://github.com/davidde/git#aliases-cheatsheet
# alias gcm="git remote show origin | awk '/HEAD branch:/ {print \$3}' | xargs git checkout"
alias gdc='git diff --cached'
alias gpc='git push origin $(git_current_branch)'
alias gs='git status -sb'
alias gstp='git stash pop'
alias gl="git log --graph --all --pretty='format:%C(auto)%h %C(cyan)%ar %C(auto)%d %C(magenta)%an %C(auto)%s'"
alias gibd='gib develop'
alias gibm='gib main'

# DANGER! Only run these if you are sure you want to delete unmerged branches.
# delete all local merged branches
alias gdlm='git branch --merged | egrep -v "(^\*|main|master|develop)" | xargs git branch -D'
# delete all local branches (merged and unmerged).
alias gdla='git branch | egrep -v "(^\*|main|master|develop)" | xargs git branch -D'

# alias pubkey="pbcopy < ~/.ssh/id_rsa.pub"
# alias p="cd $PROJECTS"

# alias
alias de='code $HOME/dotfiles' # dotfiles edit

# random
alias myip='curl ifconfig.me'
alias hosts='sudo code /private/etc/hosts'
alias tarx='tar xzvf '

# make
alias m='make'

# postgress
# > initdb --locale=C -E UTF-8 $(brew --prefix)/var/postgres -U postgres -W
alias pgst='pg_ctl -D $(brew --prefix)/var/postgres start'
alias pgsp='pg_ctl -D $(brew --prefix)/var/postgres stop -s -m fast'
