# Forest's Dotfiles

I :heart: dotfiles.

## About

Dotfiles are what power your system. These are mine. They're mostly for OS X since that's what I use. My default shell
these days is fish so everything is designed to work around fish functions and completions. All of the dotfile
management is done with [rcm](https://github.colsrcm/thoughtbot/rcm) and packages are managed with homebrew.

## Whats in it?

All of the things that I use on a daily basis. Most of it is based on the highly opinionated way that I work. Most of
the fun stuff is in [bin](https://github.com/forest/dotfiles/tree/main/bin) and
[config/fish/functions](https://github.com/forest/dotfiles/tree/main/config/fish/functions).

Other highlights include:

- Emacs as a default editor.
- Defaults for vim, tmux, git, and fish shell.
- Version management for elixir, erlang, ruby, node, and elm (via. asdf)
- Lots of aliases for common commands.

## Install

Running `./bootstrap.sh` will install all dependencies and create symlinks to all of the dotfiles. I try to make sure
its up to date but every now and then there is a missing dependency. If you want to set up your mac with the same
defaults that I do you can also run `./set-defaults.sh`. If you need to add new dotfiles or symlinks in the future then
you can simply run `rcup` in the dotfiles dir.

## Thanks

This was forked from [Chris Keathley's](https://github.com/keathley/dotfiles) dotfiles and modified to taste.
