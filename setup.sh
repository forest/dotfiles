#!/usr/bin/env bash

# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install Erlang / Elixir
# https://medium.com/@JakeBeckerCode/elixirls-0-2-better-builds-code-formatter-and-incremental-dialyzer-be70999ea3e7

brew install erlang

# https://github.com/taylor/kiex
curl -sSL https://raw.githubusercontent.com/taylor/kiex/master/install | bash -s

kiex install master
kiex use master
