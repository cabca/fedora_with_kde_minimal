#!/bin/sh -e

# -----------------------------------------------------------------------------
# Web Browser (Brave Origin)
#
# Brave Origin - A minimalist edition of Brave Browser that removes optional
# features such as AI, Brave Rewards, Wallet, VPN, and other extras.
#
# This installs Brave Origin using Brave's official installation script.
# -----------------------------------------------------------------------------

installBraveOrigin() {
	if ! command -v brave-origin >/dev/null 2>&1 && command -v com.brave.Browser >/dev/null 2>&1; then
		printf "%b\n" "${YELLOW}Installing Brave Origin...${RC}"
		curl -fsS https://dl.brave.com/install.sh | FLAVOR=origin sh

	else
        	printf "%b\n" "${GREEN}Brave Origin is already installed.${RC}"
    	fi
}

installBraveOrigin
