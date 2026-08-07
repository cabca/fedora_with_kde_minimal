#!/bin/sh
# -----------------------------------------------------------------------------
# Multimedia & Content Creation Applications
#
# gimp             - GNU Image Manipulation Program.
# obs-studio       - Free and open source software for video recording and live streaming.
# audacity         - Multi-track audio editor and recorder.
# davinci-resolve  - Professional video editing, color correction, and audio post-production.
# -----------------------------------------------------------------------------
set -eu

. ../install.sh

# install_dnf_package <rpm-name> [display-name]
# Generic "is it installed, if not install it" wrapper so gimp/obs/audacity
# don't each need their own copy-pasted function.
install_dnf_package() {
    pkg="$1"
    label="${2:-$1}"

    if rpm -q "$pkg" >/dev/null 2>&1; then
        log_ok "${label} is already installed."
        return 0
    fi

    log_info "Installing ${label}..."
    if sudo dnf install -y "$pkg"; then
        log_ok "${label} installed successfully."
    else
        log_error "Failed to install ${label}."
        return 1
    fi
}

install_davinci_resolve() {
    if [ -d /opt/resolve ]; then
        log_ok "DaVinci Resolve application files detected in /opt/resolve."
        return 0
    fi

    log_info "Installing core system dependencies for DaVinci Resolve..."
    if ! sudo dnf install -y apr apr-util mesa-libGLU libxcrypt-compat; then
        log_error "Failed to install DaVinci Resolve dependencies."
        return 1
    fi

    cat <<MSG
${YELLOW}======================================================================${RC}
${YELLOW}DaVinci Resolve requires manual licensing terms and direct download.${RC}
${YELLOW}1. Download the Linux version from https://blackmagicdesign.com${RC}
${YELLOW}2. Unzip and run the installer script via terminal using:${RC}
${YELLOW}   sudo SKIP_PACKAGE_CHECK=1 ./DaVinci_Resolve_<version>_Linux.run${RC}
${YELLOW}3. Rerun this script to safely apply necessary compatibility fixes.${RC}
${YELLOW}======================================================================${RC}
MSG
}

configure_davinci_resolve() {
    resolve_libs="/opt/resolve/libs"

    if [ ! -d "$resolve_libs" ]; then
        log_info "Skipping DaVinci patches: ${resolve_libs} directory not found yet."
        return 0
    fi

    log_info "Configuring DaVinci Resolve shared library optimizations..."
    sudo mkdir -p "${resolve_libs}/disabled-libraries"

    # Target internal incompatible legacy libraries bundled with the
    # application wrapper. Moving these forces Resolve to cleanly fall
    # back to system native Fedora libraries.
    moved=0
    for lib in "${resolve_libs}"/libglib* "${resolve_libs}"/libgio* "${resolve_libs}"/libgmodule*; do
        [ -f "$lib" ] || [ -L "$lib" ] || continue
        if sudo mv "$lib" "${resolve_libs}/disabled-libraries/"; then
            moved=$((moved + 1))
        else
            log_error "Failed to move $(basename "$lib") — check permissions."
        fi
    done

    log_ok "DaVinci Resolve compatibility layers optimized (${moved} librar$([ "$moved" = 1 ] && echo y || echo ies) moved)."
}

main() {
    require_cmd rpm
    require_cmd dnf

    install_dnf_package gimp GIMP
    install_dnf_package obs-studio "OBS Studio"
    install_dnf_package audacity Audacity
    install_davinci_resolve
    configure_davinci_resolve
}

main "$@"
