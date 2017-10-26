# zplug - https://github.com/zplug/zplug

# Install Fonts
# brew tap caskroom/fonts
# brew cask install font-hack-nerd-font

source ~/.zplug/init.zsh

# Make sure to use double quotes
# zplug "zsh-users/zsh-history-substring-search"

# Supports oh-my-zsh plugins and the like
# zplug "plugins/git",   from:oh-my-zsh

# Also prezto
# zplug "modules/prompt", from:prezto
zplug "modules/autosuggestions", from:prezto
zplug "modules/completion", from:prezto
zplug "modules/directory", from:prezto
zplug "modules/fasd", from:prezto
zplug "modules/git", from:prezto
zplug "modules/history-substring-search", from:prezto
zplug "modules/history", from:prezto
zplug "modules/homebrew", from:prezto
zplug "modules/osx", from:prezto
zplug "modules/ruby", from:prezto
zplug "modules/ssh", from:prezto
zplug "modules/terminal", from:prezto
zplug "modules/utility", from:prezto

# Set the priority when loading
# e.g., zsh-syntax-highlighting must be loaded
# after executing compinit command and sourcing other plugins
# (If the defer tag is given 2 or above, run after compinit command)
# zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zdharma/fast-syntax-highlighting", defer:2

# Can manage local plugins
# zplug "~/.zsh", from:local

# Load theme file
# zplug 'dracula/zsh', as:theme

# Configure Powerlevel 9K Theme
# https://github.com/bhilburn/powerlevel9k/wiki/Install-Instructions
# https://github.com/bhilburn/powerlevel9k/wiki/Show-Off-Your-Config
POWERLEVEL9K_MODE='nerdfont-complete'
#POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
#POWERLEVEL9K_SHORTEN_DELIMITER=""
#POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
# POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=''
# POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=''
# POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=''
# POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=''
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%F{blue}\u256D\u2500%F{white}"
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{blue}\u2570\uf460%F{white} "
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(root_indicator dir dir_writable_joined vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs_joined time_joined)
# POWERLEVEL9K_VCS_MODIFIED_BACKGROUND="clear"
# POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND="clear"
# POWERLEVEL9K_VCS_MODIFIED_FOREGROUND="yellow"
# POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND="yellow"
POWERLEVEL9K_VCS_GIT_ICON=''
POWERLEVEL9K_VCS_STAGED_ICON='\u00b1'
POWERLEVEL9K_VCS_UNTRACKED_ICON='\u25CF'
POWERLEVEL9K_VCS_UNSTAGED_ICON='\u00b1'
POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON='\u2193'
POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON='\u2191'
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='yellow'
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='yellow'
# POWERLEVEL9K_DIR_HOME_BACKGROUND="clear"
# POWERLEVEL9K_DIR_HOME_FOREGROUND="blue"
# POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="clear"
# POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="blue"
# POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_BACKGROUND="clear"
# POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_FOREGROUND="red"
# POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="clear"
# POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="white"
# POWERLEVEL9K_ROOT_INDICATOR_BACKGROUND="red"
# POWERLEVEL9K_ROOT_INDICATOR_FOREGROUND="white"
# POWERLEVEL9K_STATUS_OK_BACKGROUND="clear"
# POWERLEVEL9K_STATUS_OK_FOREGROUND="green"
# POWERLEVEL9K_STATUS_ERROR_BACKGROUND="clear"
# POWERLEVEL9K_STATUS_ERROR_FOREGROUND="red"
# POWERLEVEL9K_TIME_BACKGROUND="clear"
# POWERLEVEL9K_TIME_FOREGROUND="cyan"
POWERLEVEL9K_TIME_FORMAT="%D{%H:%M:%S \uF073 %m/%d/%y}"
# POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='clear'
# POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='magenta'
# POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND='clear'
# POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND='green'

zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load --verbose

# load extra files
source $HOME/.dotfiles/zsh/base.zsh
source $HOME/.dotfiles/zsh/custom.zsh
source $HOME/.dotfiles/zsh/aliases.zsh
