# Bootstraps Cadmium for Windows
# --------------------------------------
# This script installs Cadmium into ~/cadmium-projects,
# builds it, and permanently adds it to your system PATH.

# === CONFIGURATION ===
$cadmiumEnvFile = "$HOME\.env-cadmium.ps1"
$cadmiumProjectsDir = "$HOME\cadmium-projects"
$latestCadmiumBranch = "dev-rt"

# === CREATE PROJECTS DIRECTORY AND INSTALL CADMIUM ===
if (-Not (Test-Path $cadmiumProjectsDir)) {
    Write-Host 'Creating Cadmium projects directory...'
    New-Item -ItemType Directory -Path $cadmiumProjectsDir | Out-Null

    Write-Host 'Cloning Cadmium repository...'
    Set-Location $cadmiumProjectsDir
    git clone https://github.com/Sasisekhar/cadmium_v2 --single-branch -b $latestCadmiumBranch
    Set-Location "$cadmiumProjectsDir\cadmium_v2"

    git update-index --chmod=+x build.sh

    Write-Host 'Running Cadmium build script (via Git Bash)...'
    echo 'no' | bash build.sh

    Set-Location $HOME
}
else {
    Write-Host "Directory $cadmiumProjectsDir already exists. Aborting Cadmium installation."
}

# === CREATE CADMIUM ENVIRONMENT FILE ===
if (-Not (Test-Path $cadmiumEnvFile)) {
    Write-Host 'Creating Cadmium environment file...'
    $cadmiumPath = "$cadmiumProjectsDir\cadmium_v2\include"

    # Write environment variable setup commands
    "Set-Item -Path Env:CADMIUM -Value '$cadmiumPath'" | Out-File -FilePath $cadmiumEnvFile -Encoding UTF8
    "Set-Item -Path Env:Path -Value ('$cadmiumPath;' + `$Env:Path)" | Out-File -Append -FilePath $cadmiumEnvFile -Encoding UTF8

    # Load it immediately for this session
    . $cadmiumEnvFile
}
else {
    Write-Host "File $cadmiumEnvFile already exists. Skipping creation."
}

# === ADD CADMIUM TO USER PATH PERMANENTLY ===
Write-Host 'Adding Cadmium permanently to your PATH...'
$cadmiumIncludePath = "$cadmiumProjectsDir\cadmium_v2\include"
$oldPath = [Environment]::GetEnvironmentVariable('Path', 'User')

if ($oldPath -notmatch [Regex]::Escape($cadmiumIncludePath)) {
    $newPath = "$cadmiumIncludePath;$oldPath"
    [Environment]::SetEnvironmentVariable('Path', $newPath, 'User')
    Write-Host '✅ Cadmium path added permanently.'
}
else {
    Write-Host 'ℹ️ Cadmium path already exists in PATH. Skipping.'
}

# === FINISHED ===
Write-Host ''
Write-Host 'All done!'
Write-Host 'You may need to restart PowerShell or log out/in for the PATH changes to fully apply.'
Write-Host 'Good Labouring Under Correct Knowledge, i.e., good luck.'
