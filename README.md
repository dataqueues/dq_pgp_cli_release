# DQ PGP CLI - Installation Guide

A command-line tool for decrypting PGP-encrypted files line by line with progress tracking.

## Quick Installation

Choose your platform and run the installation command in your terminal.

---

## 🐧 Linux Installation

### Method 1: One-line Install (Recommended)
```bash
curl -fsSL "https://raw.githubusercontent.com/dataqueues/dq_pgp_cli_release/main/linux-install.sh" | bash
```

### Method 2: Download and Run Script
```bash
# Download the installer
wget https://raw.githubusercontent.com/dataqueues/dq_pgp_cli_release/main/linux-install.sh

# Make it executable
chmod +x linux-install.sh

# Run the installer
./linux-install.sh
```

### Method 3: Custom Installation Path
```bash
# Download first
wget https://raw.githubusercontent.com/dataqueues/dq_pgp_cli_release/main/linux-install.sh
chmod +x linux-install.sh

# Install to custom location (e.g., /usr/local/bin)
./linux-install.sh --path /usr/local/bin

# Or force reinstall
./linux-install.sh --force
```

### Manual Installation (Linux)
1. Go to [Releases](https://github.com/dataqueues/dq_pgp_cli_release/releases)
2. Download the appropriate file:
   - **Intel/AMD 64-bit**: `dq-pgp-linux-amd64`
   - **ARM 64-bit**: `dq-pgp-linux-arm64`
3. Make it executable and move to PATH:
   ```bash
   chmod +x dq-pgp-linux-amd64
   sudo mv dq-pgp-linux-amd64 /usr/local/bin/dq-pgp
   ```

---

## 🪟 Windows Installation

### Method 1: One-line Install (Recommended)
Open **PowerShell** as Administrator and run:
```powershell
iwr -useb "https://raw.githubusercontent.com/dataqueues/dq_pgp_cli_release/main/windows-install.ps1" | iex
```

### Method 2: Download and Run Script
```powershell
# Download the installer
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/dataqueues/dq_pgp_cli_release/main/windows-install.ps1" -OutFile "windows-install.ps1"

# Run the installer
.\windows-install.ps1
```

### Method 3: Custom Options
```powershell
# Download first
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/dataqueues/dq_pgp_cli_release/main/windows-install.ps1" -OutFile "windows-install.ps1"

# Install to custom location
.\windows-install.ps1 -InstallPath "C:\Tools\dq-pgp"

# Or force reinstall
.\windows-install.ps1 -Force
```

# Or force reinstall
.\install.ps1 -Force
```

### Manual Installation (Windows)
1. Go to [Releases](https://github.com/dataqueues/dq_pgp_cli_release/releases)
2. Download: `dq-pgp-windows-amd64.exe`
3. Rename to: `dq-pgp.exe`
4. Place in a directory in your PATH, or:
   - Create folder: `C:\Tools\dq-pgp\`
   - Move `dq-pgp.exe` there
   - Add `C:\Tools\dq-pgp\` to your PATH environment variable

### Windows Troubleshooting
If you get a PowerShell execution policy error:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

## 🍎 macOS Installation

### Method 1: One-line Install (Recommended)
```bash
curl -fsSL "https://raw.githubusercontent.com/dataqueues/dq_pgp_cli_release/main/mac-install.sh" | bash
```

### Method 2: Download and Run Script
```bash
# Download the installer
curl -o mac-install.sh "https://raw.githubusercontent.com/dataqueues/dq_pgp_cli_release/main/mac-install.sh"

# Make it executable
chmod +x mac-install.sh

# Run the installer
./mac-install.sh
```

### Method 3: Custom Installation Path
```bash
# Download first
curl -o mac-install.sh "https://raw.githubusercontent.com/dataqueues/dq_pgp_cli_release/main/mac-install.sh"
chmod +x mac-install.sh

# Install to custom location
./mac-install.sh --path /usr/local/bin

# Or force reinstall
./mac-install.sh --force
```

### Manual Installation (macOS)
1. Go to [Releases](https://github.com/dataqueues/dq_pgp_cli_release/releases)
2. Download the appropriate file:
   - **Intel Macs**: `dq-pgp-darwin-amd64`
   - **Apple Silicon (M1/M2)**: `dq-pgp-darwin-arm64`
3. Make it executable and move to PATH:
   ```bash
   chmod +x dq-pgp-darwin-amd64
   sudo mv dq-pgp-darwin-amd64 /usr/local/bin/dq-pgp
   ```

### macOS Troubleshooting
If you get a "cannot be opened because the developer cannot be verified" error:
1. Go to **System Preferences** → **Security & Privacy**
2. Click **"Allow Anyway"** next to the blocked app
3. Or run: `xattr -d com.apple.quarantine /path/to/dq-pgp`

---

## 📋 After Installation

### 1. Verify Installation
```bash
dq-pgp -h
```

You should see the help message with usage instructions.

### 2. Prepare Your Environment
- Place your PGP private key as `private_key.asc` in your working directory
- Or specify a custom key location with `-k` flag

### 3. Basic Usage
```bash
# Decrypt a file (uses ./private_key.asc)
dq-pgp encrypted.txt

# Decrypt with custom key
dq-pgp encrypted.txt -k /path/to/mykey.asc

# Decrypt with passphrase and verbose output
dq-pgp encrypted.txt -k mykey.asc -p "mysecret" -v

# Show all options
dq-pgp -h
```

---

## 🔧 Installation Options

### Default Installation Paths
- **Linux/macOS**: `~/.local/bin/dq-pgp`
- **Windows**: `%LOCALAPPDATA%\dq-pgp-cli\dq-pgp.exe`

### Linux/macOS Custom Installation
All installers support custom paths:

**Linux:**
```bash
./linux-install.sh --path /usr/local/bin
```

**macOS:**
```bash
./mac-install.sh --path /usr/local/bin
```

**Windows:**
```powershell
.\windows-install.ps1 -InstallPath "C:\Tools\dq-pgp"
```

### Force Reinstall
If you already have it installed:

**Linux:**
```bash
./linux-install.sh --force
```

**macOS:**
```bash
./mac-install.sh --force
```

**Windows:**
```powershell
.\windows-install.ps1 -Force
```

---

## 🔄 Updating

### Automatic Update
Re-run the installation command to get the latest version:

**Linux:**
```bash
curl -fsSL "https://raw.githubusercontent.com/dataqueues/dq_pgp_cli_release/main/linux-install.sh" | bash
```

**Windows:**
```powershell
iwr -useb "https://raw.githubusercontent.com/dataqueues/dq_pgp_cli_release/main/windows-install.ps1" | iex
```

**macOS:**
```bash
curl -fsSL "https://raw.githubusercontent.com/dataqueues/dq_pgp_cli_release/main/mac-install.sh" | bash
```

### Manual Update
1. Download the latest executable from [Releases](https://github.com/dataqueues/dq_pgp_cli_release/releases)
2. Replace your existing `dq-pgp` executable

---

## 🗑️ Uninstallation

### Linux/macOS
```bash
# Remove the executable
rm ~/.local/bin/dq-pgp

# Remove from PATH (edit your shell config file)
# Remove the line: export PATH="$PATH:$HOME/.local/bin"
```

### Windows
```powershell
# Remove the installation directory
Remove-Item -Recurse -Force "$env:LOCALAPPDATA\dq-pgp-cli"

# Remove from PATH via System Properties → Environment Variables
# Or use PowerShell:
$path = [Environment]::GetEnvironmentVariable("Path", "User")
$newPath = $path -replace ";$env:LOCALAPPDATA\\dq-pgp-cli", ""
[Environment]::SetEnvironmentVariable("Path", $newPath, "User")
```

---

## 🆘 Troubleshooting

### Command Not Found
After installation, restart your terminal or run:

**Linux/macOS:**
```bash
source ~/.bashrc
# or
source ~/.zshrc
```

**Windows:**
```powershell
refreshenv  # If you have Chocolatey
# or restart PowerShell
```

### Permission Issues (Linux/macOS)
```bash
chmod +x ~/.local/bin/dq-pgp
```

### PATH Issues
Verify the installation directory is in your PATH:

**Linux/macOS:**
```bash
echo $PATH | grep -o '[^:]*\.local/bin[^:]*'
```

**Windows:**
```powershell
$env:PATH -split ';' | Select-String "dq-pgp"
```

### Can't Download Scripts
If your system blocks downloads, you can:
1. Visit the URLs in a browser
2. Save the scripts manually
3. Run them locally

---

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/dataqueues/dq_pgp_cli_release/issues)
- **Releases**: [GitHub Releases](https://github.com/dataqueues/dq_pgp_cli_release/releases)

---

## 📖 Quick Reference

```bash
# Install (Linux)
curl -fsSL "https://raw.githubusercontent.com/dataqueues/dq_pgp_cli_release/main/linux-install.sh" | bash

# Install (Windows)
iwr -useb "https://raw.githubusercontent.com/dataqueues/dq_pgp_cli_release/main/windows-install.ps1" | iex

# Install (macOS)
curl -fsSL "https://raw.githubusercontent.com/dataqueues/dq_pgp_cli_release/main/mac-install.sh" | bash

# Basic usage
dq-pgp encrypted.txt

# With custom key
dq-pgp encrypted.txt -k mykey.asc

# Help
dq-pgp -h
```
