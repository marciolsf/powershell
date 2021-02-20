[CmdletBinding()]
param (
    [Parameter(Mandatory=$yes)]
    [String]
    $ServerName
)

    write-output $ServerName
    Invoke-Command -ComputerName $Nodes -ScriptBlock {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 
        Install-Module PowerShellGet -RequiredVersion 2.2.4 -SkipPublisherCheck
        install-module pswindowsupdate
        Enable-WURemoting 
    }

