#!/bin/bash

# Architecture Detection Script for Runsand
# Used by installer to determine correct binary to download

set -euo pipefail

# Detect architecture and return normalized name
detect_arch() {
    local arch
    arch=$(uname -m)
    
    case $arch in
        x86_64|amd64)
            echo "amd64"
            ;;
        aarch64|arm64)
            echo "arm64"
            ;;
        armv7l|armv7*)
            echo "armv7"
            ;;
        armv6l|armv6*)
            echo "ERROR: ARMv6 is not supported (Raspberry Pi Zero, Pi 1)"
            echo "Minimum supported: ARMv7 (Raspberry Pi 3+)"
            exit 1
            ;;
        i386|i686)
            echo "ERROR: 32-bit x86 is not supported"
            exit 1
            ;;
        *)
            echo "ERROR: Unsupported architecture: $arch"
            echo "Supported: x86_64, aarch64, armv7l"
            exit 1
            ;;
    esac
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "ERROR: macOS is not yet supported"
        exit 1
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        echo "ERROR: Windows is not yet supported"
        exit 1
    else
        echo "ERROR: Unsupported operating system: $OSTYPE"
        exit 1
    fi
}

# Get binary name for architecture
get_binary_name() {
    local arch="$1"
    local os="$2"
    echo "runsand-${os}-${arch}"
}

# Get package architecture for Debian packages
get_package_arch() {
    local arch="$1"
    
    case $arch in
        amd64)
            echo "amd64"
            ;;
        arm64)
            echo "arm64"
            ;;
        armv7)
            echo "armhf"
            ;;
        *)
            echo "ERROR: Unknown architecture for packaging: $arch"
            exit 1
            ;;
    esac
}

# Show system information
show_system_info() {
    echo "System Information:"
    echo "  OS: $(uname -s)"
    echo "  Architecture: $(uname -m)"
    echo "  Kernel: $(uname -r)"
    
    if command -v lsb_release >/dev/null 2>&1; then
        echo "  Distribution: $(lsb_release -d -s 2>/dev/null || echo 'Unknown')"
    elif [[ -f /etc/os-release ]]; then
        echo "  Distribution: $(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)"
    fi
    
    echo
}

# Check if architecture is supported
check_support() {
    local arch="$1"
    local supported_archs=("amd64" "arm64" "armv7")
    
    for supported in "${supported_archs[@]}"; do
        if [[ "$arch" == "$supported" ]]; then
            return 0
        fi
    done
    
    return 1
}

# Main function
main() {
    local command="${1:-detect}"
    
    case $command in
        "detect")
            local os arch
            os=$(detect_os)
            arch=$(detect_arch)
            echo "$os-$arch"
            ;;
        "binary")
            local os arch binary_name
            os=$(detect_os)
            arch=$(detect_arch)
            binary_name=$(get_binary_name "$arch" "$os")
            echo "$binary_name"
            ;;
        "package")
            local arch package_arch
            arch=$(detect_arch)
            package_arch=$(get_package_arch "$arch")
            echo "$package_arch"
            ;;
        "info")
            show_system_info
            local os arch
            os=$(detect_os)
            arch=$(detect_arch)
            echo "Detected: $os-$arch"
            echo "Binary: $(get_binary_name "$arch" "$os")"
            echo "Package: $(get_package_arch "$arch")"
            ;;
        "check")
            local arch
            arch=$(detect_arch)
            if check_support "$arch"; then
                echo "✅ Architecture $arch is supported"
                exit 0
            else
                echo "❌ Architecture $arch is not supported"
                exit 1
            fi
            ;;
        "help"|"-h"|"--help")
            cat << EOF
Architecture Detection Script for Runsand

Usage: $0 [command]

Commands:
  detect    Output detected OS-architecture (default)
  binary    Output binary name for this system
  package   Output package architecture name
  info      Show detailed system information
  check     Check if architecture is supported
  help      Show this help message

Examples:
  $0 detect   # Output: linux-amd64
  $0 binary   # Output: runsand-linux-amd64
  $0 package  # Output: amd64
  $0 info     # Show detailed system info
  $0 check    # Check support and exit with status

Supported architectures:
  - x86_64 (amd64)
  - aarch64 (arm64)
  - armv7l (armv7)
EOF
            ;;
        *)
            echo "ERROR: Unknown command: $command"
            echo "Use '$0 help' for usage information"
            exit 1
            ;;
    esac
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi