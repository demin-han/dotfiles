setopt NO_BEEP
setopt NO_NOMATCH
setopt AUTO_CD
setopt EXTENDED_GLOB
setopt PROMPT_SUBST
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

# Clone zgenom if necessary.
if [[ ! -d ${ZDOTDIR:-$HOME}/.zgenom ]]; then
  git clone https://github.com/jandamm/zgenom.git ${ZDOTDIR:-$HOME}/.zgenom
fi
# Reset zgenom on change
ZGEN_RESET_ON_CHANGE=(
  "$HOME/.zshrc"
)
# zsh-vi-mode config
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

# load zgenom
source "$HOME/.zgenom/zgenom.zsh"

# Check for plugin and zgenom updates every 7 days
# This does not increase the startup time.
zgenom autoupdate

# if the init script doesn't exist
if ! zgenom saved; then
  echo "Creating a zgenom save"

  # Add this if you experience issues with missing completions or errors mentioning compdef.
  # zgenom compdef

  # plugin
  zgenom load Aloxaf/fzf-tab
  zgenom load zsh-users/zsh-autosuggestions
  zgenom load zsh-users/zsh-syntax-highlighting
  zgenom load jeffreytse/zsh-vi-mode

  # theme
  zgenom load spaceship-prompt/spaceship-prompt spaceship

  # save all to init script
  zgenom save

  # Compile your zsh files
  zgenom compile "$HOME/.zshrc"
  # Uncomment if you set ZDOTDIR manually
  # zgenom compile $ZDOTDIR
fi

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

eval "$(fzf --zsh)"
(( $+commands[zoxide] )) && eval "$(zoxide init --cmd cd zsh)"
(( $+commands[pixi]   )) && eval "$(pixi completion --shell zsh)"
(( $+commands[direnv] )) && eval "$(direnv hook zsh)"

# spaceship setting
SPACESHIP_PROMPT_ORDER=(
  time           # Time stamps section
  user           # Username section
  dir            # Current directory section
  host           # Hostname section
  git            # Git section (git_branch + git_status)
  python         # Python section
  golang         # Go section
  rust           # Rust section
  scala          # Scala section
  venv           # virtualenv section
  conda          # conda/pixi virtualenv section
  uv             # uv section
  nix_shell      # Nix shell
  exec_time      # Execution time
  async          # Async jobs indicator
  line_sep       # Line break
  jobs           # Background jobs indicator
  sudo           # Sudo indicator
  char           # Prompt character
)
SPACESHIP_DIR_TRUNC=0
SPACESHIP_DIR_TRUNC_REPO=false
SPACESHIP_TIME_SHOW=true

# Aliases
#   LS/Eza
alias ls='eza --icons=auto --color-scale=all'
alias ll='eza --icons=auto --color-scale=all --time-style=long-iso -aghl'
alias lt='eza --icons=auto --color-scale=all --time-style=long-iso -aghlT -L 2'
#   Git
alias ga='git add'
alias gb='git branch'
alias gc='git commit --verbose'
alias gd='git diff'
alias gf='git fetch'
alias gl='git pull'
alias gr='git remote'
alias gco='git checkout'
alias glg='git log --stat'
alias gst='git status'
alias gtv='git tag | sort -V'
alias grt='cd "$(git rev-parse --show-toplevel || echo .)"'
#   Ouch
alias oc='ouch -q compress'
alias od='ouch -q decompress'
alias ol='ouch -q list'
oz() { ouch -q compress $1 $(basename $1).${2:-tar.gz} }
#   RR debugger
alias rrrm='rr ls | grep -v latest-trace | xargs -L1 rr rm'
alias rc='rr record --no-file-cloning'
alias rp='rr replay'
##  Bat help
# alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
##  Podman/Docker
alias pi='podman image'
alias pc='podman container'
alias di='docker image'
alias dc='docker container'
#   Misc 
alias dtf='export GIT_DIR=$HOME/.config/dotfiles && export GIT_WORK_TREE=$HOME'
alias picocom='picocom -b 115200 /dev/ttyUSB0'
alias n='nvim'
alias -g -- N='| nvim'
alias -g -- B='| bat'
alias -g -- R='| rg'

# Exports
export EDITOR=nvim
export DATA_HOME=$HOME/Data
export RUSTUP_HOME=$DATA_HOME/.rustup
export CARGO_HOME=$DATA_HOME/.cargo
export PIXI_HOME=$DATA_HOME/.pixi
export PYTHON_HISTORY=/dev/null
export PYTHONPYCACHEPREFIX=$HOME/.cache/pycache
export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"

if [[ "$(uname)" == "Linux" ]]; then
  export PIXI_CACHE_DIR=$DATA_HOME/.cache/rattler
  export _RR_TRACE_DIR=$DATA_HOME/.local/share/rr
  # cs
  export COURSIER_INSTALL_DIR=$DATA_HOME/.local/share/coursier/bin
  export COURSIER_CACHE=$DATA_HOME/.cache/coursier/v1
  export COURSIER_JVM_CACHE=$DATA_HOME/.cache/coursier/jvm
  export COURSIER_ARCHIVE_CACHE=$DATA_HOME/.cache/coursier/arc
fi

#   Export PATH
export PATH=$PIXI_HOME/bin:$CARGO_HOME/bin:$DATA_HOME/.local/bin:$PATH
if [[ "$(uname)" == "Linux" ]]; then
  export PATH=$COURSIER_INSTALL_DIR:$PATH
elif [[ "$(uname)" == "Darwin" ]]; then
  export PATH=$HOMEBREW_PREFIX/opt/make/libexec/gnubin:$PATH
fi
# Deduplicate PATH
typeset -U path
