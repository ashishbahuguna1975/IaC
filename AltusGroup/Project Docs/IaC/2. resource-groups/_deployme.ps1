# Deployment script

## successfully tested Jan-5-2021

Connect-AzAccount
Set-Location "C:\Users\akhassanov\OneDrive - New Signature\2020-12-10.Quorum\VSCode.Quorum.fromADO\qcloud-infrastructure\2. resource-groups"
.\create-resourcegroups.ps1 -assignRBAC $false -csvFileName  "create-resourcegroups.csv"
