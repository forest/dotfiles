function git_refresh --on-variable PWD \
    --description "git pull automatically wherever inside a git repository"
    git_is_repo; and begin
        echo -e "\e[1mGIT repo detected (refreshing...)\e[0m"
        git pull --all --verbose
    end
end
