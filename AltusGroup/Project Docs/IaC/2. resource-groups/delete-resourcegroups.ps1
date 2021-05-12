<#
Read create-resourcegroups.md for details

Example: 
Connect-AzAccount
cd "C:\Users\akhassanov\OneDrive - New Signature\2020-12-10.Quorum\VSCode.Quorum\azure-infrastructure\resource-groups"
.\delete-resourcegroups.ps1 -assignRBAC $false -csvFileName  "rg-for-sub-qcloud-nonprod.csv" 
$csvFileName = "rg-for-sub-qcloud-nonprod.csv"
#>


param
    (
    [Parameter( Mandatory=$true,HelpMessage="CSV file name containg Azure Resource Group Definition with the following parameters:  action,Subscription Name,rgName,rgRegion,tagBusinessUnit,tagOrganization,tagTechnology,tagProduct,tagCostCenter,tagDepartment,tagProject,rbacPrincipal1,rbacRole1,rbacPrincipal2,rbacRole2,rbacPrincipal3,rbacRole3.")]
    [string]$csvFileName
    )


Function Get-CurrentLine { " Current line: "+$Myinvocation.ScriptlineNumber }


# Ingest RG configuration array
$rgarray=Import-Csv -Path $csvFileName
# $rg = $rgarray[0]


foreach( $rg in $rgarray)
	{
    # If Action=Remove, than remove a RG
    if ($rg.action -eq "remove" )
        {
        # get Subscription ID
        $subscriptionId = Get-AzSubscription -SubscriptionName $rg.subscriptionName -TenantId $rg.tenantId | Select-Object -ExpandProperty Id

        
        # Selcet subscription
        Select-AzSubscription -SubscriptionId $subscriptionId

        
        # Remove Resource Group
        try
            {
            $rgo = Remove-AzResourceGroup -Name $rg.rgName -Force
            if ($rgo)
                {
                $msg = "Resource Group ["+$rg.rgName+"] was deleted." + (Get-CurrentLine) 
                Write-Host "##vso[task.LogIssue type=warning;]$msg"
                }
            }
        catch
            {
            $msg = "Resource Group ["+$rg.rgName+"] deletion failed." + (Get-CurrentLine) +". Error -"+$error[0]
            Write-Host "##vso[task.LogIssue type=error;]$msg"
            exit 1
            }
        }
    }