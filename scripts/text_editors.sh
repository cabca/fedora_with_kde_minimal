#!/bin/sh -e

# -----------------------------------------------------------------------------
# Text Editors (Nano, Neovim)
#
# nano    - Simple and beginner-friendly command-line text editor.
# neovim  - Modern, extensible, and highly configurable Vim-based text editor.
# -----------------------------------------------------------------------------

installTextEditors() {
    # Check if either nano or neovim binaries are missing from the system path
    if ! command -v nano >/dev/null 2>&1 || ! command -v nvim >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Installing Nano and Neovim text editors...${RC}"
        
        sudo dnf install -y \
            nano \
            neovim
            
        printf "%b\n" "${GREEN}Text editor packages successfully installed.${RC}"
    else
        printf "%b\n" "${GREEN}Nano and Neovim are already installed.${RC}"
    fi
}

configureTextEditorServices() {
    printf "%b\n" "${YELLOW}Configuring system-wide default editor environment paths...${RC}"
    
    # Safely prioritize Neovim over Nano if it's available, otherwise fallback to Nano
    if command -v nvim >/dev/null 2>&1; then
        DEFAULT_EDIT="nvim"
    else
        DEFAULT_EDIT="nano"
    fi

    # Append preferred EDITOR variables to user profile fallback shell arrays if missing
    if [ -f "$HOME/.bashrc" ] && ! grep -q "export EDITOR=" "$HOME/.bashrc"; then
        printf "\nexport EDITOR='%s'\nexport VISUAL='%s'\n" "$DEFAULT_EDIT" "$DEFAULT_EDIT" >> "$HOME/.bashrc"
        printf "%b\n" "${GREEN}Set default system editor to $DEFAULT_EDIT inside .bashrc.${RC}"
    else
        printf "%b\n" "${GREEN}Editor environment variables are already configured.${RC}"
    fi
}

installTextEditors
configureTextEditorServices
