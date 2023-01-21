function Show-Notification {
    [cmdletbinding()]
    Param (
        [string]
        $ToastTitle,
        [string]
        [parameter(ValueFromPipeline)]
        $ToastText
    )

    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
    $Template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02)

    $RawXml = [xml] $Template.GetXml()
    ($RawXml.toast.visual.binding.text|Where-Object {$_.id -eq "1"}).AppendChild($RawXml.CreateTextNode($ToastTitle)) > $null
    ($RawXml.toast.visual.binding.text|Where-Object {$_.id -eq "2"}).AppendChild($RawXml.CreateTextNode($ToastText)) > $null

    $SerializedXml = New-Object Windows.Data.Xml.Dom.XmlDocument
    $SerializedXml.LoadXml($RawXml.OuterXml)

    $Toast = [Windows.UI.Notifications.ToastNotification]::new($SerializedXml)
    $Toast.Tag = "PowerShell"
    $Toast.Group = "PowerShell"
    $Toast.ExpirationTime = [DateTimeOffset]::Now.AddMinutes(1)

    $Notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("RobloxCustomFont")
    $Notifier.Show($Toast);
}

Add-Type -AssemblyName System.Windows.Forms
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
            Set-Location .\content\Fonts\
            Copy-Item .\TwemojiMozilla.ttf $env:TEMP
            foreach($file in Get-ChildItem .\ -Filter "*.*tf"){
                Copy-Item $FileBrowser.FileName $file
            }
            Copy-Item $env:TEMP\TwemojiMozilla.ttf .\
            Remove-Item $env:TEMP\TwemojiMozilla.ttf
        }
    }
    Show-Notification("Font replacement complete.")
}
