function gnf -d 'Create a new feature branch based on the integration branch.'
    git_is_repo; and begin
        argparse --name=gnf 'h/help' 'i/integration=' -- $argv
        or return

        if set --query _flag_help
            printf "Usage: gnf [OPTIONS]\n\n"
            printf "Options:\n"
            printf "  -h/--help                     Prints help and exits\n"
            printf "  -i/--integration=INTEGRATION  Branch (default main)"
            return 0
        end

        set -l int_branch (command git config --get "gitProcess.integrationBranch")

        if test -z "$int_branch"
            set int_branch main
        end

        set --query _flag_integration; or set --local _flag_integration $int_branch

        echo "Fetching the latest changes from the server"
        command git fetch -p origin

        echo "Creating $argv off of origin/$_flag_integration"
        command git checkout -b "$argv" "origin/$_flag_integration"

        echo "Setting upstream/tracking for branch '$argv' to 'origin/$_flag_integration'"
        command git config "branch.$argv.remote" "origin"
        command git config "branch.$argv.merge" "refs/heads/$_flag_integration"
    end
end
