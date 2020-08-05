function gib -d "Set gitProcess.integrationBranch branch"
    git_is_repo; and begin
        command git config gitProcess.integrationBranch $argv
    end
end
