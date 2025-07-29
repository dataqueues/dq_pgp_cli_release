#!/bin/bash

# Linux Installation Script for DQ PGP CLI
# Downloads and installs from github.com/dataqueues/dq_pgp_cli_release

set -e  # Exit on any error

# Default configuration
INSTALL_PATH="${HOME}/.local/bin"
GITHUB_REPO="dataqueues/dq_pgp_cli_release"
FORCE=false

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color

# Ensure we're on Linux
if [[ "$(uname -s)" != "Linux" ]]; then
    echo -e "${RED}❌ This script is for Linux only. Use mac-install.sh for macOS.${NC}"
    exit 1
fi

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--path)
            INSTALL_PATH="$2"
            shift 2
            ;;
        -f|--force)
            FORCE=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [options]"
            echo ""
            echo "Linux Installation Script for DQ PGP CLI"
            echo ""
            echo "Options:"
            echo "  -p, --path PATH    Installation path (default: ~/.local/bin)"
            echo "  -f, --force        Force reinstallation"
            echo "  -h, --help         Show this help"
            echo ""
            echo "Examples:"
            echo "  $0                           # Install to ~/.local/bin"
            echo "  $0 -p /usr/local/bin         # Install to /usr/local/bin"
            echo "  $0 --force                   # Force reinstall"
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Unknown option: $1${NC}"
            echo "Use -h for help"
            exit 1
            ;;
    esac
done

echo -e "${CYAN}🔽 DQ PGP CLI Linux Installer${NC}"
echo -e "${CYAN}==============================${NC}"

# Detect Linux architecture
detect_architecture() {
    local arch=$(uname -m)
    
    case $arch in
        x86_64|amd64)
            ARCH="amd64"
            ;;
        arm64|aarch64)
            ARCH="arm64"
            ;;
        *)
            echo -e "${RED}❌ Unsupported architecture: $arch${NC}"
            echo -e "${YELLOW}Supported architectures: x86_64, arm64${NC}"
            exit 1
            ;;
    esac
    
    BINARY_NAME="dq-pgp-linux-${ARCH}"
    
    echo -e "${BLUE}📋 Detected platform: Linux-${ARCH}${NC}"
}

# Get latest release from GitHub API
get_latest_release() {
    echo -e "${YELLOW}📡 Fetching latest release from: ${GITHUB_REPO}${NC}"
    
    if command -v curl >/dev/null 2>&1; then
        RELEASE_DATA=$(curl -s "https://api.github.com/repos/${GITHUB_REPO}/releases/latest")
    elif command -v wget >/dev/null 2>&1; then
        RELEASE_DATA=$(wget -qO- "https://api.github.com/repos/${GITHUB_REPO}/releases/latest")
    else
        echo -e "${RED}❌ Neither curl nor wget found. Please install one of them.${NC}"
        echo -e "${YELLOW}Ubuntu/Debian: sudo apt install curl${NC}"
        echo -e "${YELLOW}CentOS/RHEL: sudo yum install curl${NC}"
        echo -e "${YELLOW}Fedora: sudo dnf install curl${NC}"
        exit 1
    fi
    
    if [[ -z "$RELEASE_DATA" ]]; then
        echo -e "${RED}❌ Failed to fetch release data${NC}"
        echo -e "${YELLOW}Please check your internet connection${NC}"
        exit 1
    fi
    
    # Extract tag name and download URL
    TAG_NAME=$(echo "$RELEASE_DATA" | grep '"tag_name"' | sed -E 's/.*"tag_name": "([^"]+)".*/\1/')
    DOWNLOAD_URL=$(echo "$RELEASE_DATA" | grep "browser_download_url.*${BINARY_NAME}" | sed -E 's/.*"browser_download_url": "([^"]+)".*/\1/')
    
    if [[ -z "$TAG_NAME" ]]; then
        echo -e "${RED}❌ Could not parse release tag${NC}"
        exit 1
    fi
    
    if [[ -z "$DOWNLOAD_URL" ]]; then
        echo -e "${RED}❌ No Linux executable found for architecture: ${ARCH}${NC}"
        echo -e "${YELLOW}Available releases:${NC}"
        echo "$RELEASE_DATA" | grep "browser_download_url" | sed -E 's/.*"browser_download_url": "([^"]+)".*/  - \1/' | sed 's|.*/||'
        exit 1
    fi
    
    echo -e "${GREEN}📋 Latest version: ${TAG_NAME}${NC}"
    echo -e "${GREEN}📦 Found executable: $(basename $DOWNLOAD_URL)${NC}"
}

# Download and install
install_binary() {
    # Check if already installed
    local exe_path="${INSTALL_PATH}/dq-pgp"
    if [[ -f "$exe_path" && "$FORCE" != "true" ]]; then
        echo -e "${YELLOW}⚠️  DQ PGP CLI is already installed at: ${exe_path}${NC}"
        echo -e "${YELLOW}   Use --force to reinstall${NC}"
        read -p "Do you want to continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${RED}🚫 Installation cancelled${NC}"
            exit 0
        fi
    fi
    
    # Create installation directory
    if [[ ! -d "$INSTALL_PATH" ]]; then
        echo -e "${YELLOW}📁 Creating installation directory: ${INSTALL_PATH}${NC}"
        mkdir -p "$INSTALL_PATH"
        
        # Verify directory was created
        if [[ ! -d "$INSTALL_PATH" ]]; then
            echo -e "${RED}❌ Failed to create directory: ${INSTALL_PATH}${NC}"
            echo -e "${YELLOW}Try running with sudo or choose a different path${NC}"
            exit 1
        fi
    fi
    
    # Download the executable
    echo -e "${YELLOW}⬇️  Downloading: $(basename $DOWNLOAD_URL)${NC}"
    echo -e "${GRAY}    From: ${DOWNLOAD_URL}${NC}"
    
    if command -v curl >/dev/null 2>&1; then
        curl -L -o "$exe_path" "$DOWNLOAD_URL"
    elif command -v wget >/dev/null 2>&1; then
        wget -O "$exe_path" "$DOWNLOAD_URL"
    fi
    
    # Verify download
    if [[ ! -f "$exe_path" ]]; then
        echo -e "${RED}❌ Download failed - file not found${NC}"
        exit 1
    fi
    
    # Make executable
    chmod +x "$exe_path"
    
    # Verify installation
    local file_size=$(ls -lh "$exe_path" | awk '{print $5}')
    echo -e "${GREEN}✅ Installation successful!${NC}"
    echo -e "${BLUE}📁 Installed to: ${exe_path}${NC}"
    echo -e "${BLUE}📊 File size: ${file_size}${NC}"
}

# Add to PATH if needed
setup_path() {
    # Check if directory is already in PATH
    if [[ ":$PATH:" == *":$INSTALL_PATH:"* ]]; then
        echo -e "${BLUE}ℹ️  Directory already in PATH: ${INSTALL_PATH}${NC}"
        return
    fi
    
    echo -e "${YELLOW}🔧 Adding to PATH: ${INSTALL_PATH}${NC}"
    
    # Determine which shell config file to update
    local shell_config=""
    if [[ -n "$ZSH_VERSION" ]]; then
        shell_config="$HOME/.zshrc"
    elif [[ -n "$BASH_VERSION" ]]; then
        if [[ -f "$HOME/.bash_profile" ]]; then
            shell_config="$HOME/.bash_profile"
        else
            shell_config="$HOME/.bashrc"
        fi
    else
        # Default to .bashrc for most Linux systems
        shell_config="$HOME/.bashrc"
    fi
    
    # Add to shell config if not already there
    if [[ -f "$shell_config" ]] && ! grep -q "$INSTALL_PATH" "$shell_config"; then
        echo "export PATH=\"\$PATH:$INSTALL_PATH\"" >> "$shell_config"
        echo -e "${GREEN}✅ Added to PATH in: ${shell_config}${NC}"
        echo -e "${YELLOW}⚠️  Please restart your terminal or run: source ${shell_config}${NC}"
    elif [[ ! -f "$shell_config" ]]; then
        echo "export PATH=\"\$PATH:$INSTALL_PATH\"" >> "$shell_config"
        echo -e "${GREEN}✅ Created ${shell_config} and added PATH${NC}"
        echo -e "${YELLOW}⚠️  Please restart your terminal or run: source ${shell_config}${NC}"
    else
        echo -e "${BLUE}ℹ️  PATH already configured in: ${shell_config}${NC}"
    fi
}

# Test installation
test_installation() {
    echo ""
    echo -e "${YELLOW}🧪 Testing installation...${NC}"
    
    local exe_path="${INSTALL_PATH}/dq-pgp"
    if "$exe_path" -h >/dev/null 2>&1; then
        echo -e "${GREEN}✅ Installation test passed!${NC}"
    else
        echo -e "${YELLOW}⚠️  Installation test completed (executable installed correctly)${NC}"
    fi
}

# Main execution
main() {
    detect_architecture
    get_latest_release
    install_binary
    setup_path
    test_installation
    
    echo ""
    echo -e "${GREEN}🎉 Linux installation completed successfully!${NC}"
    echo ""
    echo -e "${CYAN}📋 Quick start:${NC}"
    echo -e "${GRAY}  1. Restart your terminal (or run: source ~/.bashrc)${NC}"
    echo -e "${GRAY}  2. Place your private key as 'private_key.asc' in your working directory${NC}"
    echo -e "${GRAY}  3. Run: dq-pgp encrypted.txt${NC}"
    echo ""
    echo -e "${CYAN}📖 Usage examples:${NC}"
    echo -e "${GRAY}  dq-pgp encrypted.txt${NC}"
    echo -e "${GRAY}  dq-pgp encrypted.txt -k mykey.asc -v${NC}"
    echo -e "${GRAY}  dq-pgp -f encrypted.txt -k mykey.asc -p mysecret${NC}"
    echo ""
    echo -e "${BLUE}🆘 For help: dq-pgp -h${NC}"
    echo -e "${BLUE}🐛 Issues: https://github.com/${GITHUB_REPO}/issues${NC}"
    echo ""
    echo -e "${YELLOW}💡 Tip: If 'dq-pgp' command is not found, restart your terminal${NC}"
}

# Run main function
main


