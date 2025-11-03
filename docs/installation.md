# Runsand Installation Guide

This guide covers all installation methods for the Runsand Desktop Client on Linux systems.

## Table of Contents

- [Quick Start](#quick-start)
- [Prerequisites](#prerequisites)
  - [Wallet Creation Methods](#wallet-creation-methods)
- [System Requirements](#system-requirements)
- [Installation Methods](#installation-methods)
  - [1. Universal Installer (Recommended)](#1-universal-installer-recommended)
  - [2. Debian/Ubuntu Package Installation](#2-debianubuntu-package-installation)
  - [3. Manual Installation](#3-manual-installation)
- [First Run Setup](#first-run-setup)
  - [Step 1: System Requirements Check](#step-1-system-requirements-check)
  - [Step 2: Wallet Import](#step-2-wallet-import)
  - [Step 3: Connection Test](#step-3-connection-test)
- [Running Runsand in the Background with `screen` or `tmux`](#running-runsand-in-the-background-with-screen-or-tmux)
  - [Option 1: Using `screen`](#option-1-using-screen)
  - [Option 2: Using `tmux`](#option-2-using-tmux)
- [Configuration](#configuration)
- [Viewing System Status](#viewing-system-status)
- [Troubleshooting](#troubleshooting)
  - [Docker Issues](#docker-issues)
  - [Download Issues](#download-issues)
  - [Architecture Detection Issues](#architecture-detection-issues)
- [Updating](#updating)
  - [Automatic Updates](#automatic-updates)
  - [Manual Update](#manual-update)
- [Uninstallation](#uninstallation)
  - [Manual Removal](#manual-removal)
- [Support](#support)
- [Security](#security)

## Quick Start

For most users, the universal installer is the fastest way to get started:

```bash
curl -sSL https://raw.githubusercontent.com/Soar-Development/runsand-installer/main/install.sh | sudo bash
```

## Prerequisites

> **⚠️ IMPORTANT**: Runsand Node is still in development phase!

**You will need either an Ethereum or Solana wallet** to authenticate with Runsand. The client supports flexible mnemonic phrase lengths:
- ✅ 12 words (most common)
- ✅ 15 words
- ✅ 18 words
- ✅ 21 words
- ✅ 24 words (maximum entropy)

### Wallet Creation Methods

#### Option 1: Ethereum Wallet (Recommended)

**Using MetaMask or any standard Ethereum wallet:**
1. Create a new wallet in MetaMask, Trust Wallet, or any BIP39-compatible Ethereum wallet
2. Most wallets generate a 12-word mnemonic phrase by default
3. **🚨 CRITICAL**: Write down your mnemonic phrase securely
4. The wallet will use the standard BIP44 derivation path: `m/44'/60'/0'/0/0`

**Example Ethereum address format:** `0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb`

#### Option 2: Solana Wallet

**Using Solana CLI:**
1. Install Solana CLI: https://solana.com/docs/intro/installation
2. Generate a new keypair:
   ```bash
   # For 12-word mnemonic (recommended)
   solana-keygen new --word-count 12 --derivation-path "m/44'/501'/0'/0'" --outfile ~/my-keypair.json

   # For 24-word mnemonic (maximum security)
   solana-keygen new --word-count 24 --derivation-path "m/44'/501'/0'/0'" --outfile ~/my-keypair.json
   ```
3. **🚨 CRITICAL**: Write down the mnemonic phrase securely
4. The wallet uses the derivation path: `m/44'/501'/0'/0'`

**Example Solana address format:** `7xKXtg2CW87d97TXJSDpbD5jBkheTqA83TZRuJosgAsU`

---

## System Requirements

### Minimum Requirements
- **Operating System**: Linux (any modern distribution)
- **Architecture**: x86_64, ARM64, or ARMv7
- **RAM**: 512MB available
- **Disk Space**: 100MB for client + 4.5GB for desktop image
- **Sudo Access**: Required for installation, system setup, and running Runsand
- **Network**: Internet connection for initial setup and updates

### Required Software
- **Docker**: 20.10 or later (install from [docs.docker.com](https://docs.docker.com/engine/install/))
- **Ethereum or Solana Wallet**: New wallet created following the prerequisites above (supports 12/15/18/21/24-word mnemonics)
- **Sudo Access**: Required for installation and running Runsand

### Installing Docker
#### Install Dependencies
```bash
# If Docker is not installed
# Install Docker following the official Docker documentation:
# https://docs.docker.com/engine/install/

# Or use Docker's official installer
curl -fsSL https://get.docker.com | sudo sh

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

# Add user to docker group
sudo usermod -aG docker $USER
# Log out and back in for group changes to take effect
```


### Supported Platforms

| Platform | Architecture | Binary Name | Package |
|----------|-------------|-------------|---------|
| Linux x86_64 | AMD64 | `runsand-linux-amd64` | `runsand_*_amd64.deb` |
| Linux ARM64 | ARM64 | `runsand-linux-arm64` | `runsand_*_arm64.deb` |
| Linux ARMv7 | ARM32v7 | `runsand-linux-armv7` | `runsand_*_armhf.deb` |

## Installation Methods

### 1. Universal Installer (Recommended)

The universal installer automatically detects your system and installs the appropriate version.

#### Features
- ✅ Automatic architecture detection
- ✅ System requirements checking
- ✅ Docker dependency verification
- ✅ User directory setup
- ✅ Works on any Linux distribution

#### Installation
```bash
curl -sSL https://raw.githubusercontent.com/Soar-Development/runsand-installer/main/install.sh | sudo bash
```

#### What it does
1. Detects your system architecture
2. Checks system requirements (Docker, etc.)
3. Downloads the latest binary for your system
4. Installs to `/usr/local/bin/runsand`
5. Creates user configuration directories
6. Verifies the installation

#### Example Output
```
Runsand Universal Installer
=========================

[INFO] Detected system: linux-amd64
[INFO] Checking system requirements...
[SUCCESS] Docker is available and running
[INFO] Fetching latest version...
[INFO] Latest version: v1.0.0
[INFO] Installing Runsand for linux-amd64...
[INFO] Version: v1.0.0
[INFO] Downloading: runsand-linux-amd64
[SUCCESS] Installed Runsand v1.0.0 to /usr/local/bin/runsand
[INFO] Creating user directories...
[SUCCESS] Created user directories in /home/user/.config/runsand
[SUCCESS] Installation complete! 🚀

🎉 Runsand is now installed!

Next steps:
1. Run 'sudo runsand --help' to see available commands
2. Run 'sudo runsand' to start the interactive mode
3. Import your Ethereum or Solana wallet when prompted (12/15/18/21/24-word mnemonic supported)
```

### 2. Debian/Ubuntu Package Installation

For Debian-based distributions, you can install using .deb packages.

#### Download and Install
```bash
# Get latest version info
LATEST_VERSION=$(curl -s https://api.github.com/repos/Soar-Development/runsand-installer/releases/latest | grep -o '"tag_name": "[^"]*' | cut -d'"' -f4)
# Remove 'v' prefix for package naming
VERSION=${LATEST_VERSION#v}

# AMD64 (Intel/AMD 64-bit)
wget "https://github.com/Soar-Development/runsand-installer/releases/download/${LATEST_VERSION}/runsand_${VERSION}_amd64.deb"
sudo dpkg -i "runsand_${VERSION}_amd64.deb"

# ARM64 (64-bit ARM)
wget "https://github.com/Soar-Development/runsand-installer/releases/download/${LATEST_VERSION}/runsand_${VERSION}_arm64.deb"
sudo dpkg -i "runsand_${VERSION}_arm64.deb"

# ARMv7 (32-bit ARM)
wget "https://github.com/Soar-Development/runsand-installer/releases/download/${LATEST_VERSION}/runsand_${VERSION}_armhf.deb"
sudo dpkg -i "runsand_${VERSION}_armhf.deb"
```

#### Install Dependencies
If Docker is not installed, follow the steps in the **Prerequisites** section.

#### Package Features
- ✅ Automatic dependency management
- ✅ System integration
- ✅ Clean uninstallation
- ✅ Post-installation setup

### 3. Manual Installation

For advanced users or custom setups.

#### Download Binary
```bash
# Get latest version info
LATEST_VERSION=$(curl -s https://api.github.com/repos/Soar-Development/runsand-installer/releases/latest | grep -o '"tag_name": "[^"]*' | cut -d'"' -f4)

# Download for your architecture
# AMD64
wget "https://github.com/Soar-Development/runsand-installer/releases/download/${LATEST_VERSION}/runsand-linux-amd64"

# ARM64
wget "https://github.com/Soar-Development/runsand-installer/releases/download/${LATEST_VERSION}/runsand-linux-arm64"

# ARMv7
wget "https://github.com/Soar-Development/runsand-installer/releases/download/${LATEST_VERSION}/runsand-linux-armv7"

# ARMv6
wget "https://github.com/Soar-Development/runsand-installer/releases/download/${LATEST_VERSION}/runsand-linux-armv6"
```

#### Install Binary
```bash
# Make executable
chmod +x runsand-linux-*

# Install to system (choose your architecture)
sudo mv runsand-linux-amd64 /usr/local/bin/runsand

# Or install to user directory (Note: Runsand requires sudo to run)
mkdir -p ~/bin
mv runsand-linux-amd64 ~/bin/runsand
export PATH="$HOME/bin:$PATH"
```

#### Create User Directories
```bash
mkdir -p ~/.config/runsand/wallets
```

#### Verify Installation
```bash
sudo runsand --version
```

## First Run Setup

After installation, run Runsand for the first time:

```bash
sudo runsand
```

The setup wizard will guide you through:

### Step 1: System Requirements Check
- ✅ Docker installation verification
- ✅ Docker daemon status check
- 🔄 Desktop image download (if needed)

> **📥 Desktop Image Download Note**: The initial download progress from 0% to ~6% will appear slow as the base layers are larger compared to the remaining ones. After the first few layers complete, the progression speed will significantly increase. This is normal behavior - please be patient and allow sufficient time before considering a retry.

### Step 2: Wallet Import
- Import your Ethereum or Solana wallet (see Prerequisites section)
- Supports 12, 15, 18, 21, or 24-word mnemonic phrases
- Wallet stored encrypted locally
- **Ethereum wallets** use BIP44 path: `m/44'/60'/0'/0/0` (compatible with MetaMask, Trust Wallet)
- **Solana wallets** use path: `m/44'/501'/0'/0'`

### Step 3: Connection Test
- Test connection to orchestrator
- Verify wallet authentication
- Confirm service availability


## Running Runsand in the Background with `screen` or `tmux`

Runsand needs to remain running for continuous operation. If you don’t want to keep a terminal window open, you can run it inside a persistent session using `screen` or `tmux`.

### Option 1: Using `screen`
1. **Install screen** (if not already installed):
   ```bash
   sudo apt install screen   # Debian/Ubuntu
   sudo yum install screen   # CentOS/RHEL
   ```
2. **Create a named session**:
   ```bash
   screen -S runsand
   ```
3. **Run Runsand inside the session**:
   ```bash
   sudo runsand
   ```
4. **Detach from the session** (leave Runsand running in background):
   - Press `Ctrl + A`, then `Ctrl + D`
5. **Reattach later**:
   ```bash
   screen -r runsand
   ```
6. **List running sessions**:
   ```bash
   screen -ls
   ```

---

### Option 2: Using `tmux`
1. **Install tmux** (if not already installed):
   ```bash
   sudo apt install tmux   # Debian/Ubuntu
   sudo yum install tmux   # CentOS/RHEL
   ```
2. **Create a named session**:
   ```bash
   tmux new -s runsand
   ```
3. **Run Runsand inside the session**:
   ```bash
   sudo runsand
   ```
4. **Detach from the session**:
   - Press `Ctrl + B`, then `D`
5. **Reattach later**:
   ```bash
   tmux attach -t runsand
   ```
6. **List running sessions**:
   ```bash
   tmux ls
   ```

> **Tip:** This is useful for running Runsand on remote servers or cloud instances where you want it to continue running after disconnecting from SSH.


## Configuration

After setup, your configuration will be stored at:

```
~/.config/runsand/
├── config.json          # Main configuration
└── wallets/              # Encrypted wallet data
```

## Configuration File
```json
{
  "orchestrator_address": "orchestrator2.teamsofagents.ai:50051",
  "max_containers": 10,
  "wallet_address": "your-wallet-address",
  "auto_update_enabled": true,
  "setup_completed": true
}
```

## Viewing System Status

To monitor your connection status and system information:

1. **Start the CLI**: Run `sudo runsand` to open the interactive menu
2. **Navigate**: Use **W/S keys** or **arrow keys** to move between menu options
3. **Select View Status**: Highlight "View Status" option 
4. **Press Enter**: View the detailed status screen

> **💡 Navigation Tip**: If arrow keys don't work in your terminal environment, use **W** (up) and **S** (down) keys instead. Both navigation methods are supported.

The status screen displays:
```
=== System Status ===

Connection Status: CONNECTED
Session Duration: 6s
Docker Status: CONNECTED
gRPC Status: CONNECTED
Wallet Status: CONNECTED
Wallet Address: ******
Wallet Connected At: 2025-08-08 10:16:16

Max Containers: 10
```

The status screen automatically refreshes every 30 seconds and shows real-time connection information.

## Troubleshooting

### Docker Issues

#### Docker not installed
```bash
# Install Docker following the official Docker documentation:
# https://docs.docker.com/engine/install/

# Or use Docker's official installer (recommended)
curl -fsSL https://get.docker.com | sudo sh
```

#### Docker daemon not running
```bash
# Start Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Check status
sudo systemctl status docker
```

#### Permission denied (Docker)
```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Log out and back in, or restart session
newgrp docker

# Test
docker --version
```

### Download Issues

#### Slow download or timeouts
```bash
# Try different download method
# If curl fails, try wget
wget https://raw.githubusercontent.com/Soar-Development/runsand-installer/main/install.sh
bash install.sh

# Or download binary directly
wget https://github.com/Soar-Development/runsand-installer/releases/latest/download/runsand-linux-amd64
```

#### Checksum verification
```bash
# Download checksums
wget https://github.com/Soar-Development/runsand-installer/releases/latest/download/checksums.txt

# Verify your download
sha256sum -c checksums.txt
```

### Architecture Detection Issues

If the installer doesn't detect your architecture correctly:

```bash
# Check your architecture
uname -m

# Download specific binary manually
# x86_64 → runsand-linux-amd64
# aarch64 → runsand-linux-arm64
# armv7l → runsand-linux-armv7
# armv6l → runsand-linux-armv6
```

## Updating

### Automatic Updates
Runsand checks for updates automatically on startup. If updates are available, you'll see a notification.

### Manual Update
```bash
# Check for updates
sudo runsand update --check

# Update to latest version
sudo runsand update

# Or re-run installer (always safe)
curl -sSL https://raw.githubusercontent.com/Soar-Development/runsand-installer/main/install.sh | sudo bash
```

## Uninstallation

### Manual Removal
```bash
# Remove binary
sudo rm -f /usr/local/bin/runsand

# Remove user data (optional)
rm -rf ~/.config/runsand

# Remove package (if installed via .deb)
sudo dpkg -r runsand
```

## Support

- **Documentation**: [GitHub Repository](https://github.com/Soar-Development/runsand-installer)
- **Issues**: [Report Problems](https://github.com/Soar-Development/runsand-installer/issues)
- **Releases**: [View Releases](https://github.com/Soar-Development/runsand-installer/releases)

## Security

- All downloads use HTTPS
- Checksums provided for verification
- Wallet data encrypted locally
- No private keys transmitted
- TLS for all orchestrator connections
