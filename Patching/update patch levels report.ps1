    [# Central management server
    [Parameter(Mandatory=$true)]
    [string]
    $CentralServer],
    [# database to write to
    [Parameter(Mandatory=$true)]
    [string]
    $DBName])

$datatable = get-dbaregserver -sqlinstance $CentralServer -Group prod |test-dbabuild -maxbehind "2CU" -Update
Write-DbaDbTableData -SqlInstance $CentralServer -InputObject $datatable -table dbo.PatchLevels -database $DBName -AutoCreateTable -Truncate

$datatable = get-dbaregserver -sqlinstance $CentralServer -Group dev |test-dbabuild -maxbehind "1CU" -Update
Write-DbaDbTableData -SqlInstance $CentralServer -InputObject $datatable -table dbo.PatchLevels -database $DBName -AutoCreateTable 

$datatable = get-dbaregserver -sqlinstance $CentralServer -Group stage |test-dbabuild -maxbehind "1CU" -Update
Write-DbaDbTableData -SqlInstance $CentralServer -InputObject $datatable -table dbo.PatchLevels -database $DBName -AutoCreateTable 

$datatable = get-dbaregserver -sqlinstance $CentralServer -Group IT |test-dbabuild -maxbehind "1CU" -Update
Write-DbaDbTableData -SqlInstance $CentralServer -InputObject $datatable -table dbo.PatchLevels -database $DBName -AutoCreateTable 