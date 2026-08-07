#!/bin/sh
# -----------------------------------------------------------------------------
# Display Manager (SDDM)
#
# sddm - Simple Desktop Display Manager used by KDE Plasma. This installs SDDM,
#        enables it to start at boot, and configures the system to boot into
#        the graphical target by default.
# -----------------------------------------------------------------------------
set -eu

# Fall back to sane defaults if this script is run standalone instead of
# sourced after the framework's color/log definitions.
RC="${RC:-$(printf '\033[0m')}"
RED="${RED:-$(printf '\033[0;31m')}"
GREEN="${GREEN:-$(printf '\033[0;32m')}"
YELLOW="${YELLOW:-$(printf '\033[1;33m')}"

log_info()  { printf "%b\n" "${YELLOW}$*${RC}"; }
log_ok()    { printf "%b\n" "${GREEN}$*${RC}"; }
log_error() { printf "%b\n" "${RED}$*${RC}" >&2; }

require_cmd() {
    command -v "$1" >/dev/null 2>&1 || {
        log_error "Required command '$1' not found. Aborting."
        exit 1
    }
}

install_sddm_package() {
    if rpm -q sddm >/dev/null 2>&1; then
        log_ok "SDDM package is already installed."
        return 0
    fi

    log_info "Installing SDDM Display Manager..."
    if sudo dnf install -y sddm; then
        log_ok "SDDM package successfully installed."
    else
        log_error "Failed to install SDDM package."
        return 1
    fi
}

configure_sddm_service() {
    log_info "Configuring system boot target and initializing SDDM..."

    # Non-fatal: booting to the wrong target is annoying but not
    # install-breaking, so we warn and continue rather than aborting.
    if ! sudo systemctl set-default graphical.target; then
        log_error "Warning: failed to set default target to graphical.target"
    fi

    if sudo systemctl enable --now sddm; then
        log_ok "SDDM service is enabled and running."
    else
        log_error "Failed to enable or start the SDDM service."
        return 1
    fi
}

main() {
    require_cmd rpm
    require_cmd dnf
    require_cmd systemctl

    install_sddm_package
    configure_sddm_service
}

main "$@"
