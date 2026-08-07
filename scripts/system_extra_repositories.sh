#!/bin/sh -e

# -----------------------------------------------------------------------------
# Extra Repositories (RPM Fusion)
#
# RPM Fusion provides additional software packages that are not included in
# the official Fedora repositories due to licensing, patent, or policy reasons.
#
# It is commonly used to install multimedia codecs, proprietary GPU drivers,
# Steam, and other third-party software.
# -----------------------------------------------------------------------------

installRPMFusion() {
    # Check if both free and nonfree release packages are already configured
    if ! rpm -q rpmfusion-free-release rpmfusion-nonfree-release >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Configuring RPM Fusion Free and Nonfree repositories...${RC}"
        
        sudo dnf install -y \
            https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
            https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
            
        printf "%b\n" "${GREEN}RPM Fusion repositories added successfully.${RC}"
    else
        printf "%b\n" "${GREEN}RPM Fusion repositories are already configured.${RC}"
    fi
}

refreshRepositoryCache() {
    printf "%b\n" "${YELLOW}Refreshing repository metadata and building package cache...${RC}"
    
    if sudo dnf makecache; then
        printf "%b\n" "${GREEN}Package database successfully updated.${RC}"
    else
        printf "%b\n" "${RED}Error: Failed to refresh package metadata cache.${RC}"
        return 1
    fi
}

installRPMFusion
refreshRepositoryCache
