# Requires running as Administrator

Write-Host "Starting cleanup..." -ForegroundColor Cyan

# -----------------------------
# Remove Lync folder per user
# -----------------------------
$ProfileList = Get-ChildItem "C:\Users" -Directory | Where-Object {
    $_.Name -notin @("Public", "Default", "Default User", "All Users")
}

foreach ($Profile in $ProfileList) {

    $LyncPath = Join-Path $Profile.FullName "AppData\Local\Microsoft\Office\16.0\Lync"

    if (Test-Path $LyncPath) {
        try {
            Write-Host "Removing: $LyncPath"
            Remove-Item -Path $LyncPath -Recurse -Force -ErrorAction Stop
            Write-Host "Successfully removed for user: $($Profile.Name)" -ForegroundColor Green
        }
        catch {
            Write-Warning "Failed to remove for user: $($Profile.Name)"
            Write-Warning $_.Exception.Message
        }
    }
    else {
        Write-Host "Lync path not found for user: $($Profile.Name)"
    }
}

# -----------------------------------------
# Remove Office16 program file directories
# -----------------------------------------
$OfficePaths = @(
    "C:\Program Files (x86)\Common Files\Microsoft Shared\OFFICE16",
    "C:\Program Files (x86)\Microsoft Office\root\Office16"
)

foreach ($Path in $OfficePaths) {
    if (Test-Path $Path) {
        try {
            Write-Host "Removing: $Path"
            Remove-Item -Path $Path -Recurse -Force -ErrorAction Stop
            Write-Host "Successfully removed: $Path" -ForegroundColor Green
        }
        catch {
            Write-Warning "Failed to remove: $Path"
            Write-Warning $_.Exception.Message
        }
    }
    else {
        Write-Host "Path not found: $Path"
    }
}

Write-Host "Cleanup complete." -ForegroundColor Cyan

Start-Sleep -Seconds 10