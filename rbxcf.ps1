Add-Type -AssemblyName  System.Windows.Forms 
$global:balloon = New-Object System.Windows.Forms.NotifyIcon 
Get-Member -InputObject  $Global:balloon 
[void](Register-ObjectEvent  -InputObject $balloon  -EventName MouseDoubleClick  -SourceIdentifier IconClicked  -Action {
    $global:balloon.dispose()
    
    Remove-Job -Name IconClicked
    Remove-Variable  -Name balloon  -Scope Global
  }) 
  $path = (Get-Process -id $pid).Path
  $balloon.Icon  = [System.Drawing.Icon]::ExtractAssociatedIcon($path) 

$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
    InitialDirectory = [Environment]::GetFolderPath('Desktop') 
    Filter = 'TrueType Font (*.ttf)|*.ttf|OpenType Font (*.otf)|*.otf'
    Title = "RobloxCustomFont - Select a font to use."
}
$null = $FileBrowser.ShowDialog()
If ($FileBrowser.FileName) {
    $location = Get-ChildItem "$env:LOCALAPPDATA\Roblox\Versions\" -Directory
    foreach ($folder in $location) {
        Set-Location $env:LOCALAPPDATA\Roblox\Versions\$folder
        If (Test-Path -Path .\RobloxPlayerBeta.exe) {
            taskkill /f /im RobloxPlayerBeta.exe
            Set-Location .\content\Fonts\
            Copy-Item .\TwemojiMozilla.ttf $env:TEMP
            foreach($file in Get-ChildItem .\ -Filter "*.*tf"){
                Copy-Item $FileBrowser.FileName $file
            }
            Copy-Item $env:TEMP\TwemojiMozilla.ttf .\
            Remove-Item $env:TEMP\TwemojiMozilla.ttf
        }
    }
    $balloon.BalloonTipIcon  = [System.Windows.Forms.ToolTipIcon]::Info
    $balloon.BalloonTipText  = 'Font replacement successful.'
    $balloon.BalloonTipTitle  = "RobloxFontReplacement" 
    $balloon.Visible  = $true 
    $balloon.ShowBalloonTip(5000) 
}
else {
    $balloon.BalloonTipIcon  = [System.Windows.Forms.ToolTipIcon]::Error
    $balloon.BalloonTipText  = 'Font replacement Cancelled.'
    $balloon.BalloonTipTitle  = "RobloxFontReplacement" 
    $balloon.Visible  = $true 
    $balloon.ShowBalloonTip(5000) 
}
