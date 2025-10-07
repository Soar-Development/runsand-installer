# Runsand Desktop Client

**Desktop-as-a-Service Client for Linux**

Runsand provides seamless access to cloud-based desktop environments with full SSH access, editing tools, and development capabilities.

## Quick Installation

### Universal Installer (Recommended)

```bash
curl -sSL https://raw.githubusercontent.com/Soar-Development/runsand-installer/main/install.sh | sudo bash
```

### Debian Package

```bash
# Download and install
wget https://github.com/Soar-Development/runsand-installer/releases/latest/download/runsand_latest_amd64.deb
sudo dpkg -i runsand_latest_amd64.deb
```

### Manual Installation

```bash
# Download binary for your architecture
wget https://github.com/Soar-Development/runsand-installer/releases/latest/download/runsand-linux-amd64
chmod +x runsand-linux-amd64
sudo mv runsand-linux-amd64 /usr/local/bin/runsand
```

## Supported Platforms

- **Linux x86_64** (Intel/AMD 64-bit)
- **Linux ARM64** (64-bit ARM, Apple Silicon, AWS Graviton) - *Not tested yet*
- **Linux ARMv7** (32-bit ARM, Raspberry Pi 3/4) - *Not tested yet*

## System Requirements

- **Linux** (any modern distribution)
- **Docker** 20.10 or later
- **Sudo access** (required for installation)
- **Internet connection** (for downloading ~4.5GB desktop image)
- **Solana Wallet** (new wallet required for authentication - see installation guide for wallet creation)

## Prerequisites

### Docker Installation

Install Docker following the official Docker documentation:
**[https://docs.docker.com/engine/install/](https://docs.docker.com/engine/install/)**

After Docker installation, ensure your user can access Docker:
```bash
sudo usermod -aG docker $USER
# Log out and back in for group changes to take effect
```

## Features

- 🚀 **One-command setup** - Get started in under 5 minutes
- 🔐 **Solana wallet authentication** - Secure blockchain-based access
- 🐳 **Docker-based environments** - Consistent, isolated desktop sessions
- 🔄 **Automatic updates** - Stay current with latest features
- 📦 **Multiple install methods** - Universal installer, packages, or manual
- 🛠️ **Full development environment** - SSH access, editing tools, development stack

## Getting Started

After installation, run:

```bash
sudo runsand
```

The first-run setup wizard will guide you through:

1. **System Requirements Check** - Verify Docker and dependencies
2. **Desktop Image Download** - Downloads the 4.5GB desktop environment (~5-10 minutes)
3. **Wallet Import** - Connect your newly created Solana wallet (see installation guide for wallet creation)  
4. **Connection Test** - Verify orchestrator connectivity

## Viewing Status

To check your connection status:
1. Run `sudo runsand` to open the interactive menu
2. Navigate to **"View Status"** using W/S keys or arrow keys
3. Press **Enter** to see detailed connection information

> **💡 Navigation Tip**: If arrow keys don't work on your terminal, use **W** (up) and **S** (down) keys instead.

### Image Download Process

The desktop environment image is approximately **4.5GB**. During the first setup:
- Download starts slowly (~6% completion) as the base layer is large
- Progress accelerates significantly after the initial layers
- Total download time: 5-10 minutes depending on connection speed

## Update

```bash
# Check for updates
sudo runsand update --check

# Update to latest version
sudo runsand update

# Or re-run the installer
curl -sSL https://raw.githubusercontent.com/Soar-Development/runsand-installer/main/install.sh | sudo bash
```

## Manual Removal

If you need to remove Runsand:

```bash
# Remove binary
sudo rm -f /usr/local/bin/runsand

# Remove configuration (optional)
rm -rf ~/.config/runsand
```

## Architecture Detection

The installer automatically detects your system architecture:

```bash
# Detected architectures:
# x86_64    → runsand-linux-amd64
# aarch64   → runsand-linux-arm64  
# armv7l    → runsand-linux-armv7
```

## Configuration

Default configuration location: `~/.config/runsand/config.json`

```json
{
  "orchestrator_address": "orchestrator2.teamsofagents.ai:50051",
  "max_containers": 10,
  "wallet_address": "your-wallet-address",
  "auto_update_enabled": true,
  "setup_completed": true
}
```

## Troubleshooting

### Common Issues

**Docker not running:**
```bash
# Start Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add user to docker group
sudo usermod -aG docker $USER
# Log out and back in
```

**Permission denied:**
```bash
# Make sure Docker daemon is accessible
docker --version
docker info

# Note: Runsand requires sudo to run
sudo runsand --version
```

**Update issues:**
```bash
# Force reinstall
curl -sSL https://raw.githubusercontent.com/Soar-Development/runsand-installer/main/install.sh | sudo bash
```

**Slow download:**
The initial desktop image download may appear slow at first (~6% progress) but will accelerate as smaller layers are downloaded.

### Get Help

- **Documentation**: [View installation guide](docs/installation.md)
- **Issues**: [Report problems](https://github.com/Soar-Development/runsand-installer/issues)
- **Updates**: [View releases](https://github.com/Soar-Development/runsand-installer/releases)

## Security

- All connections use TLS encryption
- Wallet authentication via cryptographic signatures
- No private keys stored on client
- Open source installer and documentation
- Automated security updates

## License

The installer and documentation are open source. The Runsand client binary is proprietary software.

---

**Made with ❤️ by the Runsand Team**