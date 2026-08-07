#!/bin/sh -e

# -----------------------------------------------------------------------------
# Display Manager (SDDM)
#
# sddm - Simple Desktop Display Manager used by KDE Plasma. This installs SDDM, 
#        enables it to start at boot, and configures the system to boot into 
#        the graphical target by default.
# -----------------------------------------------------------------------------

installSddmPackages() {
    # Check if the sddm package is installed using system rpm database queries
    if ! rpm -q sddm >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Installing SDDM Display Manager...${RC}"
        sudo dnf install -y sddm
        printf "%b\n" "${GREEN}SDDM packages successfully installed.${RC}"
    else
        printf "%b\n" "${GREEN}SDDM package is already installed.${RC}"
    fi
}

startSddmServices() {
    printf "%b\n" "${YELLOW}Configuring system boot target and initializing SDDM...${RC}"

    # Set the system's default systemd target to graphical mode (runlevel 5)
    if ! sudo systemctl set-default graphical.target >/dev/null 2>&1; then
        printf "%b\n" "${RED}Warning: Failed to set default target to graphical.target${RC}"
    fi

    # Enable and launch the login manager daemon
    if sudo systemctl enable --now sddm; then
        printf "%b\n" "${GREEN}SDDM service is enabled and initialized!${RC}"
    else
        printf "%b\n" "${RED}Error: Failed to enable or start the SDDM service.${RC}"
        return 1
    fi
}

installSddmPackages
startSddmServices

