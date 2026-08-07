#!/bin/sh -e

# -----------------------------------------------------------------------------
# Document Viewer (Okular)
#
# okular - Document viewer for PDF, EPUB, DjVu, Markdown, comics, images,
#          and many other document formats.
# -----------------------------------------------------------------------------

installOkularPackages() {
    # Check if okular is installed using system rpm database queries
    if ! rpm -q okular >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Installing Okular document viewer...${RC}"
        
        sudo dnf install -y \
            okular
            
        printf "%b\n" "${GREEN}Okular packages successfully installed.${RC}"
    else
        printf "%b\n" "${GREEN}Okular is already installed.${RC}"
    fi
}

configureOkularServices() {
    # Refresh the desktop database to ensure system file associations map correctly
    if command -v update-desktop-database >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Updating system MIME handler registries for document types...${RC}"
        sudo update-desktop-database /usr/share/applications >/dev/null 2>&1 || true
        printf "%b\n" "${GREEN}MIME handler configuration complete.${RC}"
    else
        printf "%b\n" "${YELLOW}Skipping registry update: update-desktop-database not present.${RC}"
    fi
}

installOkularPackages
configureOkularServices

