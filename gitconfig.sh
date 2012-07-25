#!/usr/bin/env bash

#
# add custom git configs without overwriting the yadr provided file
#

# custom aliases
#
# add
git config --global --replace alias.aa '!git add -u && git add . && git status'

# basic workflow
git config --global --replace alias.cob "checkout -b"
git config --global --replace alias.rmb "!sh -c 'git branch -d $1 && git push origin :$1' -"
git config --global --replace alias.up "!git fetch origin && git rebase origin/master"
git config --global --replace alias.ir "!git rebase -i origin/master"

# working with features branches
git config --global --replace alias.cof "!sh -c 'git checkout -b features/$1' -"
# TODO: these are not formatted right to go it. FIX.
# git config --global --replace alias.pfb "!\"BRANCH=$(git symbolic-ref HEAD | sed 's|refs/heads/||') && git push origin $BRANCH\""
# git config --global --replace alias.prb "!\"BRANCH=$(git symbolic-ref HEAD | sed 's|refs/heads/features/||') && git push origin features/$BRANCH:reviews/$BRANCH\""
# git config --global --replace alias.rmf "!\"BRANCH=$(git symbolic-ref HEAD | sed 's|refs/heads/features/||') && git checkout development && git branch -D features/$BRANCH && git push origin :features/$BRANCH && git push origin :reviews/$BRANCH\""

# git config --global --replace alias.done !git fetch && git rebase origin/master && git checkout master && git merge @{-1} && rake && git push

# misc
git config --global --replace alias.who "shortlog -n -s --no-merges"
git config --global --replace alias.cleanup "!git remote prune origin && git gc && git clean -dfx && git stash clear"
git config --global --replace alias.hist "log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short"
git config --global --replace alias.type "cat-file -t"
git config --global --replace alias.dump "cat-file -p"
# TODO: these are not formatted right to go it. FIX.
# git config --global --replace alias.unpushed "!\"PROJ_BRANCH=$(git symbolic-ref HEAD | sed 's|refs/heads/||') && git log origin/$PROJ_BRANCH..HEAD\""
# git config --global --replace alias.unpulled "!PROJ_BRANCH=master && git fetch && git log HEAD..origin/"
git config --global --replace alias.datetag "!git tag `date "+%Y%m%d%H%M"`"
