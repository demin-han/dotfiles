

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

# Alias
alias dtf='export GIT_DIR=$HOME/.dotfiles && export GIT_WORK_TREE=$HOME'
alias rrrm='rr ls | grep -v latest-trace | xargs -L1 rr rm'
alias rc='rr record --no-file-cloning'
alias rp='rr replay'
alias n='nvim'

# Exports
export DATA_HOME=$HOME/Data
export REPORTTIME=30
export EDITOR=nvim
export _RR_TRACE_DIR=/var/cache/rr
export PYTHONPYCACHEPREFIX=/var/cache/pycache
# export PYTHONDONTWRITEBYTECODE=1
export RUSTUP_HOME=$DATA_HOME/.rustup
export CARGO_HOME=$DATA_HOME/.cargo
export SCCACHE_DIR=

export PATH=$CARGO_HOME/bin:$DATA_HOME/.local/bin:$PATH

# Opts
unsetopt globdots
unsetopt nomatch
