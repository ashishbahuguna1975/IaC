# Deployment script

Connect-AzAccount
Set-Location "C:\Users\akhassanov\OneDrive - New Signature\2020-12-10.Quorum\VSCode.Quorum.fromADO\qcloud-infrastructure\4. network"
Set-Location "D:\qcloud-infrastructure-repo\qcloud-infrastructure\4. network"

$subscriptionId = Get-AzSubscription -SubscriptionName "sub-qcloud-prod" -TenantId "df64be21-062a-4c81-9a93-a6bb3fea4c60" | Select-Object -ExpandProperty Id
$subscriptionId

Select-AzSubscription -SubscriptionId $subscriptionId

Test-AzResourceGroupDeployment -ResourceGroupName rg-network-prod -TemplateFile ./vnet-prod.json
New-AzResourceGroupDeployment -ResourceGroupName rg-network-prod -TemplateFile ./vnet-prod.json

New-AzResourceGroupDeployment -ResourceGroupName rg-network-dr -TemplateFile ./vnet-dr.json
