#!/bin/sh -e

# -----------------------------------------------------------------------------
# Terminal Emulator (Alacritty)
#
# alacritty - A fast, GPU-accelerated terminal emulator.
# -----------------------------------------------------------------------------

installAlacritty() {
    # Check if alacritty is NOT installed using a valid shell command
    if ! command -v alacritty >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Installing Alacritty...${RC}"
        sudo dnf install -y alacritty
    else
        printf "%b\n" "${GREEN}Alacritty is already installed.${RC}"
    fi
}

setupAlacrittyConfig() {
    printf "%b\n" "${YELLOW}Copying alacritty config files...${RC}"
    if [ -d "${HOME}/.config/alacritty" ] && [ ! -d "${HOME}/.config/alacritty-bak" ]; then
        cp -r "${HOME}/.config/alacritty" "${HOME}/.config/alacritty-bak"
    fi
    mkdir -p "${HOME}/.config/alacritty/"
    curl -sSLo "${HOME}/.config/alacritty/alacritty.toml" "https://raw.githubusercontent.com/ChrisTitusTech/dwm-titus/main/config/alacritty/alacritty.toml"
    curl -sSLo "${HOME}/.config/alacritty/keybinds.toml" "https://raw.githubusercontent.com/ChrisTitusTech/dwm-titus/main/config/alacritty/keybinds.toml"
    curl -sSLo "${HOME}/.config/alacritty/nordic.toml" "https://raw.githubusercontent.com/ChrisTitusTech/dwm-titus/main/config/alacritty/nordic.toml"
    printf "%b\n" "${GREEN}Alacritty configuration files copied.${RC}"
}

installAlacritty
setupAlacrittyConfig
