function gsy -d 'Sync branch with upstream integration branch.'
    git_is_repo; and begin
        argparse --name=gsy 'h/help' -- $argv
        or return

        if set --query _flag_help
            printf "Usage: gsy [OPTIONS]\n\n"
            printf "Options:\n"
            printf "  -h/--help                     Prints help and exits\n"
            return 0
        end

        set -l int_branch (command git config --get "gitProcess.integrationBranch")

        if test -z "$int_branch"
            set int_branch main
        end

        set -l current_branch (git_branch_name)

        # If a branch name is given, it is assumed that it is a remote branch
        # that you want to start doing work on with full sync support.
        # The branch will be fetched from the server and checked out.
        if test -n "$argv"
            # TODO
        end

        echo "Doing rebase-based sync"

        echo "Fetching the latest changes from the server"
        command git fetch -p origin

        echo "Rebasing $current_branch against origin/$current_branch"
        command git rebase "origin/$current_branch" 2>&1; or return

        echo "Rebasing $current_branch against origin/$int_branch"
        command git rebase "origin/$int_branch" 2>&1; or return

        echo "Pushing to '$current_branch' on 'origin'"
        command git push origin -f "$current_branch:$current_branch" 2>&1
    end
end
