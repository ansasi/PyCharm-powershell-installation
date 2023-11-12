# PyCharm Powershell Installation

## Introduction

This repository contains a script to install the latest version of **PyCharm** on a **Windows** machine using **Powershell**.

The function in the script uses two parameters:

- **$Scope**: The scope of the installation. This can be either for the current user (local) or for all users (global). The default value is 'global'.
- **$CreateShortcut**: A boolean value to indicate whether a shortcut should be created on the desktop. The default value is $true.

## Usage

To install PyCharm for all users and create a shortcut on the desktop, run the next script:

```powershell
function Install-PyCharm-Windows {
    param (
        [Parameter()]
        [ValidateSet('local','global')]
        [string[]]$Scope = 'global',
    
        [parameter()]
        [ValidateSet($true,$false)]
        [string]$CreateShortCut = $true
    )

    # ----------- #
    # Config file #
    # ----------- #

    # Config URL and destination
    $ConfigUrl = "https://download.jetbrains.com/python/silent.config"
    $ConfigDestination = "$env:TEMP\silent.config"
    
    Write-Host Downloading PyCharm config file
    Invoke-WebRequest -Uri $ConfigUrl -OutFile $ConfigDestination
    Write-Host Download finished

    Write-Host Updating configuration
    $Config = Get-Content $ConfigDestination

    # Installation mode
    if ($Scope  -eq 'global') {
        $Config = $Config -replace 'mode=user', 'mode=admin'
    }
    
    $Config | Set-Content $ConfigDestination

    # ------- #
    # PyCharm #
    # ------- #

    # Pycharm URL and destination
    $PyCharmUrl = "https://www.jetbrains.com/pycharm/download/download-thanks.html?platform=windows&code=PCC"
    $PyCharmDestination = "$env:TEMP"

    $UnattendedArgs = "/S /CONFIG=$ConfigDestination /D=C:\Program Files\PyCharm"
    
    # Download VS Code installer
    Write-Host Downloading PyCharm
    Invoke-RestMethod -Uri $PyCharmUrl -OutFile $PyCharmDestination
    Write-Host Download finished

    # Install PyCharm
    Write-Host Installing PyCharm
    Start-Process -FilePath $PyCharmDestination -ArgumentList $UnattendedArgs -Wait
    Write-Host Installation finished
    
    # Remove installer
    Write-Host Removing installation file
    Remove-Item $PyCharmDestination
    Write-Host Installation file removed
}

Install-PyCharm-Windows
```

## License

This extension is licensed under the MIT License. Please see the third-party notices file for details on the third-party binaries that we include with releases of this project.
