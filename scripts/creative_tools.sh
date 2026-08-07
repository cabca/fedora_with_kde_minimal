#!/bin/sh -e

# -----------------------------------------------------------------------------
# Multimedia & Content Creation Applications
#
# gimp             - GNU Image Manipulation Program.
# obs-studio       - Free and open source software for video recording and live streaming.
# audacity         - Multi-track audio editor and recorder.
# davinci-resolve  - Professional video editing, color correction, and audio post-production.
# -----------------------------------------------------------------------------

installGimp() {
    if ! rpm -q gimp >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Installing GIMP...${RC}"
        sudo dnf install -y gimp
        printf "%b\n" "${GREEN}GIMP installed successfully.${RC}"
    else
        printf "%b\n" "${GREEN}GIMP is already installed.${RC}"
    fi
}

installObsStudio() {
    if ! rpm -q obs-studio >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Installing OBS Studio...${RC}"
        sudo dnf install -y obs-studio
        printf "%b\n" "${GREEN}OBS Studio installed successfully.${RC}"
    else
        printf "%b\n" "${GREEN}OBS Studio is already installed.${RC}"
    fi
}

installAudacity() {
    if ! rpm -q audacity >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Installing Audacity...${RC}"
        sudo dnf install -y audacity
        printf "%b\n" "${GREEN}Audacity installed successfully.${RC}"
    else
        printf "%b\n" "${GREEN}Audacity is already installed.${RC}"
    fi
}

installDavinciResolve() {
    # Check if the core application binary directory or package metadata already exists
    if [ ! -d "/opt/resolve" ]; then
        printf "%b\n" "${YELLOW}Installing core system dependencies for DaVinci Resolve...${RC}"
        
        # Core libraries required by the installer package to boot or link properly
        sudo dnf install -y apr apr-util mesa-libGLU libxcrypt-compat
        
        printf "%b\n" "${YELLOW}======================================================================${RC}"
        printf "%b\n" "${YELLOW}DaVinci Resolve requires manual licensing terms and direct download.${RC}"
        printf "%b\n" "${YELLOW}1. Download the Linux version from ://blackmagicdesign.com{RC}"
        printf "%b\n" "${YELLOW}2. Unzip and run the installer script via terminal using:${RC}"
        printf "%b\n" "${YELLOW}   sudo SKIP_PACKAGE_CHECK=1 ./DaVinci_Resolve_<version>_Linux.run${RC}"
        printf "%b\n" "${YELLOW}3. Rerun this script to safely apply necessary compatibility fixes.${RC}"
        printf "%b\n" "${YELLOW}======================================================================${RC}"
    else
        printf "%b\n" "${GREEN}DaVinci Resolve application files detected in /opt/resolve.${RC}"
    fi
}

configureDavinciResolve() {
    if [ -d "/opt/resolve/libs" ]; then
        printf "%b\n" "${YELLOW}Configuring DaVinci Resolve shared library optimizations...${RC}"
        
        # Target internal incompatible legacy libraries bundled with the application wrapper
        # Moving these forces Resolve to cleanly fall back to system native Fedora libraries.
        sudo mkdir -p /opt/resolve/libs/disabled-libraries
        
        cd /opt/resolve/libs
        for lib in libglib* libgio* libgmodule*; do
            if [ -f "$lib" ] || [ -L "$lib" ]; then
                sudo mv "$lib" disabled-libraries/ 2>/dev/null || true
            fi
        done
        
        printf "%b\n" "${GREEN}DaVinci Resolve compatibility layers optimized successfully.${RC}"
    else
        printf "%b\n" "${YELLOW}Skipping DaVinci patches: /opt/resolve/libs directory not found yet.${RC}"
    fi
}

installGimp
installObsStudio
installAudacity
installDavinciResolve
configureDavinciResolve
