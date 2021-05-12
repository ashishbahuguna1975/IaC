<#
Read create-resourcegroups.md for details

Example: 
Connect-AzAccount
cd "C:\Users\akhassanov\OneDrive - New Signature\2020-12-10.Quorum\VSCode.Quorum\azure-infrastructure\resource-groups"
.\create-resourcegroups.ps1 -assignRBAC $false -csvFileName  "create-resourcegroups.csv" 
#>


param
    (
    [Parameter( Mandatory=$true,HelpMessage="CSV file name containg Azure Resource Group Definition with the following parameters:  action,Subscription Name,rgName,rgRegion,tagBusinessUnit,tagOrganization,tagTechnology,tagProduct,tagCostCenter,tagDepartment,tagProject,rbacPrincipal1,rbacRole1,rbacPrincipal2,rbacRole2,rbacPrincipal3,rbacRole3.")]
    [string]$csvFileName,

    [Parameter( Mandatory=$true,HelpMessage="If =True, RBCA is assigned. if =False RBCA is ignored.")]
    [bool]$assignRBAC = $false
    )


Function Get-CurrentLine { " Current line: "+$Myinvocation.ScriptlineNumber }


# Ingest RG configuration array
$rgarray=Import-Csv -Path $csvFileName
# $rg = $rgarray[0]


foreach( $rg in $rgarray)
	{
    # If Action=Create, than create a new RG
    if ($rg.action -eq "create" )
        {
        # get Subscription ID
        $subscriptionId = Get-AzSubscription -SubscriptionName $rg.subscriptionName -TenantId $rg.tenantId | Select-Object -ExpandProperty Id

        
        # Selcet subscription
        Select-AzSubscription -SubscriptionId $subscriptionId

        
        # Create Tags object
        $tags = @{  "rg-description"=$rg."rg-description" ; `
                    "application-name"=$rg."application-name" ; `
                    "cost-center"=$rg."cost-center" ; `
                    "environment"=$rg."environment" ; `
                    "it-department"=$rg."it-department" ; `
                    "business-continuity"=$rg."business-continuity"
                }


        # Create Resource Group
        try
            {
            $region = $rg.rgRegion
            if ($region -eq "cc") { $region = "CanadaCentral" }
            if ($region -eq "ce") { $region = "CanadaEast" }
            $rgo = New-AzResourceGroup -Name $rg.rgName -Location $region -Tag $tags -Force
            if ($rgo)
                {
                $msg = "Resource Group ["+$rg.rgName+"] has been created." + (Get-CurrentLine) 
                Write-Host "##vso[task.LogIssue type=warning;]$msg"
                }
            }
        catch
            {
            $msg = "Resource Group ["+$rg.rgName+"] creation has failed." + (Get-CurrentLine) 
            Write-Host "##vso[task.LogIssue type=error;]$msg"
            exit 1
            }
        
        if ($assignRBAC)
            {
            #region Assign RBAC 1
            if ( $rg.rbacPrincipal1 )
                {
                # Get rbacPrincipal AAD object
                try
                    {
                    $groupObject = Get-AzADGroup -DisplayName $rg.rbacPrincipal1
                    }
                catch
                    {
                    $msg = "AAD group ["+$rg.rbacPrincipal1+"] lookup failed." + (Get-CurrentLine) +". Error: "+$error[0]
                    Write-Host "##vso[task.LogIssue type=error;]$msg"
                    exit 0
                    }


                if ( $groupObject )
                    {
                    # Assign RBAC
                    try
                        {
                        try
                            {
                            $ra = New-AzRoleAssignment -ObjectId $groupObject.Id -ResourceGroupName $rg.rgName -RoleDefinitionName $rg.rbacRole1
                            if ($ra)
                                {
                                $msg = "Security group ["+$groupObject.displayname+"] has been assigned a ["+$rg.rbacRole1+"] RBAC role for Resource Group ["+$rg.rgName+"]."
                                Write-Host "##vso[task.LogIssue type=warning;]$msg"
                                }
                            else
                                {
                                $msg = "Security group ["+$groupObject.displayname+"] has failed to assign a ["+$rg.rbacRole1+"] RBAC role for Resource Group ["+$rg.rgName+"]. Error - "+$error[0]
                                Write-Host "##vso[task.LogIssue type=error;]$msg"
                                }
                            }
                        catch
                            {
                            $msg = "Security group ["+$groupObject.displayname+"] has failed to assign a ["+$rg.rbacRole1+"] RBAC role for Resource Group ["+$rg.rgName+ (Get-CurrentLine) +". Error: "+$error[0]
                            Write-Host "##vso[task.LogIssue type=error;]$msg"
                            }
                        }
                    catch
                        {
                        $msg = "Security group ["+$groupObject.displayname+"] has failed to assign a ["+$rg.rbacRole1+"] RBAC role for Resource Group ["+$rg.rgName+"]."
                        Write-Host "##vso[task.LogIssue type=error;]$msg"
                        exit 1
                        }
                    }
                }
                    
            #endregion

            #region Assign RBAC 2
            if ( $rg.rbacPrincipal2 )
                {
                # Get rbacPrincipal AAD object
                $groupObject = Get-AzADGroup -DisplayName $rg.rbacPrincipal2


                if ( $groupObject )
                    {
                    # Assign RBAC
                    try
                        {
                        $ra = New-AzRoleAssignment -ObjectId $groupObject.Id -ResourceGroupName $rg.rgName -RoleDefinitionName $rg.rbacRole2
                        if ($ra)
                            {
                            $msg = "Security group ["+$groupObject.displayname+"] has been assigned a ["+$rg.rbacRole2+"] RBAC role for Resource Group ["+$rg.rgName+"]."
                            Write-Host "##vso[task.LogIssue type=warning;]$msg"
                            }
                        else
                            {
                            $msg = "Security group ["+$groupObject.displayname+"] has failed to assign a ["+$rg.rbacRole2+"] RBAC role for Resource Group ["+$rg.rgName+"]. Error - "+$error[0]
                            Write-Host "##vso[task.LogIssue type=warning;]$msg"
                            }
                        }
                    catch
                        {
                        $msg = "Security group ["+$groupObject.displayname+"] has failed to assign a ["+$rg.rbacRole2+"] RBAC role for Resource Group ["+$rg.rgName+"]."
                        Write-Host "##vso[task.LogIssue type=error;]$msg"
                        exit 1
                        }
                    }
                }
            #endregion


            #region Assign RBAC 3
            if ( $rg.rbacPrincipal3 )
                {
                # Get rbacPrincipal AAD object
                $groupObject = Get-AzADGroup -DisplayName $rg.rbacPrincipal3


                if ( $groupObject )
                    {
                    # Assign RBAC
                    try
                        {
                        $ra = New-AzRoleAssignment -ObjectId $groupObject.Id -ResourceGroupName $rg.rgName -RoleDefinitionName $rg.rbacRole3
                        if ($ra)
                            {
                            $msg = "Security group ["+$groupObject.displayname+"] has been assigned a ["+$rg.rbacRole3+"] RBAC role for Resource Group ["+$rg.rgName+"]."
                            Write-Host "##vso[task.LogIssue type=warning;]$msg"
                            }
                        else
                            {
                            $msg = "Security group ["+$groupObject.displayname+"] has failed to assign a ["+$rg.rbacRole3+"] RBAC role for Resource Group ["+$rg.rgName+"]. Error - "+$error[0]
                            Write-Host "##vso[task.LogIssue type=warning;]$msg"
                            }
                        }
                    catch
                        {
                        $msg = "Security group ["+$groupObject.displayname+"] has failed to assign a ["+$rg.rbacRole3+"] RBAC role for Resource Group ["+$rg.rgName+"]."
                        Write-Host "##vso[task.LogIssue type=error;]$msg"
                        exit 1
                        }
                    }
                }
            #endregion
            }
        }
    }