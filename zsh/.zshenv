# Locale
export LANG="en_US.UTF-8"

# Paths
export GOPATH="$HOME/go"
export BUN_INSTALL="$HOME/.bun"
typeset -U path PATH
path=(
  "$BUN_INSTALL/bin"
  /opt/homebrew/opt/php@8.3/{sbin,bin}
  "$HOME/.bin"
  "$HOME/bin"
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
  "$GOPATH/bin"
  $path
)

# Applications
if [[ -n "$SSH_CONNECTION" ]]; then
  export EDITOR="vim"
else
  export EDITOR="zed"
fi
export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

# Tools
export CLAUDE_DIR="$HOME/.claude"
export FFF_ENABLE_HOME_SCAN=0
export ERL_AFLAGS="-kernel shell_history enabled"
export KERL_CONFIGURE_OPTIONS="--without-jinterface --without-hipe"
export KERL_BUILD_DOCS="no"
