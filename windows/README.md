# EwsgitOS Windows Edition

## How to install?

### enable running unsigned scripts

```ps1
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $PSCommandArgs" -Verb RunAs
	Exit
}
Set-ExecutionPolicy unrestricted
```

### download and run the script

```ps1
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/ewsgit/Ewsgit-OS/main/windows/install_script.ps1'))
```
