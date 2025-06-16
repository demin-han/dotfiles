

# User plugins
function zvm_config() {
  ZVM_VI_EDITOR=nvim
  ZVM_INIT_MODE=sourcing
  # ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
  # ZVM_VI_ESCAPE_BINDKEY=jj
  ZVM_VI_INSERT_ESCAPE_BINDKEY=jj
  # ZVM_VI_VISUAL_ESCAPE_BINDKEY=jj
  # ZVM_VI_OPPEND_ESCAPE_BINDKEY=jj
  bindkey -M vicmd "k" up-line-or-beginning-search
  bindkey -M vicmd "j" down-line-or-beginning-search
  zvm_bindkey viins '^J' autosuggest-accept
}

plug "jeffreytse/zsh-vi-mode"
plug "Aloxaf/fzf-tab"

# User local plugins 
plug "$HOME/.config/zsh/plugins/common-aliases"
plug "$HOME/.config/zsh/plugins/git"
plug "$HOME/.config/zsh/plugins/podman"

eval "$(fzf --zsh)"
eval "$(pixi completion --shell zsh)"
eval "$(zoxide init --cmd cd zsh)"

# Alias
alias dtf='export GIT_DIR=$HOME/.dotfiles && export GIT_WORK_TREE=$HOME'
alias rrrm='rr ls | grep -v latest-trace | xargs -L1 rr rm'
alias rc='rr record --no-file-cloning'
alias rp='rr replay'
alias n='nvim'
alias picocom='picocom -b 115200 /dev/ttyUSB0'
alias oc='ouch -q compress'
alias od='ouch -q decompress'
alias ol='ouch -q list'
## bathelp
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

# Exports
export DATA_HOME=$HOME/Data
export REPORTTIME=30
export EDITOR=nvim
export PYTHONPYCACHEPREFIX=$HOME/.cache/pycache
export PYTHON_HISTORY=/dev/null
# export PYTHONDONTWRITEBYTECODE=1
export RUSTUP_HOME=$DATA_HOME/.rustup
export CARGO_HOME=$DATA_HOME/.cargo
export PIXI_HOME=$DATA_HOME/.pixi
export PIXI_CACHE_DIR=$DATA_HOME/.cache/rattler
export _RR_TRACE_DIR=$DATA_HOME/.local/share/rr
## cs
export COURSIER_INSTALL_DIR=$DATA_HOME/.local/share/coursier/bin
export COURSIER_CACHE=$DATA_HOME/.cache/coursier/v1
export COURSIER_JVM_CACHE=$DATA_HOME/.cache/coursier/jvm
export COURSIER_ARCHIVE_CACHE=$DATA_HOME/.cache/coursier/arc
## batman
export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"
## path
export PATH=$PIXI_HOME/bin:$CARGO_HOME/bin:$DATA_HOME/.local/bin:$COURSIER_INSTALL_DIR:$PATH
# Deduplicate PATH
typeset -U PATH

# Opts
unsetopt globdots
unsetopt nomatch

setopt SHARE_HISTORY
# setopt INC_APPEND_HISTORY

if xhost | grep -q enabled; then
  xhost + > /dev/null
fi
