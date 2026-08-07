#!/bin/sh -e

# -----------------------------------------------------------------------------
# Virtualization Tools
#
# bottles      - Easily run Windows software and games on Linux using wine prefixes.
# virt-manager - Desktop user interface for managing virtual machines via KVM/QEMU.
# -----------------------------------------------------------------------------

installVirtManager() {
    # Check if virt-manager is missing from system path binaries
    if ! command -v virt-manager >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Installing Virt-Manager and QEMU/KVM hypervisor dependencies...${RC}"
        
        sudo dnf install -y \
            virt-manager \
            qemu-kvm \
            libvirt \
            libvirt-client \
            virt-install \
            virt-viewer
            
        printf "%b\n" "${GREEN}Virt-Manager system packages successfully installed.${RC}"
    else
        printf "%b\n" "${GREEN}Virt-Manager system packages are already installed.${RC}"
    fi
}

installBottles() {
    # Check if native Bottles package is missing from the system package database
    if ! rpm -q bottles >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Installing Bottles natively via DNF...${RC}"
        sudo dnf install -y bottles
        printf "%b\n" "${GREEN}Bottles native DNF package installed successfully.${RC}"
    else
        printf "%b\n" "${GREEN}Bottles is already installed.${RC}"
    fi
}

startVirtManagerServices() {
    printf "%b\n" "${YELLOW}Configuring libvirt daemon hooks and user execution groups...${RC}"

    # Enable and start the core libvirt background virtualization service manager
    if sudo systemctl enable --now libvirtd; then
        printf "%b\n" "${GREEN}Libvirtd virtualization service is enabled and running.${RC}"
    else
        printf "%b\n" "${RED}Error: Failed to enable or start the libvirtd service.${RC}"
        return 1
    fi

    # Add the current user running the script to the libvirt group 
    # This prevents virt-manager from asking for your root sudo password every single time it opens
    CURRENT_USER=$(whoami)
    if getent group libvirt >/dev/null 2>&1; then
        if ! groups "$CURRENT_USER" | grep -q "\blibvirt\b"; then
            printf "%b\n" "${YELLOW}Adding user $CURRENT_USER to 'libvirt' group for passwordless VM access...${RC}"
            sudo usermod -aG libvirt "$CURRENT_USER"
            printf "%b\n" "${GREEN}User group permissions mapped. Note: A system relog may be required.${RC}"
        else
            printf "%b\n" "${GREEN}User $CURRENT_USER is already a member of the 'libvirt' group.${RC}"
        fi
    fi
}

installVirtManager
installBottles
startVirtManagerServices
