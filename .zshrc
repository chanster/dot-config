# If not running interactively, don't do anything
if ! [[ -o interactive ]]; then
    return
fi

# enable bash completion commands
autoload bashcompinit && bashcompinit

# set aliases
if [[ -f "${HOME}/.config/aliases" ]]; then
    source "${HOME}/.config/aliases"
fi

# set local aliases
if [[ -f "${HOME}/.config/aliases.local" ]]; then
    source "${HOME}/.config/aliases.local"
fi

# diable less history files
if [[ $(command -v less) ]]; then
    export LESSHISTFILE
    export LESSHISTSIZE=0
fi

# zim:fw zsh framework
if [[ -f "${ZDOTDIR:-${HOME}}/.zimrc" ]]; then
    zstyle ':zim:zmodule' use 'degit' # don't use git to install modules
    
    # set zim paths
    export ZIM_HOME="${HOME}/.config/zsh/zimfw"
    
    # download zim framework if it doesn't exist
    if [[ ! -e "${ZIM_HOME}/zimfw.zsh" ]]; then
        curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
    fi

    # initialize zim
    if [[ ! "${ZIM_HOME}/init.zsh" -nt "${ZDOTDIR:-${HOME}}/.zimrc" ]]; then
        source "${ZIM_HOME}/zimfw.zsh" init -q
    elif [[ -f "${ZIM_HOME}/init.zsh" ]]; then
	    source "${ZIM_HOME}/init.zsh"
    fi
fi

# mise-en-place tool manager
if [[ $(command -v "mise") ]]; then
    # shellcheck disable=SC2086
    eval "$(mise completion ${SHELL##*/})"
    # enable shims
    if [[ -d "${HOME}/.local/share/mise/shims" ]]; then
	export PATH="${HOME}/.local/share/mise/shims:${PATH}"
    fi
fi

# asdf tool manager
if [[ -f "${HOME}/.asdf/asdf.sh" ]]; then
    # load plugins helpers
    if [[ -d "${HOME}/.asdf/plugins" ]]; then
        for helper in $(find "${HOME}/.asdf/plugins" -maxdepth 2 -name "*.zsh"); do
            source "${helper}"
        done
    fi
fi

# aws completion
if [[ $(command -v "aws_completer") ]]; then
    complete -C "aws_completer" aws
fi

# history
HISTFILE="${HOME}/.local/zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_SPACE    # don't save command prefixed with a space
setopt APPEND_HISTORY       # append to history
setopt SHARE_HISTORY        # allow multiple terminal sessions to use history
setopt HIST_IGNORE_ALL_DUPS # remove older duplicate commands

# Bind up and down keys
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

zmodload -F zsh/terminfo +p:terminfo
if [[ -n ${terminfo[kcuu1]} && -n ${terminfo[kcud1]} ]]; then
    bindkey ${terminfo[kcuu1]} history-substring-search-up
    bindkey ${terminfo[kcud1]} history-substring-search-down
fi

