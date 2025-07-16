#!/bin/zsh -f

if [[ ! -d $HOME/.config/dotfiles ]]; then
  git clone --bare https://github.com/demin-han/dotfiles.git $HOME/.config/dotfiles
  git --git-dir=$HOME/.config/dotfiles --work-tree=$HOME checkout
  git --git-dir=$HOME/.config/dotfiles --work-tree=$HOME config --local status.showUntrackedFiles no
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
  sudo pacman -S --needed --noconfirm cmake ninja meson scons remake
  sudo pacman -S --needed --noconfirm clang llvm gdb lldb lld mold
  sudo pacman -S --needed --noconfirm fzf fd ripgrep eza bat
  sudo pacman -S --needed --noconfirm graphviz xdot
  sudo pacman -S --needed --noconfirm direnv poke
  sudo pacman -S --needed --noconfirm z3
  sudo pacman -S --needed --noconfirm github-cli perl-io-socket-ssl perl-authen-sasl repo
  sudo pacman -S --needed --noconfirm podman podman-docker podman-compose buildah skopeo
  sudo pacman -S --needed --noconfirm jq nnn btop sshfs gparted
  sudo pacman -S --needed --noconfirm rustup go
  sudo pacman -S --needed --noconfirm picocom
  sudo pacman -S --needed --noconfirm bc gperf patchutils
  sudo pacman -S --needed --noconfirm remmina
  sudo pacman -S --needed --noconfirm uv pixi ouch zoxide dua-cli 3cpio binwalk
  sudo pacman -S --needed --noconfirm tk expect aria2
  sudo pacman -S --needed --noconfirm nodejs npm
  sudo pacman -S --needed --noconfirm qemu-user-static qemu-user-static-binfmt

  if [[ ! -d /var/cache/yay ]]; then
    sudo mkdir -p -m 777 /var/cache/yay
    yay --builddir /var/cache/yay --save
  fi

  yay -S --needed clash-verge-rev-bin
  yay -S --needed google-chrome
  yay -S --needed bcompare
  yay -S --needed rr
  yay -S --needed dufs-bin
  yay -S --needed rsyncy-bin

  sudo pacman -Rsnu firefox
}

update_cfg() {
  echo "Update config"

  if [[ ! -d $HOME/.config/tmux/oh-my-tmux ]]; then
    mkdir -p $HOME/.config/tmux
    pushd $HOME/.config/tmux
    git clone https://github.com/gpakosz/.tmux.git oh-my-tmux || exit 1
    ln -sf oh-my-tmux/.tmux.conf tmux.conf
    if [[ ! -f tmux.conf.local ]]; then
      cp oh-my-tmux/.tmux.conf.local tmux.conf.local
    fi
    popd
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
  sudo usermod -a -G uucp $USER
}

update_softlink() {
  ln -s $DATA_HOME/.local/share/containers $HOME/.local/share/
  ln -s $DATA_HOME/.local/share/gnome-boxes $HOME/.local/share/

  ln -s $DATA_HOME/Downloads $HOME/
  ln -s $DATA_HOME/.config/google-chrome $HOME/.config/
}

main() {
  local PKG CFG
  if [[ $# -eq 0 ]]; then
    PKG='-p'
    CFG='-c'
  else
    zparseopts -D -K -- \
    {p,-pkg}=PKG \
    {c,-cfg}=CFG \
    {l,-link}=LINK
  fi

  [[ -n $PKG ]] && update_pkg
  [[ -n $CFG ]] && update_cfg
  [[ -n $LINK ]] && update_softlink
  return 0
}

main $@
