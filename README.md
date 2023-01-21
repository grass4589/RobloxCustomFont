# RobloxCustomFont

Replaces every TTF and OTF file in the Roblox fonts folder with a font of your choice.
Only tested on Windows.

# How to use

Paste this one liner into the Run dialog (Win + R) and press OK.

```powershell
powershell.exe $code = Invoke-RestMethod "https://raw.githubusercontent.com/grass45870/RobloxCustomFont/main/rbxcf.ps1"; foreach($a in $code) {iex $a;}
```

