#!/bin/bash

set -euo pipefail

# Rundsand Universal Installer
# Supports: Linux x86_64, ARM64, ARMv7

# Configuration
BINARY_NAME="rundsand"
GITHUB_REPO="Soar-Development/rundsand-installer"
INSTALL_DIR="/usr/local/bin"
CONFIG_DIR="$HOME/.config/rundsand"
TEMP_DIR=$(mktemp -d)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Cleanup function
cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

# Detect architecture
detect_arch() {
    local arch
    arch=$(uname -m)
    
    case $arch in
        x86_64)
            echo "amd64"
            ;;
        aarch64|arm64)
            echo "arm64"
            ;;
        armv7l)
            echo "armv7"
            ;;
        armv6l)
            log_error "ARMv6 is not supported (Raspberry Pi Zero, Pi 1)"
            log_error "Minimum supported: ARMv7 (Raspberry Pi 3+)"
            exit 1
            ;;
        *)
            log_error "Unsupported architecture: $arch"
            log_error "Supported: x86_64, aarch64, armv7l"
            exit 1
            ;;
    esac
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    else
        log_error "Unsupported operating system: $OSTYPE"
        log_error "This installer only supports Linux"
        exit 1
    fi
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check system requirements
check_requirements() {
    log_info "Checking system requirements..."
    
    # Check for required commands
    if ! command_exists curl && ! command_exists wget; then
        log_error "Either curl or wget is required"
        exit 1
    fi
    
    if ! command_exists docker; then
        log_warning "Docker not found. Docker is required for Rundsand to function."
        log_info "Install Docker: https://docs.docker.com/get-docker/"
        log_info "You can continue installation and install Docker later."
    else
        log_success "Docker is available"
        
        # Check if Docker daemon is running
        if docker info >/dev/null 2>&1; then
            log_success "Docker daemon is running"
        else
            log_warning "Docker daemon is not running or not accessible"
            log_info "Try: sudo systemctl start docker"
            log_info "Or add user to docker group: sudo usermod -aG docker $USER"
        fi
    fi
}

# Get latest release version
get_latest_version() {
    local api_url="https://api.github.com/repos/$GITHUB_REPO/releases/latest"
    
    if command_exists curl; then
        curl -s "$api_url" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'
    elif command_exists wget; then
        wget -qO- "$api_url" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'
    else
        log_error "Unable to fetch latest version"
        exit 1
    fi
}

# Download file
download_file() {
    local url="$1"
    local output="$2"
    
    log_info "Downloading: $(basename "$url")"
    
    if command_exists curl; then
        curl -fsSL -o "$output" "$url"
    elif command_exists wget; then
        wget -q -O "$output" "$url"
    else
        log_error "Unable to download file"
        exit 1
    fi
}

# Install binary
install_binary() {
    local arch="$1"
    local os="$2"
    local version="$3"
    
    local binary_name="${BINARY_NAME}-${os}-${arch}"
    local download_url="https://github.com/${GITHUB_REPO}/releases/download/${version}/${binary_name}"
    local temp_binary="$TEMP_DIR/$binary_name"

    log_info "Installing Rundsand for ${os}-${arch}..."
    log_info "Version: $version"
    
    # Download binary
    download_file "$download_url" "$temp_binary"
    
    # Verify download
    if [[ ! -f "$temp_binary" ]]; then
        log_error "Download failed"
        exit 1
    fi
    
    # Make executable
    chmod +x "$temp_binary"
    
    # Install to system
    if [[ -w "$INSTALL_DIR" ]]; then
        mv "$temp_binary" "$INSTALL_DIR/$BINARY_NAME"
    else
        log_info "Installing to $INSTALL_DIR (requires sudo)"
        sudo mv "$temp_binary" "$INSTALL_DIR/$BINARY_NAME"
    fi
    
    # Verify installation
    if command_exists "$BINARY_NAME"; then
        local installed_version
        installed_version=$("$BINARY_NAME" --version 2>/dev/null | grep -o 'v[0-9]\+\.[0-9]\+\.[0-9]\+' || echo "unknown")
        log_success "Installed Rundsand $installed_version to $INSTALL_DIR/$BINARY_NAME"
    else
        log_error "Installation verification failed"
        exit 1
    fi
}

# Create user directories
create_directories() {
    log_info "Creating user directories..."
    
    mkdir -p "$CONFIG_DIR"
    mkdir -p "$CONFIG_DIR/wallets"
    
    log_success "Created user directories in $CONFIG_DIR"
}

# Show next steps
show_next_steps() {
    log_success "Installation complete! 🚀"
    echo
    echo "🎉 Rundsand is now installed!"
    echo
    echo "Next steps:"
    echo "1. Run 'sudo rundsand --help' to see available commands"
    echo "2. Run 'sudo rundsand' to start the interactive mode"
    echo "3. Import your Solana wallet when prompted"
    echo
    echo "For help: https://github.com/$GITHUB_REPO"
    echo
}

# Main installation function
main() {
    echo "Rundsand Universal Installer"
    echo "============================"
    echo
    
    # Detect system
    local arch os version
    arch=$(detect_arch)
    os=$(detect_os)
    
    log_info "Detected system: ${os}-${arch}"
    
    # Check requirements
    check_requirements
    
    # Get latest version
    log_info "Fetching latest version..."
    version=$(get_latest_version)
    
    if [[ -z "$version" ]]; then
        log_error "Could not determine latest version"
        exit 1
    fi
    
    log_info "Latest version: $version"
    
    # Install binary
    install_binary "$arch" "$os" "$version"
    
    # Create directories
    create_directories
    
    # Show next steps
    show_next_steps
}

# Check if running with supported shell
if [[ -z "${BASH_VERSION:-}" ]]; then
    log_error "This installer requires bash"
    exit 1
fi

# Run main function
main "$@"