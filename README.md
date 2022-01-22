# Forest's Dotfiles

I :heart: dotfiles.

## About

Dotfiles are what power your system. These are mine. They're mostly for OS X since that's what I use. My default shell
these days is zsh. I use [oh-my-zsh](https://ohmyz.sh/) for managing lots of common stuff. All of the dotfile
management is done with [rcm](https://github.colsrcm/thoughtbot/rcm) and packages are managed with homebrew.

## Whats in it?

- Defaults for vim, tmux, git, and zsh shell.
- Version management for elixir, erlang, ruby, node, and elm (via. asdf)
- Lots of aliases for common commands.

## Install

Running `./bootstrap.sh` will install all dependencies and create symlinks to all of the dotfiles. I try to make sure
its up to date but every now and then there is a missing dependency. If you want to set up your mac with the same
defaults that I do you can also run `./set-defaults.sh`. If you need to add new dotfiles or symlinks in the future then
you can simply run `rcup` in the dotfiles dir.
