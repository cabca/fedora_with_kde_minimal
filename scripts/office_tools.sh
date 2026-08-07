#!/bin/sh -e

# -----------------------------------------------------------------------------
# Office Suite (LibreOffice)
#
# libreoffice - Free and open-source office productivity suite including
#               Writer, Calc, Impress, Draw, Base, and Math.
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

installLibreOfficePackages
configureLibreOfficeServices
