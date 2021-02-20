param(     [# Central management server
[Parameter(Mandatory=$true)][string] $CentralServer],
[Parameter(Mandatory=$true)] $GroupName, 
[Parameter(Mandatory=$true)] $Reboot=$false, 
[Parameter(Mandatory=$true)] $Whatif=$true)

$ServerList = get-dbaregserver -sqlinstance $CentralServer -Group $GroupName

$nodes = $ServerList | select-object ServerName

write-host 'The following nodes will be patched'
write-host '##################################################'
write-host $nodes
write-host '##################################################'
write-host ''
write-host ''
write-host ''

foreach ($node in $nodes){
    
    write-host 'Starting work on >>>>>'
    write-host $node.ServerName
    write-host ''
    if ($Whatif -eq $true) {
        write-host '>>>>> The WhatIf flag is set to true -- this is just a test'
        write-host ''

            #install and reboot
            if ($Reboot -eq $true)
            {
                Get-WindowsUpdate -WindowsUpdate -download -install -verbose -acceptall -autoreboot -WhatIf -computer $node.ServerName  #| Out-File -filepath "\\fs04\SQL\automation\AutoUpdates\logs\$node-$(Get-Date -f yyyy-MM-dd)-MSUpdates.log" -Force 
            }
            else {
                #install don't reboot
                Get-WindowsUpdate -WindowsUpdate -download -install -verbose -acceptall -whatif -computer $node.ServerName  #| Out-File -filepath "\\fs04\SQL\automation\AutoUpdates\logs\$node-$(Get-Date -f yyyy-MM-dd)-MSUpdates.log" -Force 
            }
            #save history
            #Get-WUHistory -computer $node.ServerName -last 1 | Out-File -filepath "\\fs04\SQL\automation\AutoUpdates\logs\$node-$(Get-Date -f yyyy-MM-dd)-MSUpdateHistory.log" -Force 
            }
        
    

    if ($Whatif -eq $false){
    #install and reboot
        if ($Reboot -eq $true)
        {
            Get-WindowsUpdate -WindowsUpdate -download -install -verbose -acceptall -autoreboot -computer $node.ServerName  | Out-File -filepath "\\fs04\SQL\automation\AutoUpdates\logs\$node-$(Get-Date -f yyyy-MM-dd)-MSUpdates.log" -Force 
        }
        else {
        #install don't reboot
            Get-WindowsUpdate -WindowsUpdate -download -install -verbose -acceptall -computer $node.ServerName  | Out-File -filepath "\\fs04\SQL\automation\AutoUpdates\logs\$node-$(Get-Date -f yyyy-MM-dd)-MSUpdates.log" -Force 
        }
        #save history
        #Get-WUHistory -computer $node.ServerName -last 1 | Out-File -filepath "\\fs04\SQL\automation\AutoUpdates\logs\$node-$(Get-Date -f yyyy-MM-dd)-MSUpdateHistory.log" -Force 
        }
    write-host 'Work completed on >>>>>'
    write-host $node.ServerName        
}