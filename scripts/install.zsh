#!/bin/zsh -f

if [[ ! -d $HOME/.dotfiles ]]; then
  git clone --bare https://github.com/demin-han/dotfiles.git $HOME/.dotfiles
  git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout
  git --git-dir=$HOME/.dotfiles --work-tree=$HOME config --local status.showUntrackedFiles no
  return
fi

update_pkg() {
  echo "Update package"

  sudo pacman-mirrors -c China
  sudo pacman -Syu

  sudo pacman -S --needed --noconfirm base-devel
  sudo pacman -S --needed --noconfirm linux-tools
  sudo pacman -S --needed --noconfirm fcitx5-im fcitx5-rime
  sudo pacman -S --needed --noconfirm yay
  sudo pacman -S --needed --noconfirm tmux
  sudo pacman -S --needed --noconfirm neovim xclip
  sudo pacman -S --needed --noconfirm cmake ninja meson scons
  sudo pacman -S --needed --noconfirm clang llvm gdb lldb lld mold
  sudo pacman -S --needed --noconfirm fzf fd ripgrep
  sudo pacman -S --needed --noconfirm graphviz xdot
  sudo pacman -S --needed --noconfirm direnv poke
  sudo pacman -S --needed --noconfirm z3
  sudo pacman -S --needed --noconfirm github-cli
  sudo pacman -S --needed --noconfirm podman podman-docker podman-compose buildah skopeo distrobox
  sudo pacman -S --needed --noconfirm jq nnn btop sshfs gparted
  sudo pacman -S --needed --noconfirm rustup go
  sudo pacman -S --needed --noconfirm act
  sudo pacman -S --needed --noconfirm bc gperf patchutils
  sudo pacman -S --needed --noconfirm remmina
  sudo pacman -S --needed --noconfirm python-pipx
  sudo pacman -S --needed --noconfirm tk
  sudo pacman -S --needed gnome-control-center-x11-scaling mutter-x11-scaling

  sudo mkdir -p -m 777 /var/cache/yay
  yay --builddir /var/cache/yay --save

  yay -S --needed --noconfirm clash-verge-rev-bin
  yay -S --needed --noconfirm google-chrome
  yay -S --needed --noconfirm bcompare
  yay -S --needed rr

  sudo pacman -Rsnu firefox
}

update_zsh_cfg() {
  echo "Update zsh config"
  if [[ ! -v ZAP_DIR ]]; then
    git clone https://github.com/zap-zsh/zap.git /tmp/zap || exit 1
  fi
  /tmp/zap/install.zsh && \
  cat $HOME/.local/share/zap/templates/default-zshrc > $HOME/.zshrc && \
  cat $HOME/scripts/zshrc-user.zsh >> $HOME/.zshrc
}

update_cfg() {
  echo "Update config"
  update_zsh_cfg

  if [[ ! -d $HOME/.tmux ]]; then
    git clone https://github.com/gpakosz/.tmux.git $HOME/.tmux || exit 1
    ln -sf $HOME/.tmux/.tmux.conf $HOME/.tmux.conf
    if [[ ! -f $HOME/.tmux.conf.local ]]; then
      cp $HOME/.tmux/.tmux.conf.local $HOME/
    fi
  fi

  if [[ ! -d $HOME/.config/nvim ]]; then
    git clone https://github.com/LazyVim/starter $HOME/.config/nvim
    rm -rf $HOME/.config/nvim/.git
  fi

  # disable $HOME/.debug folder
  perf config buildid.dir=/dev/null
  echo 'kernel.perf_event_paranoid=1' | sudo tee '/etc/sysctl.d/51-enable-perf-events.conf'
  sudo systemctl enable cronie
  sudo systemctl enable systemd-oomd
  systemctl enable --user podman.socket
}

update_softlink() {
  ln -s $DATA_HOME/.local/share/containers $HOME/.local/share/
  ln -s $DATA_HOME/.local/share/gnome-boxes $HOME/.local/share/

  ln -s $DATA_HOME/Downloads $HOME/
  ln -s $DATA_HOME/.config/google-chrome $HOME/.config/
}

main() {
  local PKG CFG ZSH_CFG
  if [[ $# -eq 0 ]]; then
    PKG='-p'
    CFG='-c'
  else
    zparseopts -D -K -- \
    {p,-pkg}=PKG \
    {c,-cfg}=CFG \
    {z,-zsh}=ZSH_CFG \
    {l,-link}=LINK
  fi

  [[ -n $PKG ]] && update_pkg
  [[ -n $CFG ]] && update_cfg
  [[ -n $ZSH_CFG ]] && update_zsh_cfg
  [[ -n $LINK ]] && update_softlink
  return 0
}

main $@
