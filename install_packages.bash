#!/usr/bin/env bash

# Configuration
PACKAGE_FILE="packages.txt"

# ---- Error handling ----
set -eo pipefail

# ---- Functions ----
setup_plugins() {
    # Updating twice might not be needed.
    hyprpm update
    hyprpm add https://github.com/hyprwm/hyprland-plugins
    hyprpm enable hyprexpo
    hyprpm update
}

enable_services() {
    systemctl --user enable dbus --now
    systemctl --user enable pipewire --now
    systemctl --user enable pipewire-pulse --now
    systemctl --user enable wireplumber --now
    sudo systemctl enable fstrim.timer
}

install_oh_my_zsh() {
    clear
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "oh-my-zsh is already installed."
        return 0
    fi

    # After installing oh-my-zsh it itself will ask the user whether they want to set their default shell to zsh.
    echo "Installing oh-my-zsh !"
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
    echo "Finished installing oh-my-zsh"

    clear

    echo "installing zsh-syntax-highlighting.git"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
    echo "Finished installing zsh-syntax-highlighting.git"

    echo "installing zsh-autosuggestions.git"
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
    echo "Finished installing zsh-autosuggestions"

    echo "Stowing zsh dotfiles."
    rm $HOME/.zshrc
    cd dotfiles/zsh && stow . -t ~
    echo "Sucessfully finished!!!"

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

# ---- Main script ----
main() {
    # Verify package file exists
    if [[ ! -f "$PACKAGE_FILE" ]]; then
        echo "Error: Package file '$PACKAGE_FILE' not found!"
        exit 1
    fi

    # Read packages with error checking
    echo "Reading packages from $PACKAGE_FILE..."
    mapfile -t packages < <(
        grep -Ev '^\s*#|^\s*$' "$PACKAGE_FILE" |                             # Remove comments and empty lines
            sed -e 's/#.*//' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' | # Trim all whitespace
            awk 'NF'                                                         # Remove any empty lines that might remain
    )

    if [[ ${#packages[@]} -eq 0 ]]; then
        echo "Error: No valid packages found in $PACKAGE_FILE"
        exit 1
    fi

    # Debug output to verify package list
    echo "Packages to be installed (verify no extra spaces):"
    printf '[%s]\n' "${packages[@]}"

    # Confirm before installation
    read -rp "Proceed with installation? [y/N] " response
    [[ "$response" =~ ^[Yy]$ ]] || exit 0

    # Install process
    install_yay || exit 1
    echo "Starting installation..."

    # Install all packages in one command
    yay -Syu --needed --noconfirm --repo "${packages[@]}"
    enable_services
    setup_plugins
    install_oh_my_zsh
}

main "$@"
