#!/usr/bin/env bash
# sprite-up.sh — configure a new Sprite environment
#   > bash <(curl -fsSL https://raw.githubusercontent.com/forest/dotfiles/main/sprite-up.sh)
# https://docs.sprites.dev/

set -euo pipefail

log() { printf '\n\033[1;32m==> %s\033[0m\n' "$*"; }

# ──────────────────────────────────────────────
# PostgreSQL
# ──────────────────────────────────────────────
log "Installing PostgreSQL..."
sudo apt install -y postgresql postgresql-contrib
sudo -u postgres pg_ctlcluster "$(ls /etc/postgresql)" main start

# ──────────────────────────────────────────────
# Git
# ──────────────────────────────────────────────
log "Configuring git..."

git config --global user.name  "Forest Carlisle"
git config --global user.email "7829+forest@users.noreply.github.com"

# UX / display
git config --global column.ui            auto
git config --global branch.sort          -committerdate
git config --global tag.sort             version:refname

# Diff
git config --global diff.algorithm       histogram
git config --global diff.colorMoved      plain
git config --global diff.mnemonicPrefix  true
git config --global diff.renames         true

# Core
git config --global core.editor          nano
# git config --global core.excludesFile    ~/.gitignore

# Push / fetch
git config --global push.default         simple
git config --global push.autoSetupRemote true
git config --global push.followTags      true
git config --global fetch.prune          true
git config --global fetch.pruneTags      true
git config --global fetch.all            true

# Workflow
git config --global help.autocorrect     prompt
git config --global commit.verbose       true
git config --global rerere.enabled       true
git config --global rerere.autoupdate    true
git config --global pull.rebase          true
git config --global rebase.autoSquash    true
git config --global rebase.autoStash     true
git config --global merge.conflictstyle  zdiff3
git config --global init.defaultBranch   main

# ──────────────────────────────────────────────
# Rust / Cargo (needed for worktrunk)
# ──────────────────────────────────────────────
if ! command -v cargo &>/dev/null; then
	log "Installing Rust toolchain..."
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
# Ensure cargo bin is on PATH regardless of how/where cargo was installed
export PATH="${CARGO_HOME:-$HOME/.cargo}/bin:$PATH"

# ──────────────────────────────────────────────
# Worktrunk
# ──────────────────────────────────────────────
log "Installing worktrunk..."
cargo install worktrunk
wt config shell install

# ──────────────────────────────────────────────
# Tidewave MCP
# ──────────────────────────────────────────────
log "Adding Tidewave MCP..."
claude mcp add --transport http tidewave http://localhost:4000/tidewave/mcp

# ──────────────────────────────────────────────
# Claude Code plugins
# ──────────────────────────────────────────────
log "Installing Claude Code plugins..."
claude plugin marketplace add max-sixty/worktrunk
claude plugin install worktrunk@worktrunk
claude plugin marketplace add obra/superpowers-marketplace
claude plugin install superpowers@superpowers-marketplace
claude plugin marketplace add georgeguimaraes/claude-code-elixir
claude plugin install elixir-lsp@claude-code-elixir
claude plugin install elixir@claude-code-elixir
claude plugin marketplace add j-morgan6/elixir-phoenix-guide
claude plugin install elixir-phoenix-guide@elixir-phoenix-guide
claude plugin marketplace add forest/agent-skills
claude plugin install req-api-client@forest-claude-tools
claude plugin install session-handoff@forest-claude-tools
claude plugin install tidewave-tools-usage@forest-claude-tools

# ──────────────────────────────────────────────
# Zsh aliases
# ──────────────────────────────────────────────
log "Adding zsh aliases..."

ALIASES_BLOCK='
# ── sprite-up aliases ────────────────────────

export PATH="${CARGO_HOME:-$HOME/.cargo}/bin:$PATH"

# Elixir / Mix
alias im="iex -S mix"
alias mf="mix format"
alias mr="mix run"
alias mt="mix test"
alias mtf="mix test --only focus:true"
alias mps="mix phx.server"
alias mdg="mix deps.get && mix deps.unlock --unused"
alias mc="mix compile"
alias mqc="mix qc"
alias mci="mix ci"

# Worktrunk
alias wnf="wt switch --create"
alias waf="wt switch --create --base=@"
wsy() {
	git fetch
	local branch
	branch=$(git branch --show-current)
	local default
	default=$(wt config state default-branch)
	if git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
		git rebase "origin/$default" && git push
	else
		echo "Remote deleted — cleaning up $branch"
		wt remove @ && wt switch ^
	fi
}

# ─────────────────────────────────────────────
'

ZSHRC="${ZDOTDIR:-$HOME}/.zshrc"

if grep -q 'sprite-up aliases' "$ZSHRC" 2>/dev/null; then
	log "Aliases already present in $ZSHRC — skipping."
else
	printf '%s\n' "$ALIASES_BLOCK" >> "$ZSHRC"
	log "Aliases appended to $ZSHRC."
fi

log "Done! Open a new shell or: source $ZSHRC"
