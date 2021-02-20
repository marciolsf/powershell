param( 
    [# Central management server
    [Parameter(Mandatory=$true)] $CentralServer],
    [Parameter(Mandatory=$true)] $GroupName, 
    [Parameter(Mandatory=$true)] $WhatIf=$true)

$ServerList = get-dbaregserver -sqlinstance $CentralServer -Group $GroupName

$nodes = $ServerList | Select-Object ServerName

write-host '


#####################################################'
write-host 'Updating powershell modules for the following nodes:'
write-host $nodes
write-host '#####################################################'
    write-host ''
    write-host ''
    write-host ''


foreach ($node in $nodes) {
    write-host '##########################'
    write-host $node

if ($WhatIf -eq $true) {
    Invoke-Command -ComputerName $node.ServerName -ScriptBlock {        
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 
        Install-Module PowerShellGet -RequiredVersion 2.2.4 -SkipPublisherCheck -confirm:$false -WhatIf 
        install-module pswindowsupdate -confirm:$false -WhatIf 
        Enable-WURemoting 
    write-host '##########################'
    write-host ''
    write-host ''
    write-host ''
    }
}

if ($WhatIf -eq $false) {
    Invoke-Command -ComputerName $node.ServerName -ScriptBlock {       
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 
        Install-Module PowerShellGet -RequiredVersion 2.2.4 -SkipPublisherCheck -confirm:$false 
        install-module pswindowsupdate -confirm:$false 
        Enable-WURemoting
    write-host '##########################'
    write-host ''
    write-host ''
    write-host ''
    }
}

}
