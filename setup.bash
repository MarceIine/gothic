#!/usr/bin/env bash

# Configuration
PACKAGE_FILE="packages.txt"

# ---- Error handling ----
set -eo pipefail

# ---- Functions ----

install_oh_my_zsh() {
  clear
  if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "oh-my-zsh is already installed."
    return 0
  fi

  echo "Installing oh-my-zsh..."
  RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
  echo "Finished installing oh-my-zsh"

  echo "Installing zsh plugins..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
  git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"

  echo "Stowing zsh dotfiles..."
  rm -f "$HOME/.zshrc"
  stow -t "$HOME" "dotfiles/zsh"

  read -rp "Restart session to apply changes? [y/N] " response
  if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "Logging out..."
    pkill -u $USER -KILL
  fi
}

install_yay() {
  if ! command -v yay >/dev/null 2>&1; then
    echo "Installing yay..."
    temp_dir=$(mktemp -d)
    trap 'rm -rf "$temp_dir"' EXIT

    sudo pacman -S --needed --noconfirm git base-devel || return 1
    git clone https://aur.archlinux.org/yay-bin.git "$temp_dir" || return 1
    (cd "$temp_dir" && makepkg -si --noconfirm) || return 1
  else
    echo "yay is already installed"
  fi
}

install_packages() {
  if [[ ! -f "$PACKAGE_FILE" ]]; then
    echo "Error: Package file '$PACKAGE_FILE' not found!"
    exit 1
  fi

  echo "Reading packages from $PACKAGE_FILE..."
  mapfile -t packages < <(
    grep -Ev '^\s*#|^\s*$' "$PACKAGE_FILE" | sed -e 's/#.*//' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' | awk 'NF'
  )

  if [[ ${#packages[@]} -eq 0 ]]; then
    echo "Error: No valid packages found in $PACKAGE_FILE"
    exit 1
  fi

  echo "Packages to be installed:"
  printf '[%s]\n' "${packages[@]}"

  read -rp "Proceed with installation? [y/N] " response
  [[ "$response" =~ ^[Yy]$ ]] || exit 0

  install_yay || exit 1
  echo "Starting installation..."
  yay -Syu --needed --noconfirm --repo "${packages[@]}"
}

stow_dotfiles() {
  mv ~/.config{,.bak}
  mkdir "$HOME/.config"
  echo "Stowing configuration files..."
  stow -t "$HOME/.config" .config
  echo "Dotfiles successfully stowed!"
}

install() {
  echo "Starting installation..."
  install_packages
  stow_dotfiles
  install_oh_my_zsh
}

uninstall() {
  echo "Uninstalling..."
}

help() {
  echo "Usage: $0 [install|uninstall|help]"
  echo "Options:"
  echo "  install   - Perform installation"
  echo "  uninstall - Perform uninstallation"
  echo "  help      - Show this help message"
}

case "$1" in
install)
  install
  ;;
uninstall)
  uninstall
  ;;
help)
  help
  ;;
*)
  echo "Invalid option. Use 'help' for usage details."
  exit 1
  ;;
esac
