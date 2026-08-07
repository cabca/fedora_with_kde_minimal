#!/bin/sh -e

# -----------------------------------------------------------------------------
# Document Tools
#
# libreoffice - Free and open-source office productivity suite including Writer, Calc, Impress, Draw, Base, and Math.
# okular      - Document viewer for PDF, EPUB, DjVu, Markdown, comics, images, and many other document formats.
# -----------------------------------------------------------------------------

installLibreOfficePackages() {
    # Check if the core libreoffice package suite is already present via system rpm
    if ! rpm -q libreoffice-core >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Installing LibreOffice productivity suite...${RC}"
        
        sudo dnf install -y \
            libreoffice
            
        printf "%b\n" "${GREEN}LibreOffice suite successfully installed.${RC}"
    else
        printf "%b\n" "${GREEN}LibreOffice suite is already installed.${RC}"
    fi
}

configureLibreOfficeServices() {
    # Optional performance tuning: Pre-warm the icon cache framework if using GTK/KDE environments
    if command -v gtk-update-icon-cache >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Updating desktop icon caches for application shortcuts...${RC}"
        sudo gtk-update-icon-cache /usr/share/icons/hicolor >/dev/null 2>&1 || true
        printf "%b\n" "${GREEN}Desktop visual configuration complete.${RC}"
    else
        printf "%b\n" "${YELLOW}Skipping application shortcuts tune: icon update utility not present.${RC}"
    fi
}

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

installLibreOfficePackages
configureLibreOfficeServices
installOkularPackages
configureOkularServices
