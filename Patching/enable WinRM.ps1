param(
    [# Central management server
    [Parameter(Mandatory=$true)]
    [string]
    $CentralServer],
    [# Parameter help description
    [Parameter(Mandatory=$true)]
    [string]
    $GroupName]
    )
#print out server list
$ServerList = get-dbaregserver -sqlinstance $CentralServer -Group $GroupName

$nodes = $ServerList | select-object ServerName 

write-output $nodes

foreach ($node in $nodes) {
Convert-String -InputObject $node | write-output #| set-item wsman:\localhost\Client\TrustedHosts -Concatenate #-value $nodes #'ods-qw1, sqlbilling-qw1, sqlcms-qw1, sqld2h-qw1, sqlinsider-qw1, sqlmim-tw1, sqlnis-qw1, sqlonbase-tw1, sqlsap-tw1,SQLSFDC-qw1'
}

#create a new comma-separated line list of servers, then run them manually
#set-item WSMan:\localhost\Client\TrustedHosts -Concatenate -value 'sql-dw1,sqldw2'
#set-item WSMan:\localhost\Client\TrustedHosts -Concatenate -value 'BI06-DW1,bidev01,eag-sgstest,mspdev01,ods-dw1,SQLBilling-DW1,sqlclick-dw1,sqlcms-dw1,sqld2h-dw1,SQLDevOps-dw1,sqldist-dw1,sqlfinance-dw1,sqlinsider-dw1,sql-is-sf-dw1,sqlnis-dw1,sqlrelease-dw1,sqlsap-dw2,sqlsca-dw1,SQLSFDC-dw1,SQLSFLearn-DW1,w06053'
#set-item WSMan:\localhost\Client\TrustedHosts -Concatenate -value 'ODS-SW1,SQLBilling-SW1,SQLClick-SW1,SQLCMS-SW1,SQLD2H-SW1,SQLInsider-SW1,sqlnis-sw1,SQLSFDC-SW1,W06053'
#set-item wsman:\localhost\Client\TrustedHosts -Concatenate -value 'sqlhousing-pw1, BISSIS-pw1,mssqldst01   ,mssqlrpt01   ,SQL05        ,sqlauto-pw1  ,sqlcredit-pw2,SQLSolarwinds,hpqc-db-pw1,pvo-housing,sqlarcgis,SQLRCA-PW1,sqlsca-pw1,sqlsfdc-pw2,sqlwireless-pw1,sqldist-pw1,SQLDistributor,sqlmigrate-temp,SQLSFDC,SQLStages-PW1,bi06-pw2,MSSQLProd01,SQLClick-PW1,sqlclusterprod2,sqld2h,sqlinsider,SQLODS-PW1,bi06-pw1,SQLAtlassian,sqlbitbucket,sqlcms,sql-is-sf-pw1,sqlnis-pw1,sqlrelease-pw1,w06054,SQLODS-PW2'



