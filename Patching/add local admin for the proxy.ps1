param(
    [# Central management server
    [Parameter(Mandatory=$true)]
    [string]
    $CentralServer],
    [# admin account
    [Parameter(Mandatory=$true)]
    [string]
    $admin]
)

$ServerList = get-dbaregserver -sqlinstance $CentralServer -Group Stage

$nodes = $ServerList | select ServerName

Write-Output $nodes

foreach ($node in $nodes) {
    write-output $node
    Invoke-Command -ComputerName $node.ServerName -ScriptBlock {
        Add-LocalGroupMember -group "Administrators" -Member $admin
    }
}
