param 
(
    [Parameter(Mandatory=$true)][string]$scopeName,
    [Parameter(Mandatory=$true)][string]$scopeType,
    [Parameter(Mandatory=$true)][string]$policyId,
    [Parameter(Mandatory=$true)][string]$policyAssignmentName,
    [Parameter(Mandatory=$true)][string]$policyAssignmentDescription,
    [Parameter(Mandatory=$false)][string]$param,
    [Parameter(Mandatory=$false)][bool]$assignIdentity,
    [Parameter(Mandatory=$false)][string]$identityLocation

)

# Determine what the scope type of the assignment is and get the appropriate Scope ID from the provided scope value (scopeName)
if ($scopeType -eq 'managementGroup')
{
    $scope = Get-AzManagementGroup -GroupName $scopeName | select -ExpandProperty Id 

}
elseif ($scopeType -eq 'subscription')
{
    #$subscriptionId = Get-AzSubscription -SubscriptionName $scopeName | select -ExpandProperty Id 
    $scope = Get-AzSubscription -SubscriptionId $scopeName 
    $scope = '/subscriptions/'+$scope
}
elseif ($scopeType -eq 'resourceGroup')
{
    $subscriptionName,$scopeName = $scopeName.split(",")
    $subscriptionId = Get-AzSubscription -SubscriptionName $subscriptionName | select -ExpandProperty Id 
    Select-AzSubscription -SubscriptionId $subscriptionId
    $scope = Get-AzResourceGroup -Name $scopeName | select -ExpandProperty ResourceId
}

# Check to see if the policy assignment already exists
$res = Get-AzPolicyAssignment -Name $policyAssignmentName -Scope $scope -erroraction 'silentlycontinue'

# If the policy assignment exists, modify the policy assignment
if ($res -ne $null)
{
    Write-Output "Modifying existing policy assignment "$policyAssignmentName"..."
    if ($param.Length -eq 0)
    {
        Set-AzPolicyAssignment -Name $policyAssignmentName -Description $policyAssignmentDescription -Scope $scope
    }
    else 
    {
        Set-AzPolicyAssignment -Name $policyAssignmentName -Description $policyAssignmentDescription -Scope $scope -PolicyParameter $param
    }

}

# If the policy assignment does not exist, create a new policy assignment
else
{
    Write-Output "Creating new policy assignment..."
    if ($policyId.Length -gt 37)
    {
        $policy = Get-AzPolicyDefinition -Id $policyId
    }
    else 
    {
        $policy = Get-AzPolicyDefinition -Name $policyId    
    }

    if ($param.Length -eq 0)
    {
        if($assignIdentity -eq $true)
        {
            $assignment = New-AzPolicyAssignment -Name $policyAssignmentName -Description $policyAssignmentDescription -PolicyDefinition $policy -Scope $scope -AssignIdentity -Location $identityLocation 
            
            if ($assignment) 
            {
                $msg = "Policy ["+$policyAssignmentName+"] has been assigned."
                Write-Host "##vso[task.LogIssue type=warning;]$msg"
            }
            else
            {
                $msg = "Policy ["+$policyAssignmentName+"] assignment failed."
                Write-Host "##vso[task.LogIssue type=error;]$msg"
            }

            Start-Sleep -s 60

            # Use the $PolicyDefinition to get to the roleDefinitionIds array
            $roleDefinitionIds = $Policy.Properties.policyRule.then.details.roleDefinitionIds
            if ($roleDefinitionIds.Count -gt 0)
            {
                do
                    {
                    try
                        {
                        $roleDefinitionIds | ForEach-Object {
                            $roleDefId = $_.Split("/") | Select-Object -Last 1
                            $nra = New-AzRoleAssignment -Scope $Scope -ObjectId $assignment.Identity.PrincipalId -RoleDefinitionId $roleDefId -ErrorAction Stop
                            $msg = "Role ["+$nra.RoleDefinitionName+"] has been assigned to security principal ["+$assignment.Identity.PrincipalId+"] for policy ["+$policyAssignmentName+"]."
                            Write-Host "##vso[task.LogIssue type=warning;]$msg"
                            }
                        }
                    catch
                        {
                        $msg = "Role assignment fails. Re-try in 5 seconds. Error="+$error[0]
                        Write-Host "##vso[task.LogIssue type=warning;]$msg"
                        if ($error[0] -like "*The role assignment already exists*") {$nra="ok"}
                        Start-Sleep -s 30
                        }
                    }
                until ($nra)

            }
        }
        else
        {
            New-AzPolicyAssignment -Name $policyAssignmentName -Description $policyAssignmentDescription -PolicyDefinition $policy -Scope $scope 
        }
    }
    else 
    {
        if($assignIdentity -eq $true)
        {
            $assignment = New-AzPolicyAssignment -Name $policyAssignmentName  -Description $policyAssignmentDescription -PolicyDefinition $policy -Scope $scope -PolicyParameter $param -AssignIdentity -Location $identityLocation 
            
            if ($assignment) 
            {
                $msg = "Policy ["+$policyAssignmentName+"] has been assigned."
                Write-Host "##vso[task.LogIssue type=warning;]$msg"
            }
            else
            {
                $msg = "Policy ["+$policyAssignmentName+"] assignment failed."
                Write-Host "##vso[task.LogIssue type=error;]$msg"
            }

            Start-Sleep -s 60

            # Use the $PolicyDefinition to get to the roleDefinitionIds array
            $roleDefinitionIds = $Policy.Properties.policyRule.then.details.roleDefinitionIds
            if ($roleDefinitionIds.Count -gt 0)
            {
                do
                    {
                    try
                        {
                        $roleDefinitionIds | ForEach-Object {
                            $roleDefId = $_.Split("/") | Select-Object -Last 1
                            $nra = New-AzRoleAssignment -Scope $Scope -ObjectId $assignment.Identity.PrincipalId -RoleDefinitionId $roleDefId -ErrorAction Stop
                            $msg = "Role ["+$nra.RoleDefinitionName+"] has been assigned to security principal ["+$assignment.Identity.PrincipalId+"] for policy ["+$policyAssignmentName+"]."
                            Write-Host "##vso[task.LogIssue type=warning;]$msg"
                            }
                        }
                    catch
                        {
                        $msg = "Role assignment fails. Re-try in 5 seconds. Error="+$error[0]
                        Write-Host "##vso[task.LogIssue type=warning;]$msg"
                        if ($error[0] -like "*The role assignment already exists*") {$nra="ok"}
                        Start-Sleep -s 30
                        }
                    }
                until ($nra)
            }
        }
        else 
        {
            New-AzPolicyAssignment -Name $policyAssignmentName  -Description $policyAssignmentDescription -PolicyDefinition $policy -Scope $scope -PolicyParameter $param
        }
    }
}
