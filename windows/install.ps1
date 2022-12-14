Function RequireAdmin {
	If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
		Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $PSCommandArgs" -Verb RunAs
		Exit
	}
}

RequireAdmin

Write-Output "    ______ _       __ _____  ______ ____ ______   ____  _____"
Write-Output "   / ____/| |     / // ___/ / ____//  _//_  __/  / __ \/ ___/"
Write-Output "  / __/   | | /| / / \__ \ / / __  / /   / /    / / / /\__ \ "
Write-Output " / /___   | |/ |/ / ___/ // /_/ /_/ /   / /    / /_/ /___/ / "
Write-Output "/_____/   |__/|__/ /____/ \____//___/  /_/     \____//____/  "

Write-Output "___       ______       _________                           ________________________________              "
Write-Output "__ |     / /__(_)____________  /________      _________    ___  ____/_____  /__(_)_  /___(_)____________ "
Write-Output "__ | /| / /__  /__  __ \  __  /_  __ \_ | /| / /_  ___/    __  __/  _  __  /__  /_  __/_  /_  __ \_  __ \"
Write-Output "__ |/ |/ / _  / _  / / / /_/ / / /_/ /_ |/ |/ /_(__  )     _  /___  / /_/ / _  / / /_ _  / / /_/ /  / / /"
Write-Output "____/|__/  /_/  /_/ /_/\__,_/  \____/____/|__/ /____/      /_____/  \__,_/  /_/  \__/ /_/  \____//_/ /_/ "
                                                                                                         
                                                                                                                   

Write-Output "Beginning installation"

$hasPackageManager = Get-AppPackage -name 'Microsoft.DesktopAppInstaller'
if (!$hasPackageManager -or [version]$hasPackageManager.Version -lt [version]"1.10.0.0") {
    Write-Output "Installing winget Dependencies"
    Add-AppxPackage -Path 'https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx'

    $releases_url = 'https://api.github.com/repos/microsoft/winget-cli/releases/latest'

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $releases = Invoke-RestMethod -uri $releases_url
    $latestRelease = $releases.assets | Where { $_.browser_download_url.EndsWith('msixbundle') } | Select -First 1

    "Installing winget from $($latestRelease.browser_download_url)"
    Add-AppxPackage -Path $latestRelease.browser_download_url
} else {
    Write-Output "winget already installed"
}

Write-Output "Configuring Winget"

$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json";
$settingsJson = 
@"
    {
        "experimentalFeatures": {
          "experimentalMSStore": true,
        }
    }
"@;
$settingsJson | Out-File $settingsPath -Encoding utf8

Write-Output "Installing Applications"

$apps = @(
    @{name = "Microsoft.PowerShell"; displayName = "PowerShell" }, 
    @{name = "Microsoft.VisualStudioCode"; displayName = "VSCode" }, 
    @{name = "Microsoft.WindowsTerminal"; displayName = "Windows Terminal" }, 
    @{name = "Microsoft.PowerToys"; displayName = "PowerToys" },
    @{name = "WinSCP.WinSCP"; displayName = "Windows SCP" },
    @{name = "Mozilla.Firefox.DeveloperEdition"; displayName = "Firefox Devloper Edition" },
    @{name = "Valve.Steam"; displayName = "Steam" },
    @{name = "Google.Chrome"; displayName = "Google Chrome" },
    @{name = "Microsoft.Edge.Dev"; displayName = "Microsoft Edge Development Edition" },
    @{name = "OliverSchwendener.ueli"; displayName = "Ueli" },
    # @{name = "valinet.ExplorerPatcher.Prerelease"; displayName = "Explorer Patcher" }, disabled due to incompatability with newer versions of windows 11 22h2
    @{name = "voidtools.Everything"; displayName = "Everything Search" },
    @{name = "9MTTCL66CPXJ"; displayName = "Ubuntu 22.04 LTS (windows subsystem for linux)" },
    @{name = "XPDCFJDKLZJLP8"; displayName = "Visual Studio Community 2022" },
    @{name = "Git.Git"; displayName = "Git - Source Contol Management" },
    @{name = "AltSnap.AltSnap"; displayName = "AltSnap - Move windows around using alt or the windows key" },
    @{name = "VideoLAN.VLC"; displayName = "VideoLAN VLC" },
    @{name = "t1m0thyj.WinDynamicDesktop"; displayName = "Windows Dynamic Desktop - live wallpaper support" },
    @{name = "Microsoft.Office"; displayName = "Microsoft Office Pack" }
);

Foreach ($app in $apps) {
    $listApp = winget list --exact -q $app.name --accept-source-agreements 
    if (![String]::Join("", $listApp).Contains($app.name)) {
        Write-host "Installing:" $app.displayName
        if ($app.source -ne $null) {
            winget install --exact --silent $app.name --source $app.source --accept-package-agreements --accept-source-agreements 
        } else {
            winget install --exact --silent $app.name --accept-package-agreements --accept-source-agreements
        }
    } else {
        Write-host "Skipping Install of" $app.displayName
    }
}

Write-Output "Uninstalling Bloatware"

$apps = "*3DPrint*",
        "Microsoft.MixedReality.Portal", 
        "Microsoft.Bing*",
        "Microsoft.GamingApp",
        "Microsoft.WindowsFeedbackHub",
        "Microsoft.549981C3F5F10",
        "Microsoft.MicrosoftStickyNotes",
        "Microsoft.MicrosoftSolitaireCollection",
        "Microsoft.WindowsMaps",
        "Microsoft.WindowsSoundRecorder",
        "Microsoft.ZuneMusic",
        "Microsoft.ZuneVideo",
        "microsoft.windowscommunicationsapps"

Foreach ($app in $apps) {
    Write-host "Uninstalling:" $app
    Get-AppxPackage -allusers $app  | Remove-AppxPackage
}

Write-Output "Configurating Applications"

Copy-Item .\configuration\ueli\config.json ~\AppData\Roaming\ueli\config.json
Copy-Item .\configuration\alt_snap\AltSnap.ini ~\AppData\Roaming\AltSnap\AltSnap.ini