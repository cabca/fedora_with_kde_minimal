#!/bin/sh

# -----------------------------------------------------------------------------
# Main install script
# 
# 
# 
# 
# -----------------------------------------------------------------------------
set -eu

. ../install.sh

installGit() {
    if ! rpm -q git >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Installing Git and core tools...${RC}"
        sudo dnf install -y git git-lfs gh
        git lfs install >/dev/null 2>&1 || true
        printf "%b\n" "${GREEN}Git environment ready.${RC}"
    else
        printf "%b\n" "${GREEN}Git is already installed.${RC}"
    fi
}

installProgrammingLanguages() {
    if ! command -v go >/dev/null 2>&1 || ! command -v python3 >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Installing Go, Python3, and Virtualenv...${RC}"
        sudo dnf install -y golang python3 python3-pip python3-virtualenv cmake gcc make
        printf "%b\n" "${GREEN}Programming runtimes installed successfully.${RC}"
    else
        printf "%b\n" "${GREEN}Go and Python runtimes are already configured.${RC}"
    fi
}

installTerraform() {
    if ! command -v terraform >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Adding HashiCorp repository and installing Terraform...${RC}"
        sudo dnf config-manager addrepo --from-repofile https://hashicorp.com
        sudo dnf install -y terraform
        printf "%b\n" "${GREEN}Terraform installed successfully.${RC}"
    else
        printf "%b\n" "${GREEN}Terraform is already installed.${RC}"
    fi
}

installAnsible() {
    if ! command -v ansible >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Installing Ansible...${RC}"
        sudo dnf install -y ansible
        printf "%b\n" "${GREEN}Ansible installed successfully.${RC}"
    else
        printf "%b\n" "${GREEN}Ansible is already installed.${RC}"
    fi
}

installDockerPackages() {
    if ! command -v docker >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Adding Docker CE repository and extracting packages...${RC}"
        sudo dnf config-manager addrepo --from-repofile https://docker.com
        sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        printf "%b\n" "${GREEN}Docker engines deployed successfully.${RC}"
    else
        printf "%b\n" "${GREEN}Docker CE is already installed.${RC}"
    fi
}

startDockerServices() {
    printf "%b\n" "${YELLOW}Initializing Docker daemon...${RC}"
    if sudo systemctl enable --now docker; then
        printf "%b\n" "${GREEN}Docker daemon running context initialized.${RC}"
    else
        printf "%b\n" "${RED}Error: Failed to activate Docker system unit.${RC}"
        return 1
    fi
}

installPodman() {
    if ! command -v podman >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Installing Podman and Podman-Compose ecosystems...${RC}"
        sudo dnf install -y podman podman-compose
        printf "%b\n" "${GREEN}Podman platform ready.${RC}"
    else
        printf "%b\n" "${GREEN}Podman infrastructure already present.${RC}"
    fi
}

installKubernetesTools() {
    # Check if kubectl binary or Helm is missing
    if [ ! -f "/usr/local/bin/kubectl" ] || ! command -v helm >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Deploying Kubernetes core workspace utilities...${RC}"
        sudo dnf install -y helm
        
        if [ ! -f "/usr/local/bin/kubectl" ]; then
            ARCH=$(uname -m)
            [ "$ARCH" = "x86_64" ] && ARCH="amd64"
            [ "$ARCH" = "aarch64" ] && ARCH="arm64"
            
            KUBE_LATEST=$(curl -L -s https://k8s.io)
            TMP_KUBE=$(mktemp)
            curl -fsSL "https://k8s.io{KUBE_LATEST}/bin/linux/${ARCH}/kubectl" -o "$TMP_KUBE"
            sudo install -o root -g root -m 0755 "$TMP_KUBE" /usr/local/bin/kubectl
            rm -f "$TMP_KUBE"
        fi
        printf "%b\n" "${GREEN}Kubernetes control planes operational.${RC}"
    else
        printf "%b\n" "${GREEN}Kubernetes client platforms already matched.${RC}"
    fi
}

installGitOpsCLIs() {
    if ! command -v argocd >/dev/null 2>&1 || ! command -v flux >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Installing Argo CD and Flux GitOps binary wrappers...${RC}"
        ARCH=$(uname -m)
        [ "$ARCH" = "x86_64" ] && ARCH="amd64"
        [ "$ARCH" = "aarch64" ] && ARCH="arm64"

        # Argo CD CLI Native Setup
        if ! command -v argocd >/dev/null 2>&1; then
            ARGO_LATEST=$(curl -fsSL https://github.com | jq -r .name)
            TMP_ARGO=$(mktemp)
            curl -fsSL "https://github.com{ARGO_LATEST}/argocd-linux-${ARCH}" -o "$TMP_ARGO"
            sudo install -o root -g root -m 0755 "$TMP_ARGO" /usr/local/bin/argocd
            rm -f "$TMP_ARGO"
        fi

        # Flux CD CLI Native Setup
        if ! command -v flux >/dev/null 2>&1; then
            TMP_FLUX=$(mktemp -d)
            curl -fsSL https://fluxcd.io | bash -s -- "$TMP_FLUX" >/dev/null 2>&1
            sudo install -o root -g root -m 0755 "${TMP_FLUX}/flux" /usr/local/bin/flux
            rm -rf "$TMP_FLUX"
        fi
        printf "%b\n" "${GREEN}GitOps CLI layers engineered cleanly.${RC}"
    else
        printf "%b\n" "${GREEN}GitOps engine packages already present.${RC}"
    fi
}

installVsCode() {
    if ! rpm -q code >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Adding Visual Studio Code repository and installing...${RC}"
        sudo rpm --import https://microsoft.com
        cat <<EOF | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
[code]
name=Visual Studio Code
baseurl=https://microsoft.com
enabled=1
gpgcheck=1
gpgkey=https://microsoft.com
EOF
        sudo dnf install -y code
        printf "%b\n" "${GREEN}VS Code environment linked.${RC}"
    else
        printf "%b\n" "${GREEN}VS Code is already installed.${RC}"
    fi
}

installZed() {
    if ! command -v zed >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Installing Zed High-Performance Text Editor...${RC}"
        curl -fsSL https://zed.dev/install.sh | sh >/dev/null 2>&1
        printf "%b\n" "${GREEN}Zed editor configured under user scope profile.${RC}"
    else
        printf "%b\n" "${GREEN}Zed editor environment matched.${RC}"
    fi
}

installJenkinsServer() {
    if ! rpm -q jenkins >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Deploying Jenkins Engine CI Server LTS Repositories...${RC}"
        sudo wget -O /etc/yum.repos.d/jenkins.repo https://jenkins.io
        sudo rpm --import https://jenkins.io
        # Jenkins requires an active local Java runtime environment layout
        sudo dnf install -y java-17-openjdk jenkins
        printf "%b\n" "${GREEN}Jenkins automated delivery packages compiled.${RC}"
    else
        printf "%b\n" "${GREEN}Jenkins packages are already present.${RC}"
    fi
}

startJenkinsServices() {
    if rpm -q jenkins >/dev/null 2>&1; then
        printf "%b\n" "${YELLOW}Initializing Jenkins Service loops...${RC}"
        if sudo systemctl enable --now jenkins; then
            printf "%b\n" "${GREEN}Jenkins CI automation interface online at port 8080.${RC}"
        else
            printf "%b\n" "${RED}Error: Failed to register Jenkins background systems.${RC}"
            return 1
        fi
    fi
}

installCoreUtilities() {
    printf "%b\n" "${YELLOW}Refreshing base workspace developer utilities...${RC}"
    sudo dnf install -y \
        jq yq ripgrep fd-find tree htop btop tmux \
        wget curl unzip zip tar rsync shellcheck
    printf "%b\n" "${GREEN}Base command-line utility configurations updated.${RC}"
}


installCoreUtilities
installGit
installProgrammingLanguages
installTerraform
installAnsible
installDockerPackages
startDockerServices
installPodman
installKubernetesTools
installGitOpsCLIs
installVsCode
installZed
installJenkinsServer
startJenkinsServices

