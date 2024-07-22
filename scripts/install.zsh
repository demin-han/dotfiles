#!/bin/zsh -f

if [[ ! -d $HOME/.dotfiles ]]; then
  git clone --bare https://github.com/demin-han/dotfiles.git $HOME/.dotfiles
  git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout
  git --git-dir=$HOME/.dotfiles --work-tree=$HOME config --local status.showUntrackedFiles no
  return
fi

update_pkg() {
  echo "Update package"
  sudo pacman -Rsnu firefox
  # sudo pacman -Rsnu thunderbird
  # sudo pacman -Rsnu gnome-calendar

  sudo pacman-mirrors -c China
  sudo pacman -Syu

  sudo pacman -S --needed base-devel
  sudo pacman -S --needed linux-tools
  sudo pacman -S --needed fcitx5-im fcitx5-rime
  sudo pacman -S --needed yay
  sudo pacman -S --needed tmux
  sudo pacman -S --needed neovim
  sudo pacman -S --needed cmake ninja meson scons
  sudo pacman -S --needed clang llvm gdb lldb lld mold
  sudo pacman -S --needed fzf fd ripgrep
  sudo pacman -S --needed graphviz xdot
  sudo pacman -S --needed direnv
  sudo pacman -S --needed z3
  sudo pacman -S --needed github-cli
  sudo pacman -S --needed docker
  sudo pacman -S --needed jq nnn
  sudo pacman -S --needed rustup go
  sudo pacman -S --needed act

  sudo mkdir -p -m 777 /var/cache/yay
  yay --builddir /var/cache/yay --save

  yay -S --needed --noconfirm clash-verge-rev-bin
  yay -S --needed --noconfirm google-chrome
  yay -S --needed --noconfirm bcompare
  yay -S --needed rr

  zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1
}

update_zsh_cfg() {
  echo "Update zsh config"
  cat $HOME/.local/share/zap/templates/default-zshrc > $HOME/.zshrc
  cat $HOME/scripts/zshrc-user.zsh >> $HOME/.zshrc
}

update_cfg() {
  echo "Update config"
  update_zsh_cfg

  sudo mkdir -p -m 777 /var/cache/rr
  sudo mkdir -p -m 777 /var/cache/pycache
  # sudo usermod -aG docker $USER

  git clone https://github.com/gpakosz/.tmux.git $HOME/.tmux
  ln -sf $HOME/.tmux/.tmux.conf $HOME/.tmux.conf
  if [[ ! -f $HOME/.tmux.conf.local ]]; then
    cp $HOME/.tmux/.tmux.conf.local $HOME/
  fi


  if [[ ! -d $HOME/.config/nvim ]]; then
    git clone https://github.com/LazyVim/starter $HOME/.config/nvim
    rm -rf $HOME/.config/nvim/.git
  fi

  # disable $HOME/.debug folder
  perf config buildid.dir=/dev/null
}

main() {
  local PKG CFG ZSH_CFG
  if [[ $# -eq 0 ]]; then
    PKG='-p'
    CFG='-c'
    ZSH_CFG='-z'
  else
    zparseopts -D -K -- \
    {p,-pkg}=PKG \
    {c,-cfg}=CFG \
    {z,-zsh}=ZSH_CFG \

  fi

  [[ -n $PKG ]] && update_pkg
  [[ -n $CFG ]] && update_cfg
  [[ -n $ZSH_CFG ]] && update_zsh_cfg
  return 0
}

main $@
