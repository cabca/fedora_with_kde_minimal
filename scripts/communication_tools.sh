#!/bin/sh
# -----------------------------------------------------------------------------
# Communication Applications
#
# discord          - Voice, video, and text chat for communities and teams.
# signal-desktop   - Privacy-focused encrypted messaging.
# zapzap           - WhatsApp desktop client.
# zoom-workplace   - Video conferencing and online meetings.
# -----------------------------------------------------------------------------
set -eu

. ../install.sh

install_discord() {
    if rpm -q discord >/dev/null 2>&1; then
        log_ok "Discord is already installed."
        return 0
    fi

    log_info "Installing Discord..."
    if sudo dnf install -y discord; then
        log_ok "Discord installed successfully."
    else
        log_error "Failed to install Discord."
        return 1
    fi
}

install_signal() {
    if rpm -q signal-desktop >/dev/null 2>&1; then
        log_ok "Signal Desktop is already installed."
        return 0
    fi

    log_info "Adding Signal repository and installing..."

    if ! sudo rpm --import https://updates.signal.org/desktop/apt/keys.asc; then
        log_error "Failed to import Signal's GPG key."
        return 1
    fi

    cat <<EOF | sudo tee /etc/yum.repos.d/signal.repo > /dev/null
[signal]
name=Signal
baseurl=https://updates.signal.org/desktop/yum/x86_64
enabled=1
gpgcheck=1
gpgkey=https://updates.signal.org/desktop/apt/keys.asc
EOF

    if sudo dnf install -y signal-desktop; then
        log_ok "Signal installed successfully."
    else
        log_error "Failed to install Signal."
        return 1
    fi
}

install_zapzap() {
    require_cmd flatpak

    if flatpak info com.rtosta.zapzap >/dev/null 2>&1; then
        log_ok "ZapZap Flatpak is already installed."
        return 0
    fi

    if ! flatpak remote-list 2>/dev/null | grep -q '^flathub'; then
        log_error "Flathub remote is not configured. Add it with:"
        log_error "  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo"
        return 1
    fi

    log_info "Installing ZapZap Flatpak..."
    if flatpak install -y flathub com.rtosta.zapzap; then
        log_ok "ZapZap installed successfully."
    else
        log_error "Failed to install ZapZap."
        return 1
    fi
}

install_zoom() {
    require_cmd curl

    if rpm -q zoom >/dev/null 2>&1; then
        log_ok "Zoom is already installed."
        return 0
    fi

    log_info "Downloading and installing Zoom Workplace..."

    # NOTE: Zoom doesn't publish an easily-consumable checksum for this
    # endpoint, so we're relying on TLS transport security only. Worth
    # revisiting if a verifiable checksum/signature becomes available.
    zoom_rpm=$(mktemp)
    trap 'rm -f "$zoom_rpm"' EXIT INT TERM

    if ! curl -fsSL --max-time 60 \
        https://zoom.us/client/latest/zoom_x86_64.rpm \
        -o "$zoom_rpm"; then
        log_error "Failed to download Zoom."
        return 1
    fi

    if sudo dnf install -y "$zoom_rpm"; then
        log_ok "Zoom installed successfully."
    else
        log_error "Failed to install Zoom."
        return 1
    fi

    rm -f "$zoom_rpm"
    trap - EXIT INT TERM
}

main() {
    require_cmd rpm
    require_cmd dnf

    install_discord
    install_signal
    install_zapzap
    install_zoom
}

main "$@"
