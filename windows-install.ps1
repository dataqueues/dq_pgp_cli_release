# PowerShell Installation Script for PGP Decrypt CLI
# Downloads and installs from github.com/dataqueues/dq_pgp_cli_release

param(
    [string]$InstallPath = "$env:LOCALAPPDATA\dq-pgp-cli",
    [string]$GitHubRepo = "dataqueues/dq_pgp_cli_release",
    [switch]$Force
)

# Set TLS to 1.2 for GitHub API calls
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Write-Host "🔽 DQ PGP Decrypt CLI Installer" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan

# Function to get latest release info from GitHub
function Get-LatestRelease {
    param($repo)
    
    try {
        $apiUrl = "https://api.github.com/repos/$repo/releases/latest"
        Write-Host "📡 Fetching latest release from: $repo" -ForegroundColor Yellow
        $response = Invoke-RestMethod -Uri $apiUrl -Method Get
        return $response
    }
    catch {
        Write-Host "❌ Failed to fetch release info: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "💡 Make sure https://github.com/$repo exists and has releases" -ForegroundColor Blue
        throw
    }
}

# Function to download file
function Download-File {
    param($url, $destination)
    
    try {
        Write-Host "⬇️  Downloading: $(Split-Path $url -Leaf)" -ForegroundColor Yellow
        Write-Host "    From: $url" -ForegroundColor Gray
        Invoke-WebRequest -Uri $url -OutFile $destination -UseBasicParsing
        Write-Host "✅ Downloaded successfully" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Download failed: $($_.Exception.Message)" -ForegroundColor Red
        throw
    }
}

# Function to add to PATH
function Add-ToPath {
    param($path)
    
    $currentPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User)
    
    if ($currentPath -notlike "*$path*") {
        Write-Host "🔧 Adding to PATH: $path" -ForegroundColor Yellow
        [Environment]::SetEnvironmentVariable("Path", "$currentPath;$path", [EnvironmentVariableTarget]::User)
        Write-Host "✅ Added to PATH successfully" -ForegroundColor Green
        Write-Host "⚠️  Please restart your terminal to use the new PATH" -ForegroundColor Yellow
    } else {
        Write-Host "ℹ️  Already in PATH: $path" -ForegroundColor Blue
    }
}

try {
    # Check if already installed
    if (Test-Path "$InstallPath\pgp-decrypt.exe" -and -not $Force) {
        Write-Host "⚠️  DQ PGP CLI is already installed at: $InstallPath" -ForegroundColor Yellow
        Write-Host "   Use -Force to reinstall" -ForegroundColor Yellow
        $choice = Read-Host "Do you want to continue anyway? (y/N)"
        if ($choice -ne "y" -and $choice -ne "Y") {
            Write-Host "🚫 Installation cancelled" -ForegroundColor Red
            exit 0
        }
    }

    # Get latest release
    $release = Get-LatestRelease -repo $GitHubRepo
    Write-Host "📋 Latest version: $($release.tag_name)" -ForegroundColor Green
    Write-Host "📝 Release notes: $($release.name)" -ForegroundColor Blue

    # Find Windows executable asset
    $windowsAsset = $release.assets | Where-Object { 
        $_.name -like "*windows*amd64.exe" -or $_.name -eq "pgp-decrypt-windows-amd64.exe"
    }
    
    if (-not $windowsAsset) {
        Write-Host "❌ No Windows x64 executable found in the latest release" -ForegroundColor Red
        Write-Host "Available assets:" -ForegroundColor Yellow
        $release.assets | ForEach-Object { Write-Host "  - $($_.name)" -ForegroundColor Gray }
        Write-Host "💡 Looking for: pgp-decrypt-windows-amd64.exe" -ForegroundColor Blue
        exit 1
    }

    Write-Host "📦 Found executable: $($windowsAsset.name) ($([math]::Round($windowsAsset.size / 1MB, 2)) MB)" -ForegroundColor Green

    # Create installation directory
    if (-not (Test-Path $InstallPath)) {
        Write-Host "📁 Creating installation directory: $InstallPath" -ForegroundColor Yellow
        New-Item -ItemType Directory -Path $InstallPath -Force | Out-Null
    }

    # Download the executable
    $exePath = "$InstallPath\pgp-decrypt.exe"
    Download-File -url $windowsAsset.browser_download_url -destination $exePath

    # Verify the download
    if (Test-Path $exePath) {
        $fileSize = (Get-Item $exePath).Length
        Write-Host "✅ Installation successful!" -ForegroundColor Green
        Write-Host "📁 Installed to: $exePath" -ForegroundColor Blue
        Write-Host "📊 File size: $([math]::Round($fileSize / 1MB, 2)) MB" -ForegroundColor Blue
    } else {
        throw "Downloaded file not found"
    }

    # Add to PATH
    Add-ToPath -path $InstallPath

    # Test installation
    Write-Host "" -ForegroundColor White
    Write-Host "🧪 Testing installation..." -ForegroundColor Yellow
    try {
        # Test the executable
        $testOutput = & "$exePath" -h 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Installation test passed!" -ForegroundColor Green
        } else {
            Write-Host "⚠️  Installation test completed with exit code: $LASTEXITCODE" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "⚠️  Installation test failed, but files are installed correctly" -ForegroundColor Yellow
        Write-Host "    Error: $($_.Exception.Message)" -ForegroundColor Gray
    }

    Write-Host "" -ForegroundColor White
    Write-Host "🎉 Installation completed successfully!" -ForegroundColor Green
    Write-Host "" -ForegroundColor White
    Write-Host "📋 Quick start:" -ForegroundColor Cyan
    Write-Host "  1. Restart your terminal (or run: refreshenv if you have Chocolatey)" -ForegroundColor Gray
    Write-Host "  2. Place your private key as 'private_key.asc' in your working directory" -ForegroundColor Gray
    Write-Host "  3. Run: pgp-decrypt encrypted.txt" -ForegroundColor Gray
    Write-Host "" -ForegroundColor White
    Write-Host "📖 Usage examples:" -ForegroundColor Cyan
    Write-Host "  pgp-decrypt encrypted.txt" -ForegroundColor Gray
    Write-Host "  pgp-decrypt encrypted.txt -k mykey.asc -v" -ForegroundColor Gray
    Write-Host "  pgp-decrypt -f encrypted.txt -k mykey.asc -p mysecret" -ForegroundColor Gray
    Write-Host "" -ForegroundColor White
    Write-Host "🆘 For help: pgp-decrypt -h" -ForegroundColor Blue
    Write-Host "🐛 Issues: https://github.com/$GitHubRepo/issues" -ForegroundColor Blue

} catch {
    Write-Host "" -ForegroundColor White
    Write-Host "❌ Installation failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "" -ForegroundColor White
    Write-Host "🛠️  Manual installation:" -ForegroundColor Yellow
    Write-Host "1. Visit: https://github.com/$GitHubRepo/releases" -ForegroundColor Gray
    Write-Host "2. Download: pgp-decrypt-windows-amd64.exe" -ForegroundColor Gray
    Write-Host "3. Rename to: pgp-decrypt.exe" -ForegroundColor Gray
    Write-Host "4. Place in a directory in your PATH" -ForegroundColor Gray
    Write-Host "5. Or add the directory to your PATH manually" -ForegroundColor Gray
    exit 1
}

