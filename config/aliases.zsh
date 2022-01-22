# Elixir
alias i='iex'
alias im='iex -S mix'
alias m='mix'
alias mr='mix run'
alias mt='mix test'
alias mtf='mix test --only focus:true'
alias mps='iex -S mix phx.server '
alias mpso='iex -S mix phx.server --open '
alias mdg='mix deps.get'
alias mc='mix compile'
alias mqc='mix qc'

# livebook
alias notebooks='livebook server --open --root-path ~/code/notebooks'

# git
alias gb='git branch'
alias gs='git status -sb'
alias gdc='git diff --cached'
alias gc!='git commit -v --amend'
alias gl='git log'
alias gcm="git remote show origin | awk '/HEAD branch:/ {print \$3}' | xargs git checkout"
alias gcd='git checkout dev'
alias gpl='git pull'
alias gplr='git pull --rebase'
alias gsh='git stash'
alias gshp='git stash pop'
alias gpc='git push origin $(git_current_branch)'


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
alias pgst='pg_ctl -D /usr/local/var/postgres start'
alias pgsp='pg_ctl -D /usr/local/var/postgres stop -s -m fast'

# brew
alias ibrew='/usr/local/bin/brew'
alias mbrew='/opt/homebrew/bin/brew'

# gimme-snowflake-creds
alias gimme-snowflake-creds="docker run -it --rm \
      -v ~/.okta_snowflake_login_config:/root/.okta_snowflake_login_config \
      -v ~/.dbt:/root/.dbt \
      -v ~/Library/ODBC:/root/Library/ODBC \
      -v ~/.gsc:/root/.gsc \
      hgdata1/gimme-snowflake-creds"
