function gpc -d 'Push current branch to origin'
    git_is_repo; and begin
        command git push origin (git_branch_name) $argv
    end
end
