# Deployment script

Connect-AzAccount
Set-Location "C:\Users\akhassanov\OneDrive - New Signature\2020-12-10.Quorum\VSCode.Quorum.fromADO\qcloud-infrastructure\6. vpn"

$subscriptionId = Get-AzSubscription -SubscriptionName "sub-qcloud-prod" -TenantId "df64be21-062a-4c81-9a93-a6bb3fea4c60" | Select-Object -ExpandProperty Id
$subscriptionId

Select-AzSubscription -SubscriptionId $subscriptionId

New-AzResourceGroupDeployment -ResourceGroupName rg-network-prod -TemplateFile ./vngw-vpn.json -TemplateParameterFile ./vngw-prod.params.json
New-AzResourceGroupDeployment -ResourceGroupName rg-network-prod -TemplateFile ./lngw.json -TemplateParameterFile ./lngw-calgary-prod.params.json
New-AzResourceGroupDeployment -ResourceGroupName rg-network-prod -TemplateFile ./cn.json -TemplateParameterFile ./cn-calgary-prod.params.json


New-AzResourceGroupDeployment -ResourceGroupName rg-network-dr -TemplateFile ./vngw-vpn.json -TemplateParameterFile ./vngw-dr.params.json
New-AzResourceGroupDeployment -ResourceGroupName rg-network-dr -TemplateFile ./lngw.json -TemplateParameterFile ./lngw-calgary-dr.params.json
New-AzResourceGroupDeployment -ResourceGroupName rg-network-dr -TemplateFile ./cn.json -TemplateParameterFile ./cn-calgary-dr.params.json