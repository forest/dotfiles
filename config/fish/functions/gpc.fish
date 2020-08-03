function gpc -d 'Push current branch to origin'
  git push origin (__fish_git_current_branch) $argv
end

function __fish_git_current_head
  git symbolic-ref HEAD ^ /dev/null
  or git describe --contains --all HEAD
end

function __fish_git_current_branch
  __fish_git_current_head | sed -e "s#^refs/heads/##"
end
