# Deployment script

Connect-AzAccount
Set-Location "C:\Users\akhassanov\OneDrive - New Signature\2020-12-10.Quorum\VSCode.Quorum.fromADO\qcloud-infrastructure\7. storage-accounts"

$subscriptionId = Get-AzSubscription -SubscriptionName "sub-qcloud-prod" -TenantId "df64be21-062a-4c81-9a93-a6bb3fea4c60" | Select-Object -ExpandProperty Id
$subscriptionId

Select-AzSubscription -SubscriptionId $subscriptionId

New-AzResourceGroupDeployment -ResourceGroupName rg-storage-prod -TemplateFile ./sa-prod.json
New-AzResourceGroupDeployment -ResourceGroupName rg-storage-dr -TemplateFile ./sa-dr.json

