# EwsgitOS Windows Edition

## How to install?

### enable running unsigned scripts

```ps1
Set-ExecutionPolicy unrestricted
```

### download and run the script

```ps1
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/ewsgit/Ewsgit-OS/main/windows/install_script.ps1'))
```
