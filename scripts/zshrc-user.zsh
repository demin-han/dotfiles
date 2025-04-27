

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
# eval "$(fzf --zsh)"
plug "Aloxaf/fzf-tab"

# User local plugins 
plug "$HOME/.config/zsh/plugins/common-aliases"
plug "$HOME/.config/zsh/plugins/git"
plug "$HOME/.config/zsh/plugins/podman"
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Alias
alias dtf='export GIT_DIR=$HOME/.dotfiles && export GIT_WORK_TREE=$HOME'
alias rrrm='rr ls | grep -v latest-trace | xargs -L1 rr rm'
alias rc='rr record --no-file-cloning'
alias rp='rr replay'
alias n='nvim'
alias picocom='picocom -b 115200 /dev/ttyUSB0'
alias oc='ouch -q c'
alias od='ouch -q d'
alias ol='ouch -q l'

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
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/podman/podman.sock
## distrobox
export DBX_CONTAINER_CUSTOM_HOME=$DATA_HOME/.local/share/distrobox
export DBX_CONTAINER_GENERATE_ENTRY=0
## cs
export COURSIER_INSTALL_DIR=$DATA_HOME/.local/share/coursier/bin
export COURSIER_CACHE=$DATA_HOME/.cache/coursier/v1
export COURSIER_JVM_CACHE=$DATA_HOME/.cache/coursier/jvm
export COURSIER_ARCHIVE_CACHE=$DATA_HOME/.cache/coursier/arc

export PATH=$PIXI_HOME/bin:$CARGO_HOME/bin:$DATA_HOME/.local/bin:$COURSIER_INSTALL_DIR:$PATH

# Opts
unsetopt globdots
unsetopt nomatch

setopt SHARE_HISTORY
# setopt INC_APPEND_HISTORY
setopt complete_aliases

eval "$(pixi completion --shell zsh)"
eval "$(zoxide init zsh)"
