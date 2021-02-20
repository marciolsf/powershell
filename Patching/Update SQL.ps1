param(     [# Central management server
        [Parameter(Mandatory=$true)]
        [string]
        $CentralServer],
        [Parameter(Mandatory=$true)]$GroupName, 
        [Parameter(Mandatory=$true)]$Reboot=$false, 
        [Parameter(Mandatory=$true)]$CopyFile=$false, 
        [Parameter(Mandatory=$true)]$InstallUpdate=$false, 
        [Parameter(Mandatory=$true)]$RootFolder,
        [Parameter(mandatory=$true)]$UpdatesFolderName
        $WhatIf=$false)

$ServerList = get-dbaregserver -sqlinstance $CentralServer -Group $GroupName

#If the build reference is out of date, the applet will refuse to install any new binaries
$serverlist | get-dbabuildreference -Update

#$cred = Get-Credential 
 
$nodes = $ServerList | Select-Object ServerName

write-host 'The following nodes will be updated'
write-host '##################################################'
write-host $nodes.ServerName
write-host '##################################################'
write-host ''
write-host ''
write-host ''


foreach ($node in $nodes)
{

    write-host "************************************************************************************************************"
    write-host "***** Starting updates for $($node.ServerName)"
    write-host "***** "
    $Majorversion = get-dbainstanceproperty -SqlInstance $node.ServerName -InstanceProperty VersionMajor | Select-Object value
    
    
    $major = $Majorversion


    $version = switch -Wildcard ($major) 
    {
        "*11*" {"2012"}
        "*12*" {'2014'}
        "*13*" {'2016'}
        "*14*" {'2017'}
        "*15*" {'2019'}
        default {'2008'}
    }

    write-host "***** Server version is $($version)"

    $UpdatePath = $RootFolder+$version+'\'+$UpdatesFolderName

    #in some instances, we want to copy multiple files down to the client, instead of just the latest file
    #in that case, I removed the filter to copy just the latest file.
    $file = Get-ChildItem $UpdatePath -exclude old #| Sort-Object lastaccesstime -Descending | Select-Object -First 1        

    $delim = '-'
    Get-ChildItem $file.FullName -Name | `
        ForEach-Object {$namearray = $_.Split($delim)
        $kb = $namearray[1]        

        if ($CopyFile -eq $true)
        {
            write-host "*****  Copying the files to local node"
            write-host "***** $file.Name"
            $session = New-PSSession -ComputerName $node.ServerName #-Credential $cred
        
            #remove old files first
            invoke-command -session $session -command { Get-ChildItem c:\temp\* | Where-Object name -Like '*kb*.exe' | remove-item }                  
            
            #copy new updates
            $file | copy-item -Destination "c:\temp\" -ToSession $session -Verbose
        }

        foreach ($k in $kb) 
        {
            write-host "***** The following KBs will be installed"
            write-host "***** $($k)"

            if ($WhatIf -eq $true)
            {
                write-host "***** This is just a test" -ForegroundColor Yellow                
                Update-DbaInstance -ComputerName $node.ServerName -Path 'c:\temp\' -kb $k -Confirm:$false -Verbose -WhatIf #-Credential $cred
            }

            if ($InstallUpdate -eq $true -and $Reboot -eq $false -and $WhatIf -eq $false)
            {
                write-host "***** Flags are set to install without reboot" -ForegroundColor Red
                Update-DbaInstance -ComputerName $node.ServerName -Path 'c:\temp\' -kb $k -Confirm:$false #-Credential $cred
            }
            elseif ($InstallUpdate -eq $true -and $Reboot -eq $true -and $WhatIf -eq $false)
            {
                write-host "***** Flags are set to install and reboot" -ForegroundColor Red
                Update-DbaInstance -ComputerName $node.ServerName -Restart -Path 'c:\temp\' -kb $k -Confirm:$false #-Credential $cred
            } 
        }

    }     
        write-host "***** All done! *****"
        write-host "*****"
        write-host "*****"
        write-host "************************************************************************************************************"
   
}
 
