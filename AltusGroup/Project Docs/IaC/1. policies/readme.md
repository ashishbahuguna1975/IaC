# The policy.assignment.ps1 script can be used to create a new or update an existing policy assignment.


To assign a policy, run the policy.assignment.ps1 script, passing the following parameters.

scopeName : subscriptionID, Management Group Name, Resource Group Name
scopeType managementGroup OR subscription OR resourceGroup
policyId : ID of the policy definition you are assigning
policyAssignmentName : Assignment name
policyAssignmentDescription : Assignment description
param : Parameter file name or params in json format

To assign an initiative, pass the following parameters.

scopeName : subscriptionID, Management Group Name, Resource Group Name
scopeType managementGroup OR subscription OR resourceGroup
policyId : ID of the policy definition you are assigning
policyAssignmentName : Assignment name
policyAssignmentDescription : Assignment description
param : Parameter file name or params in json format
assignIdentity : $true or $false
identityLocation : Azure region 


Examples:

## Allowed locations for resource groups.
.\assign.policy.deploy.ps1 `
    -scopeName $devTestMgmtGrp `
    -scopeType 'managementGroup' `
    -policyId 'e765b5de-1225-4ba3-bd56-1ac6695af988' `
    -policyAssignmentName 'AllowedLocationsRG' `
    -policyAssignmentDescription 'Allowed locations for resource groups' `
    -param 'rgregions.policy.param.json' 

## Enable VM Monitoring - Initiative.
.\assign.policy.deploy.ps1 `
    -scopeName $prodSubscriptionId `
    -scopeType 'subscription' `
    -policyId '/providers/Microsoft.Authorization/policySetDefinitions/55f3eceb-5573-4f18-9695-226972c6d74a' `
    -policyAssignmentName 'EnableVMMonitorProd' `
    -policyAssignmentDescription 'Enable VM monitoring Prod' `
    -param '{"logAnalytics_1": {"value": "/subscriptions/75ee24f3-0dff-4ebe-b83c-014f012243b6/resourcegroups/core_cac_monitoring_prod-rg/providers/microsoft.operationalinsights/workspaces/agfcacprod-lw111"}}' `
    -assignIdentity $true `
    -identityLocation 'canadacentral' 
    