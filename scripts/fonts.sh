#!/bin/sh -e

# -----------------------------------------------------------------------------
# Terminal & Development Fonts Setup
# -----------------------------------------------------------------------------

installMesloLGSNerdFontMono() {
    FONT_NAME="MesloLGS Nerd Font Mono"
    if fc-list :family | grep -iq "$FONT_NAME"; then
        printf "%b\n" "${GREEN}Font '$FONT_NAME' is installed.${RC}"
    else
        printf "%b\n" "${YELLOW}Installing font '$FONT_NAME'${RC}"

        FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip"
        FONT_DIR="$HOME/.local/share/fonts"
        TEMP_DIR=$(mktemp -d)
        curl -sSLo "$TEMP_DIR"/"${FONT_NAME}".zip "$FONT_URL"
        unzip "$TEMP_DIR"/"${FONT_NAME}".zip -d "$TEMP_DIR"
        mkdir -p "$FONT_DIR"/"$FONT_NAME"
        mv "${TEMP_DIR}"/*.ttf "$FONT_DIR"/"$FONT_NAME"
        fc-cache -fv
        rm -rf "${TEMP_DIR}"
        printf "%b\n" "${GREEN}'$FONT_NAME' installed successfully.${RC}"
    fi
}

installJetBrainsMono() {
    FONT_NAME="JetBrainsMono Nerd Font"
    if fc-list :family | grep -iq "$FONT_NAME"; then
        printf "%b\n" "${GREEN}Font '$FONT_NAME' is already installed.${RC}"
    else
        printf "%b\n" "${YELLOW}Installing font '$FONT_NAME'...${RC}"
        
        FONT_URL="https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip"
        FONT_DIR="$HOME/.local/share/fonts"
        TEMP_DIR=$(mktemp -d)
        curl -sSLo "$TEMP_DIR"/"${FONT_NAME}".zip "$FONT_URL"
        unzip "$TEMP_DIR"/"${FONT_NAME}".zip -d "$TEMP_DIR"
        mkdir -p "$FONT_DIR"/"$FONT_NAME"
        mv "${TEMP_DIR}"/*.ttf "$FONT_DIR"/"$FONT_NAME"
        fc-cache -fv
        rm -rf "${TEMP_DIR}"
        printf "%b\n" "${GREEN}'$FONT_NAME' installed successfully.${RC}"
    fi
}

installTerminessNerdFont() {
    FONT_NAME="Terminess Nerd Font"
    if fc-list :family | grep -iq "$FONT_NAME"; then
        printf "%b\n" "${GREEN}Font '$FONT_NAME' is already installed.${RC}"
    else
        printf "%b\n" "${YELLOW}Installing font '$FONT_NAME'...${RC}"
        
        FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.5.0/Terminus.zip"
        FONT_DIR="$HOME/.local/share/fonts"
        TEMP_DIR=$(mktemp -d)
        curl -sSLo "$TEMP_DIR"/"${FONT_NAME}".zip "$FONT_URL"
        unzip "$TEMP_DIR"/"${FONT_NAME}".zip -d "$TEMP_DIR"
        mkdir -p "$FONT_DIR"/"$FONT_NAME"
        mv "${TEMP_DIR}"/*.ttf "$FONT_DIR"/"$FONT_NAME"
        fc-cache -fv
        rm -rf "${TEMP_DIR}"
        printf "%b\n" "${GREEN}'$FONT_NAME' installed successfully.${RC}"
    fi
}

activateFontCacheServices() {
    if command -v fc-cache >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Flushing system font server indexing layouts...${RC}"
        fc-cache -f "$HOME/.local/share/fonts"
        printf "%b\n" "${GREEN}Font server architecture configurations synchronized completely.${RC}"
    else
        printf "%b\n" "${YELLOW}Skipping font cache flush: fc-cache command utility missing.${RC}"
    fi
}

installMesloLGSNerdFontMono
installJetBrainsMono
installTerminessNerdFont
activateFontCacheServices
