#!/bin/sh -e

# -----------------------------------------------------------------------------
# Communication Applications
#
# discord          - Voice, video, and text chat for communities and teams.
# signal-desktop   - Privacy-focused encrypted messaging.
# zapzap           - WhatsApp desktop client.
# zoom-workplace   - Video conferencing and online meetings.
# -----------------------------------------------------------------------------

installDiscord() {
    if ! rpm -q discord >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Installing Discord...${RC}"
        sudo dnf install -y discord
    else
        printf "%b\n" "${GREEN}Discord is already installed.${RC}"
    fi
}

installSignal() {
    if ! rpm -q signal-desktop >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Adding Signal repository and installing...${RC}"
        sudo rpm --import https://updates.signal.org/desktop/apt/keys.asc

        cat <<EOF | sudo tee /etc/yum.repos.d/signal.repo > /dev/null
[signal]
name=Signal
baseurl=https://updates.signal.org/desktop/yum/x86_64
enabled=1
gpgcheck=1
gpgkey=https://updates.signal.org/desktop/apt/keys.asc
EOF

        sudo dnf install -y signal-desktop
        printf "%b\n" "${GREEN}Signal installed successfully.${RC}"
    else
        printf "%b\n" "${GREEN}Signal-desktop is already installed.${RC}"
    fi
}

installZapzap() {
    if ! flatpak info com.rtosta.zapzap >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Installing ZapZap Flatpak...${RC}"
        flatpak install -y flathub com.rtosta.zapzap
    else
        printf "%b\n" "${GREEN}ZapZap Flatpak is already installed.${RC}"
    fi
}

installZoom() {
    if ! rpm -q zoom >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Downloading and installing Zoom Workplace...${RC}"
        ZOOM_RPM=$(mktemp)

        curl -fsSL \
            https://zoom.us/client/latest/zoom_x86_64.rpm \
            -o "$ZOOM_RPM"

        sudo dnf install -y "$ZOOM_RPM"
        rm -f "$ZOOM_RPM"
        printf "%b\n" "${GREEN}Zoom installed successfully.${RC}"
    else
        printf "%b\n" "${GREEN}Zoom is already installed.${RC}"
    fi
}

installDiscord
installSignal
installZapzap
installZoom
