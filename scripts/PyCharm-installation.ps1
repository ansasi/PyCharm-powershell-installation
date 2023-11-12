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