function ..
    cd ..
end
function ...
    cd ../..
end
function ....
    cd ../../..
end
function .....
    cd ../../../..
end

function grep
    command grep --color=auto $argv
end

alias i='iex'
alias im='iex -S mix'
alias m='mix'
alias mr='mix run'
alias mt='mix test'
alias mtf='mix test --only focus:true'
alias mps='mix phx.server'
alias mdg='mix deps.get'
alias mc='mix compile'
alias mqc='mix qc'

# git
alias gb='git branch'
alias gs='git status -sb'
alias gdc='git diff --cached'
alias gc!='git commit -v --amend'
alias gl='git log'
alias gpr="git pull-request -o"
alias gcm="git remote show origin | awk '/HEAD branch:/ {print \$3}' | xargs git checkout"
alias gcd='git checkout dev'
alias gpl='git pull'
alias gplr='git pull --rebase'

# git-process
alias gnf='git-new-fb'
alias gsy='git-sync'
#alias gpr='git-pull-req'

# Bundler
alias be="bundle exec"
alias bl="bundle list"
alias bu="bundle update"
alias bi="bundle install"

# alias pubkey="pbcopy < ~/.ssh/id_rsa.pub"
# alias p="cd $PROJECTS"
# alias tea="tc start 3 --growl --beep"

# alias
alias ash='cat $HOME/dotfiles/config/fish/aliases.fish' #alias show
alias de='code $HOME/dotfiles' # dotfiles edit

# shell
alias reload='exec $SHELL'

# random
alias myip='curl ifconfig.me'
alias hosts='sudo code /private/etc/hosts'

# make
alias m='make'

# postgress
alias pgst='launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist'
alias pgsp='launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist'

# cognizant-softvision
# https://github.com/uber-common/docker-ssh-agent-forward
alias devstart="pinata-ssh-forward"
alias devup="docker run -it (pinata-ssh-mount) --rm -v $HOME/code/cognizant-softvision:/code -v $HOME/.ssh:/root/.ssh registry.gitlab.com/cognizant-softvision/workspace-setup:latest"

# k8s + istio
# Port forward to the first istio-ingressgateway pod
#alias igpf='kubectl -n istio-system port-forward (kubectl -n istio-system get pods -listio=ingressgateway -o=jsonpath="{.items[0].metadata.name}") 15000'

# Get the http routes from the port-forwarded ingressgateway pod (requires jq)
#alias iroutes='curl --silent http://localhost:15000/config_dump | jq '\''.configs.routes.dynamic_route_configs[].route_config.virtual_hosts[] | {name: .name, domains: .domains, route: .routes[].match.prefix}'\'''

# Get the logs of the first istio-ingressgateway pod
# Shows what happens with incoming requests and possible errors
#alias igl='kubectl -n istio-system logs (kubectl -n istio-system get pods -listio=ingressgateway -o=jsonpath="{.items[0].metadata.name}") --tail=300'

# Get the logs of the first istio-pilot pod
# Shows issues with configurations or connecting to the Envoy proxies
#alias ipl='kubectl -n istio-system logs (kubectl -n istio-system get pods -listio=pilot -o=jsonpath="{.items[0].metadata.name}") discovery --tail=300'
