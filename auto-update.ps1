# Check if zed.exe is running
$zedProcess = Get-Process -Name "zed" -ErrorAction SilentlyContinue
if ($zedProcess) {
    Write-Host "Zed is running now"
    exit 1
}

# Define the path to the Zed installation directory
$zedPath = "D:\software\bin"

# Get the version of the current Zed executable
$zedVersionUrl = "https://raw.githubusercontent.com/sonercirit/zed-windows-stable/refs/heads/main/latest_build.txt"
$zedVersion = Invoke-RestMethod -Uri $zedVersionUrl -ErrorAction Stop

# Define the URL for the latest Zed release
$zedUrl = "https://github.com/sonercirit/zed-windows-stable/releases/latest/download/zed-windows-" + $zedVersion + ".exe"

# Download the latest Zed executable
$zedExePath = Join-Path -Path $zedPath -ChildPath "zed_new.exe"
Invoke-WebRequest -Uri $zedUrl -OutFile $zedExePath
# Check if the download was successful
if (-Not (Test-Path -Path $zedExePath)) {
    Write-Host "Failed to download Zed executable."
    exit 1
} else {
    Write-Host "Zed executable downloaded successfully."
    # Delete old zed
    $oldZedPath = Join-Path -Path $zedPath -ChildPath "zed.exe"
    if (Test-Path -Path $oldZedPath) {
        Remove-Item -Path $oldZedPath -Force
        Write-Host "Old Zed executable removed."
    } else {
        Write-Host "No old Zed executable found to remove."
    }
    # Rename the new zed executable
    Rename-Item -Path $zedExePath -NewName "zed.exe" -Force
    Write-Host "New Zed executable renamed successfully."
    exit 0
}
