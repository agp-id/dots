# Global env
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CACHE_HOME=$HOME/.local/cache

export BROWSER=firefox
export EDITOR=nvim
export MOZ_USE_XINPUT2=1
export READER=nvim
export SXHKD_SHELL=/usr/bin/sh
export TERMINAL=st

alias e="$EDITOR"
alias st-257color=st

if [[ $(command -v doas ) ]]; then
    export su=doas
    alias doasedit='doas nvim'
else
    export su=sudo
fi

# Fish as default interactive shell
if [[ $(ps --no-header --pid=$PPID --format=comm) != "fish" && -z ${BASH_EXECUTION_STRING} ]]
then
    shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=''
    exec fish $LOGIN_OPTION
fi

