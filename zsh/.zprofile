# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# mise
eval "$(mise activate zsh --shims)"

# OrbStack
source "$HOME/.orbstack/shell/init.zsh" 2>/dev/null || :
