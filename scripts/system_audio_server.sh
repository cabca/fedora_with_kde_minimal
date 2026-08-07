#!/bin/sh -e

# -----------------------------------------------------------------------------
# Audio (PipeWire)
#
# pipewire        - Multimedia server
# pipewire-pulse  - PulseAudio compatibility layer
# wireplumber     - PipeWire session manager
# -----------------------------------------------------------------------------

installPipewirePackages() {
    # Check if pipewire or wireplumber binaries are missing
    if ! command -v pipewire >/dev/null 2>&1 || ! command -v pipewire-pulse >/dev/null 2>&1 || ! command -v wireplumber >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Installing PipeWire packages...${RC}"
        sudo dnf install -y \
            pipewire \
            pipewire-pulse \
            wireplumber
        printf "%b\n" "${GREEN}PipeWire packages successfully installed.${RC}"
    else
        printf "%b\n" "${GREEN}PipeWire packages are already installed.${RC}"
    fi
}

startPipewireServices() {
    printf "%b\n" "${YELLOW}Configuring and starting PipeWire user services...${RC}"

    # Safely disable legacy PulseAudio to prevent audio server hardware conflicts
    systemctl --user disable --now pulseaudio.socket pulseaudio.service >/dev/null 2>&1 || true
    systemctl --user mask pulseaudio.socket pulseaudio.service >/dev/null 2>&1 || true

    # Enable and launch the active PipeWire audio graph components
    if systemctl --user enable --now pipewire.socket pipewire-pulse.socket wireplumber.service; then
        printf "%b\n" "${GREEN}PipeWire services are up and running!${RC}"
    else
        printf "%b\n" "${RED}Error: Failed to start PipeWire systemd user units.${RC}"
        return 1
    fi
}

installPipewirePackages
startPipewireServices
