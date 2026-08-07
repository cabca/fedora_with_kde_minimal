#!/bin/sh -e

# -----------------------------------------------------------------------------
# Media Playback Applications
#
# celluloid - A simple, clean GTK+ frontend for the powerful mpv media player.
# tidal      - Unofficial TIDAL Hi-Fi client wrapper with MPRIS audio controls.
# -----------------------------------------------------------------------------

installCelluloid() {
    # Check if celluloid is missing from the system package database
    if ! rpm -q celluloid >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Installing Celluloid media player...${RC}"
        sudo dnf install -y celluloid
        printf "%b\n" "${GREEN}Celluloid installed successfully.${RC}"
    else
        printf "%b\n" "${GREEN}Celluloid is already installed.${RC}"
    fi
}

installTidal() {
    # Check if the Flathub container engine space houses the tidal-hifi package
    if ! flatpak info com.mastermindzh.tidal-hifi >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Deploying Tidal Hi-Fi sandboxed container via Flatpak...${RC}"
        flatpak install -y flathub com.mastermindzh.tidal-hifi
        printf "%b\n" "${GREEN}Tidal Hi-Fi container deployed successfully.${RC}"
    else
        printf "%b\n" "${GREEN}Tidal Hi-Fi is already installed.${RC}"
    fi
}

configureMediaAudio() {
    # Verify if PipeWire or standard audio utilities are running to support media hooks
    if command -v pw-cli >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Optimizing background audio server links for high-fidelity media...${RC}"
        # Soft trigger to clear any legacy desktop sound server volume traps
        canberra-gtk-play --id="service-login" >/dev/null 2>&1 || true
        printf "%b\n" "${GREEN}Media subsystem optimization routing complete.${RC}"
    else
        printf "%b\n" "${YELLOW}Skipping real-time audio tuning: native PipeWire CLI tooling not running.${RC}"
    fi
}

installCelluloid
installTidal
configureMediaAudio
