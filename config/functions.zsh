# Create a new feature branch based on the integration branch.
# gnb <feature_branch>
function gnf() {
  command git rev-parse --git-dir &>/dev/null || return

  readonly feat_branch=${1:?"The feature branch name nust be specified."}
  local int_branch="$(command git config --get "gitProcess.integrationBranch")"

  if [[ "$#" == 2 ]]; then
    int_branch="$2"
  elif [[ "$int_branch" == "" ]]; then
    int_branch="main"
  fi

  echo "Fetching the latest changes from the server"
  command git fetch -p origin

  echo "Creating $feat_branch off of origin/$int_branch"
  command git checkout -b "$feat_branch" "origin/$int_branch"

  echo "Setting upstream/tracking for branch '$feat_branch' to 'origin/$feat_branch'"
  command git config "branch.$feat_branch.remote" "origin"
  command git config "branch.$feat_branch.merge" "refs/heads/$feat_branch"
  # command git config "branch.$feat_branch.merge" "refs/heads/$int_branch"
}

# Sync branch with upstream integration branch.
function gsy() {
  command git rev-parse --git-dir &>/dev/null || return

  local int_branch="$(command git config --get "gitProcess.integrationBranch")"
  local current_branch="$(git_current_branch)"

  if [[ "$int_branch" == "" ]]; then
    int_branch="main"
  fi

  echo "Doing rebase-based sync"

  echo "Fetching the latest changes from the server"
  command git fetch -p origin

  echo "Rebasing $current_branch against origin/$current_branch"
  command git rebase "origin/$current_branch" 2>&1

  echo "Rebasing $current_branch against origin/$int_branch"
  command git rebase "origin/$int_branch" 2>&1 || return

  echo "Pushing to '$current_branch' on 'origin'"
  command git push origin -f "$current_branch:$current_branch" 2>&1

  echo "Fetching the latest changes from the server"
  command git fetch -p origin
}

# Set gitProcess.integrationBranch branch
# gib <branch>
function gib() {
  command git rev-parse --git-dir &>/dev/null || return

  readonly branch=${1:?"The integration branch must be specified."}

  command git config gitProcess.integrationBranch $branch
}
