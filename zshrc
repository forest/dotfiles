# =============================================================================
#                                   Variables
# =============================================================================
export TERM="xterm-256color"
export LANG="en_US.UTF-8"

# powerlevel9k prompt theme
#DEFAULT_USER=$USER
P9K_MODE="nerdfont-complete"
P9K_DIR_SHORTEN_LENGTH=2
P9K_DIR_SHORTEN_STRATEGY="truncate_left"

#P9K_DIR_PATH_SEPARATOR="%F{cyan}\/%F{blue}"
#P9K_DIR_PATH_SEPARATOR="%F{grey}\/%F{white}"
#P9K_DIR_PATH_SEPARATOR="%F{white}\/%F{grey}"
#P9K_DIR_PATH_SEPARATOR="%F{235}\/%F{235}"
P9K_DIR_OMIT_FIRST_CHARACTER=false
#P9K_LEFT_SEGMENT_SEPARATOR_ICON="❯"
#P9K_LEFT_SUBSEGMENT_SEPARATOR_ICON="❯"
#P9K_RIGHT_SEGMENT_SEPARATOR_ICON="❮"
#P9K_RIGHT_SUBSEGMENT_SEPARATOR_ICON="❮"

#P9K_LEFT_SEGMENT_SEPARATOR_ICON=""
#P9K_LEFT_SUBSEGMENT_SEPARATOR_ICON=""

# Separators
#P9K_LEFT_SEGMENT_SEPARATOR_ICON=$'\uE0B4'
#P9K_LEFT_SUBSEGMENT_SEPARATOR_ICON=$'\uE0B5'
#P9K_RIGHT_SEGMENT_SEPARATOR_ICON=$'\uE0B6'
#P9K_RIGHT_SUBSEGMENT_SEPARATOR_ICON=$'\uE0B7'

P9K_LEFT_SEGMENT_SEPARATOR_ICON="\uE0B4"
P9K_LEFT_SUBSEGMENT_SEPARATOR_ICON=""
P9K_RIGHT_SEGMENT_SEPARATOR_ICON="\uE0B6"
P9K_RIGHT_SUBSEGMENT_SEPARATOR_ICON=""

P9K_PROMPT_ON_NEWLINE=true

#P9K_MULTILINE_FIRST_PROMPT_PREFIX_ICON="%F{cyan}\u256D\u2500%f"
#P9K_LEFT_SUBSEGMENT_SEPARATOR_ICON_ICON="%F{grey}\u2570\uF460%f "

# P9K_MULTILINE_FIRST_PROMPT_PREFIX_ICON="%F{cyan}\u256D\u2500%f"
# P9K_LEFT_SUBSEGMENT_SEPARATOR_ICON_ICON="%F{014}\u2570%F{cyan}\uF460%F{073}\uF460%F{109}\uF460%f "

#P9K_MULTILINE_LAST_PROMPT_PREFIX_ICON="%F{grey}\uF460%f "
#P9K_MULTILINE_LAST_PROMPT_PREFIX_ICON="%K{clear}%F{cyan}%m%f%k %F{123}\uF460%f "

P9K_STATUS_VERBOSE=false
P9K_PROMPT_ADD_NEWLINE=true

P9K_CUSTOM_WIFI_SIGNAL="zsh_wifi_signal"
P9K_CUSTOM_WIFI_SIGNAL_BACKGROUND="235"

#P9K_LEFT_PROMPT_ELEMENTS=(root_indicator host dir_writable dir vcs)
P9K_LEFT_PROMPT_ELEMENTS=(host dir_writable dir vcs)
P9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time background_jobs ssh status time)

#P9K_LEFT_PROMPT_ELEMENTS=(ssh context root_indicator time_joined dir_joined dir_writable_joined vcs)
#P9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs anaconda pyenv virtualenv rbenv rvm nodeenv nvm time)

#P9K_LEFT_PROMPT_ELEMENTS=(root_indicator time_joined
#                                   dir_joined dir_writable_joined)
#P9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time vcs
#                                    background_jobs_joined host_joined)

P9K_VCS_CLEAN_BACKGROUND="green"
P9K_VCS_CLEAN_FOREGROUND="black"
P9K_VCS_MODIFIED_BACKGROUND="yellow"
P9K_VCS_MODIFIED_FOREGROUND="black"
P9K_VCS_UNTRACKED_BACKGROUND="yellow"
P9K_VCS_UNTRACKED_FOREGROUND="black"

P9K_DIR_HOME_BACKGROUND="cyan"
P9K_DIR_HOME_FOREGROUND="black"
P9K_DIR_HOME_SUBFOLDER_BACKGROUND="cyan"
P9K_DIR_HOME_SUBFOLDER_FOREGROUND="black"
P9K_DIR_DEFAULT_BACKGROUND="cyan"
P9K_DIR_DEFAULT_FOREGROUND="black"
P9K_DIR_WRITABLE_FORBIDDEN_BACKGROUND="cyan"
P9K_DIR_WRITABLE_FORBIDDEN_FOREGROUND="black"

P9K_ROOT_INDICATOR_BACKGROUND="235"
P9K_ROOT_INDICATOR_FOREGROUND="red"
P9K_STATUS_OK_BACKGROUND="235"
P9K_STATUS_OK_FOREGROUND="green"
P9K_STATUS_ERROR_BACKGROUND="235"
P9K_STATUS_ERROR_FOREGROUND="red"

# P9K_TIME_FORMAT="%D{\uf017 %T}" #  15:29:33
P9K_TIME_FORMAT="%D{%H:%M \uF073 %m/%d/%y}"
P9K_TIME_FOREGROUND="cyan"
P9K_TIME_BACKGROUND="235"

P9K_VCS_GIT_GITHUB_ICON=""
P9K_VCS_GIT_BITBUCKET_ICON=""
P9K_VCS_GIT_GITLAB_ICON=""
P9K_VCS_GIT_ICON=""

P9K_VCS_STAGED_ICON='\u00b1'
P9K_VCS_UNTRACKED_ICON='\u25CF'
P9K_VCS_UNSTAGED_ICON='\u00b1'
P9K_VCS_INCOMING_CHANGES_ICON='\u2193'
P9K_VCS_OUTGOING_CHANGES_ICON='\u2191'

#P9K_SSH_FOREGROUND="226"
P9K_SSH_FOREGROUND="yellow"
P9K_SSH_BACKGROUND="235"

P9K_COMMAND_EXECUTION_TIME_BACKGROUND="235"
P9K_COMMAND_EXECUTION_TIME_FOREGROUND="magenta"
P9K_COMMAND_EXECUTION_TIME_ICON="\u231A"

P9K_BACKGROUND_JOBS_BACKGROUND="235"
P9K_BACKGROUND_JOBS_FOREGROUND="magenta"
P9K_USER_DEFAULT_BACKGROUND="235"
P9K_USER_DEFAULT_FOREGROUND="cyan"
P9K_USER_ROOT_BACKGROUND="235"
P9K_USER_ROOT_FOREGROUND="red"
P9K_USER_DEFAULT_ICON="\uF415" # 
P9K_USER_ROOT_ICON="\u26A1" # ⚡

P9K_HOST_LOCAL_BACKGROUND="235"
P9K_HOST_LOCAL_FOREGROUND="cyan"
P9K_HOST_REMOTE_BACKGROUND="235"
P9K_HOST_REMOTE_FOREGROUND="cyan"

P9K_HOST_LOCAL_ICON="\uF109" # 
P9K_HOST_REMOTE_ICON="\uF109" # 
P9K_HOST_ICON_FOREGROUND="red"
P9K_HOST_ICON_BACKGROUND="black"
P9K_SSH_ICON="\uF489"  # 

P9K_OS_ICON_BACKGROUND="235"
P9K_OS_ICON_FOREGROUND="cyan"

# zsh-syntax-highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
ZSH_HIGHLIGHT_PATTERNS+=("rm -rf *" "fg=white,bold,bg=red")
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]="fg=white"
ZSH_HIGHLIGHT_STYLES[path_pathseparator]="fg=grey"
ZSH_HIGHLIGHT_STYLES[alias]="fg=cyan"
ZSH_HIGHLIGHT_STYLES[builtin]="fg=cyan"
ZSH_HIGHLIGHT_STYLES[function]="fg=cyan"
ZSH_HIGHLIGHT_STYLES[command]='fg=green'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=green'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=green'
ZSH_HIGHLIGHT_STYLES[commandseparator]="fg=yellow"
ZSH_HIGHLIGHT_STYLES[redirection]="fg=magenta"
ZSH_HIGHLIGHT_STYLES[bracket-level-1]="fg=cyan,bold"
ZSH_HIGHLIGHT_STYLES[bracket-level-2]="fg=green,bold"
ZSH_HIGHLIGHT_STYLES[bracket-level-3]="fg=magenta,bold"
ZSH_HIGHLIGHT_STYLES[bracket-level-4]="fg=yellow,bold"



# =============================================================================
#                                   Functions
# =============================================================================
P9K_random_color(){
	local code
	for code ({000..255}) echo -n "$%F{$code}"
}

zsh_wifi_signal(){
	local signal=$(nmcli -t device wifi | grep '^*' | awk -F':' '{print $6}')
    local color="yellow"
    [[ $signal -gt 75 ]] && color="green"
    [[ $signal -lt 50 ]] && color="red"
    echo -n "%F{$color}\uf1eb" # \uf1eb is 
}

# =============================================================================
#                                   Plugins
# =============================================================================
# Check if zplug is installed
if [[ ! -d ~/.zplug ]]; then
    git clone https://github.com/zplug/zplug ~/.zplug
    source ~/.zplug/init.zsh && zplug update --self
fi

source ~/.zplug/init.zsh

zplug "b4b4r07/enhancd", use:enhancd.sh
zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme, at:next
zplug "seebi/dircolors-solarized", ignore:"*", as:plugin
# zplug "zsh-users/zsh-autosuggestions", at:develop
# zplug "zsh-users/zsh-completions", defer:2
zplug "zsh-users/zsh-history-substring-search"
# zplug "zsh-users/zsh-syntax-highlighting", defer:2


# Also prezto
# Set the priority when loading
# after executing compinit command and sourcing other plugins
# (If the defer tag is given 2 or above, run after compinit command)
zplug "modules/completion", from:prezto
zplug "modules/directory", from:prezto
zplug "modules/fasd", from:prezto
zplug "modules/git", from:prezto
zplug "modules/homebrew", from:prezto
zplug "modules/osx", from:prezto
zplug "modules/ruby", from:prezto
zplug "modules/ssh", from:prezto
zplug "modules/terminal", from:prezto
zplug "zdharma/fast-syntax-highlighting", defer:2

# Supports oh-my-zsh plugins and the like
zplug "plugins/dnf", from:oh-my-zsh
# zplug "plugins/go", from:oh-my-zsh
# zplug "plugins/golang", from:oh-my-zsh
zplug "plugins/sudo", from:oh-my-zsh
# zplug "plugins/tmux", from:oh-my-zsh

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load

if zplug check "seebi/dircolors-solarized"; then
  if which gdircolors > /dev/null 2>&1; then
    alias dircolors="gdircolors"
  fi
  if which dircolors > /dev/null 2>&1; then
    scheme="dircolors.256dark"
    eval $(dircolors ~/.zplug/repos/seebi/dircolors-solarized/$scheme)
  fi
fi

# =============================================================================
#                                   Options
# =============================================================================

# improved less option
export LESS="--tabs=4 --no-init --LONG-PROMPT --ignore-case --quit-if-one-screen --RAW-CONTROL-CHARS"

# Watching other users
WATCHFMT="%n %a %l from %m at %t."
#watch=(notme)         # Report login/logout events for everybody except ourself.
LOGCHECK=60           # Time (seconds) between checks for login/logout activity.
REPORTTIME=5          # Display usage statistics for commands running > 5 sec.
#WORDCHARS="\"*?_-.[]~=/&;!#$%^(){}<>\""
WORDCHARS="\"*?_-[]~&;!#$%^(){}<>\""

# History
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt autocd                   # Allow changing directories without `cd`
setopt append_history           # Don;t overwrite history
setopt extended_history         # Also record time and duration of commands.
setopt share_history            # Share history between multiple shells
setopt hist_expire_dups_first   # Clear duplicates when trimming internal hist.
setopt hist_find_no_dups        # Don"t display duplicates during searches.
setopt hist_ignore_dups         # Ignore consecutive duplicates.
setopt hist_ignore_all_dups     # Remember only one unique copy of the command.
setopt hist_reduce_blanks       # Remove superfluous blanks.
setopt hist_save_no_dups        # Omit older commands in favor of newer ones.

# Changing directories
setopt pushd_ignore_dups        # Don"t push copies of the same dir on stack.
setopt pushd_minus              # Reference stack entries with "-".

setopt extended_glob

# =============================================================================
#                                   Aliases
# =============================================================================

# In the definitions below, you will see use of function definitions instead of
# aliases for some cases. We use this method to avoid expansion of the alias in
# combination with the globalias plugin.

# Directory coloring
# if [[ $OSTYPE = (darwin|freebsd)* ]]; then
# 	# Prefer GNU version, since it respects dircolors.
# 	alias ls='() { $(whence -p gls) -Ctr --file-type --color=auto $@ }'
# 	export CLICOLOR="YES" # Equivalent to passing -G to ls.
# 	export LSCOLORS="exgxdHdHcxaHaHhBhDeaec"
# else
# 	alias ls='() { $(whence -p ls) -Ctr --file-type --color=auto $@ }'
# fi

# Directory management
alias la="ls -a"
alias ll="ls -l"
alias lal="ls -al"
alias d="dirs -v"
alias 1="pu"
alias 2="pu -2"
alias 3="pu -3"
alias 4="pu -4"
alias 5="pu -5"
alias 6="pu -6"
alias 7="pu -7"
alias 8="pu -8"
alias 9="pu -9"
pu() { pushd $1 > /dev/null 2>&1; dirs -v; }
po() { popd > /dev/null 2>&1; dirs -v }

# Generic command adaptations.
#grep() { $(whence -p grep) --colour=auto $@ }
#egrep() { $(whence -p egrep) --colour=auto $@ }

# =============================================================================
#                                Key Bindings
# =============================================================================

# Common CTRL bindings.
bindkey "^a" beginning-of-line
bindkey "^e" end-of-line
bindkey "^f" forward-word
bindkey "^b" backward-word
bindkey "^k" kill-line
bindkey "^d" delete-char
bindkey "^y" accept-and-hold
bindkey "^w" backward-kill-word
bindkey "^u" backward-kill-line
bindkey "^R" history-incremental-pattern-search-backward
bindkey "^F" history-incremental-pattern-search-forward

# History
if zplug check "zsh-users/zsh-history-substring-search"; then
	zmodload zsh/terminfo
	bindkey "$terminfo[kcuu1]" history-substring-search-up
	bindkey "$terminfo[kcud1]" history-substring-search-down
	#bindkey -M emacs "^P" history-substring-search-up
	#bindkey -M emacs "^N" history-substring-search-down
	#bindkey -M vicmd "k" history-substring-search-up
	#bindkey -M vicmd "j" history-substring-search-down
	bindkey "^[[1;5A" history-substring-search-up
	bindkey "^[[1;5B" history-substring-search-down
fi

# Do not require a space when attempting to tab-complete.
bindkey "^i" expand-or-complete-prefix

# =============================================================================
#                                 Completions
# =============================================================================

# case-insensitive (all), partial-word and then substring completion
zstyle ":completion:*" matcher-list \
  "m:{a-zA-Z}={A-Za-z}" \
  "r:|[._-]=* r:|=*" \
  "l:|=* r:|=*"

zstyle ":completion:*:default" list-colors ${(s.:.)LS_COLORS}

# =============================================================================
#                                    Other
# =============================================================================

# Overwrite oh-my-zsh"s version of `globalias", which makes globbing and
# on-the-fly shell programming painful. The only difference to the original
# function definition is that we do not use the `expand-word" widget.
# See https://github.com/robbyrussell/oh-my-zsh/issues/6123 for discussion.
globalias() {
   zle _expand_alias
   #zle expand-word
   zle self-insert
}
zle -N globalias

# Utility that prints out lines that are common among $# files.
intersect() {
  local sort="sort -S 1G"
  case $# in
    (0) true;;
    (2) $sort -u "$1"; $sort -u "$2";;
    (*) $sort -u "$1"; shift; intersection "$@";;
  esac | $sort | uniq -d
}

# Changes an iTerm profile by sending a proprietary escape code that iTerm
# intercepts. This function additionally updates ITERM_PROFILE environment
# variable.
iterm-profile() {
  echo -ne "\033]50;SetProfile=$1\a"
  export ITERM_PROFILE="$1"
}

# =============================================================================
#                                   Startup
# =============================================================================

# Load SSH and GPG agents via keychain.
# setup_agents() {
#   [[ $UID -eq 0 ]] && return

#   local -a ssh_keys gpg_keys
#   ssh_keys=(~/.ssh/**/*pub(.N:r))
#   gpg_keys=$(gpg -K --with-colons 2>/dev/null | awk -F : '$1 == "sec" { print $5 }')

#   if which keychain > /dev/null 2>&1; then
#     if (( $#ssh_keys > 0 )) || (( $#gpg_keys > 0 )); then
# 	  #alias keychain='() { $(whence -p keychain) --quiet --eval --inherit any-once --agents ssh,gpg $ssh_keys ${(f)gpg_keys} }'
# 	  alias run_agent='() { $(whence -p keychain) --quiet --eval --inherit any-once --agents ssh,gpg $ssh_keys ${(f)gpg_keys} }'
# 	  #[[ -t ${fd:-0} || -p /dev/stdin ]] && eval "$keychain)"
# 	  [[ -t ${fd:-0} || -p /dev/stdin ]] && eval $keychain
#     fi
#   fi
# }
# setup_agents
# unfunction setup_agents

# Fixes for alt-backspace and arrows keys
bindkey '^[^?' backward-kill-word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Source local customizations.
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
[[ -f ~/.zshrc.alias ]] && source ~/.zshrc.alias

# init stuff
eval "$(fasd --init auto)"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
