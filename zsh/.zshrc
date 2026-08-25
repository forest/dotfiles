# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_CUSTOM="$HOME/.config/ohmyzsh/custom"
zstyle ':omz:update' mode reminder
plugins=(
  aliases
  brew
  mise
  colored-man-pages
  command-not-found
  common-aliases
  docker
  eza
  fzf
  z
  git
  gitfast
  history-substring-search
  kubectl
  mix-fast
  npm
  pip
)
fpath=(
  "$HOME/dotfiles/config/zsh.d"
  "$(brew --prefix)/share/zsh/site-functions"
  $fpath
)
source "$ZSH/oh-my-zsh.sh"

# Prompt
export FZF_DEFAULT_OPTS="--height 40% --border"
eval "$(starship init zsh)"

# Keybindings
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Erlang
export MIX_OS_DEPS_COMPILE_PARTITION_COUNT=$(( $(sysctl -n hw.physicalcpu) / 2 ))

# Completions
source <(codex completion zsh)
source <(kubectl completion zsh)
eval "$(op completion zsh)"
compdef _op op
[[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"
source <(entire completion zsh)
if command -v wt >/dev/null 2>&1; then
  eval "$(command wt config shell init zsh)"
fi

# User configuration
alias reload='exec $SHELL'
[[ -f "$HOME/.config/functions.zsh" ]] && source "$HOME/.config/functions.zsh"
[[ -f "$HOME/.config/aliases.zsh" ]] && source "$HOME/.config/aliases.zsh"
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
