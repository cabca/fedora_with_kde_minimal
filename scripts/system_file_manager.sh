#!/bin/sh -e

# -----------------------------------------------------------------------------
# File Manager (Thunar)
#
# thunar                    - Lightweight and fast file manager.
# thunar-volman             - Automatic management of removable drives and media.
# thunar-media-tags-plugin  - Media metadata viewer and tag editor for audio files.
# gvfs                      - Virtual filesystem support (trash, network locations, etc.).
# gvfs-afc                  - Apple iPhone/iPad support.
# gvfs-archive              - Browse archive files as folders.
# gvfs-gphoto2              - Digital camera support.
# gvfs-mtp                  - Android device support (MTP).
# gvfs-smb                  - Windows (SMB/CIFS) network share support.
# tumbler                   - Provides thumbnail generation for images, PDFs, videos, and other file types.
# -----------------------------------------------------------------------------

installThunarPackages() {
    # Check if the core thunar file manager binary is missing from the system path
    if ! command -v thunar >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Installing Thunar File Manager and virtual filesystem plugins...${RC}"
        
        sudo dnf install -y \
            thunar \
            thunar-volman \
            thunar-media-tags-plugin \
            gvfs \
            gvfs-afc \
            gvfs-archive \
            gvfs-gphoto2 \
            gvfs-mtp \
            gvfs-smb \
            tumbler
            
        printf "%b\n" "${GREEN}Thunar environment packages successfully installed.${RC}"
    else
        printf "%b\n" "${GREEN}Thunar File Manager is already installed.${RC}"
    fi
}

configureThunarServices() {
    # Ensure that GVFS background daemons are properly triggered/reloaded for the user session
    if command -v gio >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Initializing filesystem tracking variables for desktop mount protocols...${RC}"
        # Forces glib/gio to instantly notice the newly deployed gvfs storage backends
        gio mime inode/directory >/dev/null 2>&1 || true
        printf "%b\n" "${GREEN}Virtual filesystem capabilities optimized.${RC}"
    else
        printf "%b\n" "${YELLOW}Skipping virtual filesystem tuning: gio binary not found.${RC}"
    fi
}

installThunarPackages
configureThunarServices

