#!/bin/sh -e

# -----------------------------------------------------------------------------
# Bluetooth (Bluedevil)
#
# bluedevil - Bluetooth stack for KDE
# -----------------------------------------------------------------------------

installBluedevil() {
    # Check if the package is installed using dnf queries, as bluedevil is a KDE
    # plugin/daemon package and does not provide a direct standalone binary named 'bluedevil'.
    if ! rpm -q bluedevil >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Installing Bluedevil...${RC}"
        sudo dnf install -y bluedevil
    else
        printf "%b\n" "${GREEN}Bluedevil is already installed.${RC}"
    fi
}

startBluedevilServices() {
    printf "%b\n" "${YELLOW}Configuring and starting Bluedevil system services...${RC}"

    # Enable and launch the core hardware bluetooth system service
    if sudo systemctl enable --now bluetooth; then
        printf "%b\n" "${GREEN}Bluedevil services are up and running!${RC}"
    else
        printf "%b\n" "${RED}Error: Failed to start Bluedevil system units.${RC}"
        return 1
    fi
}

installBluedevil
startBluedevilServices
