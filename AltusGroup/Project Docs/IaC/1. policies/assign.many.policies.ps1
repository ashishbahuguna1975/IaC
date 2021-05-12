#region General
# Allowed locations for resource groups
# This policy enables you to restrict the locations your organization can create resource groups in. Use to enforce your geo-compliance requirements.
# /providers/Microsoft.Authorization/policyDefinitions/e765b5de-1225-4ba3-bd56-1ac6695af988
# Effect=deny
.\assign.single.policy.ps1 `
    -scopeName 'mg-root' `
    -scopeType 'managementGroup' `
    -policyId 'e765b5de-1225-4ba3-bd56-1ac6695af988' `
    -policyAssignmentName 'enf-allowed-locations-RG' `
    -policyAssignmentDescription 'Allowed locations for resource groups' `
    -param 'rgregions.policy.param.json' 


# Allowed location
# This policy enables you to restrict the locations your organization can specify when deploying resources. Use to enforce your geo-compliance requirements. Excludes resource groups, Microsoft.AzureActiveDirectory/b2cDirectories, and resources that use the 'global' region.
# /providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c
# Effect=deny
.\assign.single.policy.ps1 `
    -scopeName 'mg-root' `
    -scopeType 'managementGroup' `
    -policyId 'e56962a6-4747-49cd-b67b-bf8b01975c4c' `
    -policyAssignmentName 'enf-allowed-locations' `
    -policyAssignmentDescription 'Allowed locations' `
    -param 'regions.policy.param.json' 
#endregion

#region Security Centre
# There should be more than one owner assigned to your subscription
# It is recommended to designate more than one subscription owner in order to have administrator access redundancy.
# /providers/Microsoft.Authorization/policyDefinitions/09024ccc-0c5f-475e-9457-b7c0d9ed487b
.\assign.single.policy.ps1 `
    -scopeName 'mg-root' `
    -scopeType 'managementGroup' `
    -policyId '09024ccc-0c5f-475e-9457-b7c0d9ed487b' `
    -policyAssignmentName 'aud-subscription-owners' `
    -policyAssignmentDescription 'There should be more than one owner assigned to your subscription'
#endregion


#region Backup
#Azure Backup should be enabled for Virtual Machines
#This policy helps audit if Azure Backup service is enabled for all Virtual machines. Azure Backup is a cost-effective, one-click backup solution simplifies data recovery and is easier to enable than other cloud backup services.
#/providers/Microsoft.Authorization/policyDefinitions/013e242c-8828-4970-87b3-ab247555486d
.\assign.single.policy.ps1 `
    -scopeName 'mg-root' `
    -scopeType 'managementGroup' `
    -policyId '013e242c-8828-4970-87b3-ab247555486d' `
    -policyAssignmentName 'aud-Backup-on-VMs' `
    -policyAssignmentDescription 'Azure Backup should be enabled for Virtual Machines' 
#endregion


#region Compute
# Audit VMs that do not use managed disks
# /providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d
.\assign.single.policy.ps1 `
    -scopeName 'mg-root' `
    -scopeType 'managementGroup' `
    -policyId '06a78e20-9358-41c9-923c-fb736d382a4d' `
    -policyAssignmentName 'aud-VMs-managed-disks' `
    -policyAssignmentDescription 'Audit VMs that do not use managed disks' 


#Unattached disks should be encrypted
#This policy audits any unattached disk without encryption enabled.
#/providers/Microsoft.Authorization/policyDefinitions/2c89a2e5-7285-40fe-afe0-ae8654b92fb2
.\assign.single.policy.ps1 `
    -scopeName 'mg-root' `
    -scopeType 'managementGroup' `
    -policyId '2c89a2e5-7285-40fe-afe0-ae8654b92fb2' `
    -policyAssignmentName 'aud-unn-disks-encrypted' `
    -policyAssignmentDescription 'Unattached disks should be encrypted' 
#endregion



#region Storage Account
#Secure transfer to storage accounts should be enabled
#Audit requirement of Secure transfer in your storage account. Secure transfer is an option that forces your storage account to accept requests only from secure connections (HTTPS). Use of HTTPS ensures authentication between the server and the service and protects data in transit from network layer attacks such as man-in-the-middle, eavesdropping, and session-hijacking
#/providers/Microsoft.Authorization/policyDefinitions/404c3081-a854-4457-ae30-26a93ef643f9
.\assign.single.policy.ps1 `
    -scopeName 'mg-root' `
    -scopeType 'managementGroup' `
    -policyId '404c3081-a854-4457-ae30-26a93ef643f9' `
    -policyAssignmentName 'aud-sa-must-be-secure' `
    -policyAssignmentDescription 'Secure transfer to storage accounts should be enabled' 


#Storage accounts should restrict network access
#Network access to storage accounts should be restricted. Configure network rules so only applications from allowed networks can access the storage account. To allow connections from specific internet or on-premise clients, access can be granted to traffic from specific Azure virtual networks or to public internet IP address ranges
#/providers/Microsoft.Authorization/policyDefinitions/34c877ad-507e-4c82-993e-3452a6e0ad3c
.\assign.single.policy.ps1 `
    -scopeName 'mg-root' `
    -scopeType 'managementGroup' `
    -policyId '34c877ad-507e-4c82-993e-3452a6e0ad3c' `
    -policyAssignmentName 'aud-sa-network-access' `
    -policyAssignmentDescription 'Storage accounts should restrict network access' 


#Storage accounts should allow access from trusted Microsoft services
#Some Microsoft services that interact with storage accounts operate from networks that can't be granted access through network rules. To help this type of service work as intended, allow the set of trusted Microsoft services to bypass the network rules. These services will then use strong authentication to access the storage account.
#/providers/Microsoft.Authorization/policyDefinitions/c9d007d0-c057-4772-b18c-01e546713bcd
.\assign.single.policy.ps1 `
    -scopeName 'mg-root' `
    -scopeType 'managementGroup' `
    -policyId 'c9d007d0-c057-4772-b18c-01e546713bcd' `
    -policyAssignmentName 'aud-sa-trusted-microsoft' `
    -policyAssignmentDescription 'Storage accounts should allow access from trusted Microsoft services' 
#endregion


#region Enforce Tags
#####################################
###########  ENFORCE TAGS ###########
#####################################
# Require a tag on resource groups
# Enforces existence of a tag on resource groups.
# /providers/Microsoft.Authorization/policyDefinitions/96670d01-0a4d-4649-9c89-2d3abc0a5025

.\assign.single.policy.ps1 `
    -scopeName 'mg-root' `
    -scopeType 'managementGroup' `
    -policyId '96670d01-0a4d-4649-9c89-2d3abc0a5025' `
    -policyAssignmentName 'enf-rg-description-tag' `
    -policyAssignmentDescription 'Require specified tag on RG' `
    -param '{"tagName": {"value": "rg-description"}}'
#endregion


#region Create Enum Tags of RG Azure Policy
$policyRule = '{
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Resources/subscriptions/resourceGroups"
        },
        {
          "not":
            {
            "field": "[concat(''tags['', parameters(''tagName''), '']'')]",
            "in": "[parameters(''tagValues'')]"
            }
        }
      ]
    },
    "then": {
      "effect": "deny"
    }
 }'


$policyParameters = '{
    "tagName": {
      "type": "String",
      "metadata": {
        "displayName": "Tag Name",
        "description": "Name of the tag"
      }
    },
    "tagValues": {
      "type": "Array",
      "metadata": {
        "displayName": "Tag Values Array",
        "description": "Enum list of acceptible tag values"
      }
    }
  }'

$enumTagPolicyDefinition = New-AzPolicyDefinition `
    -Name 'Require a tag and enum value on all resource groups' `
    -DisplayName 'Require a tag and enum value on all resource groups' `
    -Description 'Enforces a required tag and enum value on all resource groups.' `
    -Policy $policyRule `
    -Parameter $policyParameters `
    -ManagementGroupName 'mg-root' `
    -Metadata '{"category":"Tags"}'


    $enumTagPolicyDefinition = Get-AzPolicyDefinition `
    -Name 'Require a tag and enum value on all resource groups' `
    -ManagementGroupName 'mg-root'
#endregion




#region Enforce free text tags on RG
# Require a tag on resource groups with a free text value
.\assign.single.policy.ps1 `
    -scopeName 'mg-root' `
    -scopeType 'managementGroup' `
    -policyId '96670d01-0a4d-4649-9c89-2d3abc0a5025' `
    -policyAssignmentName 'enf-rg-description-tag' `
    -policyAssignmentDescription 'Require rg-description tag on RG' `
    -param '{"tagName": {"value": "rg-description"}}'
#endregion


#region Enforce ENUM tags on RG
# Require a tag on resource groups with a value from pre-defined ENUM list
# Enforces existence of a tag on resource groups.
# Cutom Policy; definition saved in 
.\assign.single.policy.ps1 `
    -scopeName 'mg-root' `
    -scopeType 'managementGroup' `
    -policyId $enumTagPolicyDefinition.PolicyDefinitionId `
    -policyAssignmentName 'enf-application-name-tag' `
    -policyAssignmentDescription 'Require application-name tag on RG' `
    -param '{"tagName": {"value": "application-name"}, "tagValues": {"value": ["qcloud"]}}'


.\assign.single.policy.ps1 `
    -scopeName 'mg-root' `
    -scopeType 'managementGroup' `
    -policyId $enumTagPolicyDefinition.PolicyDefinitionId `
    -policyAssignmentName 'enf-cost-center-tag' `
    -policyAssignmentDescription 'Require cost-center tag on RG' `
    -param '{"tagName": {"value": "cost-center"}, "tagValues": {"value": ["TBD","TBD1","TBD2","TBD3","TBD4"]}}'


.\assign.single.policy.ps1 `
    -scopeName 'mg-root' `
    -scopeType 'managementGroup' `
    -policyId $enumTagPolicyDefinition.PolicyDefinitionId `
    -policyAssignmentName 'enf-environment-tag' `
    -policyAssignmentDescription 'Require environment tag on RG' `
    -param '{"tagName": {"value": "environment"}, "tagValues": {"value": ["prod","dev","qa","shared","dr"]}}'


.\assign.single.policy.ps1 `
    -scopeName 'mg-root' `
    -scopeType 'managementGroup' `
    -policyId $enumTagPolicyDefinition.PolicyDefinitionId `
    -policyAssignmentName 'enf-it-department-tag' `
    -policyAssignmentDescription 'Require it-department tag on RG' `
    -param '{"tagName": {"value": "it-department"}, "tagValues": {"value": ["infrastructure","dev"]}}'


.\assign.single.policy.ps1 `
    -scopeName 'mg-root' `
    -scopeType 'managementGroup' `
    -policyId $enumTagPolicyDefinition.PolicyDefinitionId `
    -policyAssignmentName 'enf-bcdr-tag' `
    -policyAssignmentDescription 'Require business-continuity tag on RG' `
    -param '{"tagName": {"value": "business-continuity"}, "tagValues": {"value": ["tier1","tier2","tier3"]}}'

#endregion


#region Inherit TAGS
#####################################
###########  Inherit TAGS ###########
#####################################
# Definition name: Inherit a tag from the resource group
# Definition description: Adds or replaces the specified tag and value from the parent resource group when any resource is created or updated. Existing resources can be remediated by triggering a remediation task
# /providers/Microsoft.Authorization/policyDefinitions/cd3aa116-8754-49c9-a813-ad46512ece54
.\assign.single.policy.ps1 `
    -scopeName 'mg-root' `
    -scopeType 'managementGroup' `
    -policyId 'cd3aa116-8754-49c9-a813-ad46512ece54' `
    -policyAssignmentName 'inh-rg-description-tag' `
    -policyAssignmentDescription 'Inherit rg-description tag from the resource group' `
    -param '{"tagName": {"value": "rg-description"}}' `
    -assignIdentity $true `
    -identityLocation canadacentral

.\assign.single.policy.ps1 `
    -scopeName 'mg-root' `
    -scopeType 'managementGroup' `
    -policyId 'cd3aa116-8754-49c9-a813-ad46512ece54' `
    -policyAssignmentName 'inh-application-name-tag' `
    -policyAssignmentDescription 'Inherit application-name tag from the resource group' `
    -param '{"tagName": {"value": "application-name"}}' `
    -assignIdentity $true `
    -identityLocation canadacentral

.\assign.single.policy.ps1 `
    -scopeName 'mg-root' `
    -scopeType 'managementGroup' `
    -policyId 'cd3aa116-8754-49c9-a813-ad46512ece54' `
    -policyAssignmentName 'inh-cost-center-tag' `
    -policyAssignmentDescription 'Inherit cost-center tag from the resource group' `
    -param '{"tagName": {"value": "cost-center"}}' `
    -assignIdentity $true `
    -identityLocation canadacentral    

.\assign.single.policy.ps1 `
    -scopeName 'mg-root' `
    -scopeType 'managementGroup' `
    -policyId 'cd3aa116-8754-49c9-a813-ad46512ece54' `
    -policyAssignmentName 'inh-environment-tag' `
    -policyAssignmentDescription 'Inherit environment tag from the resource group' `
    -param '{"tagName": {"value": "environment"}}' `
    -assignIdentity $true `
    -identityLocation canadacentral  

.\assign.single.policy.ps1 `
    -scopeName 'mg-root' `
    -scopeType 'managementGroup' `
    -policyId 'cd3aa116-8754-49c9-a813-ad46512ece54' `
    -policyAssignmentName 'inh-it-department-tag' `
    -policyAssignmentDescription 'Inherit it-department tag from the resource group' `
    -param '{"tagName": {"value": "it-department"}}' `
    -assignIdentity $true `
    -identityLocation canadacentral  

.\assign.single.policy.ps1 `
    -scopeName 'mg-root' `
    -scopeType 'managementGroup' `
    -policyId 'cd3aa116-8754-49c9-a813-ad46512ece54' `
    -policyAssignmentName 'inh-bcdr-tag' `
    -policyAssignmentDescription 'Inherit business-continuity tag from the resource group' `
    -param '{"tagName": {"value": "business-continuity"}}' `
    -assignIdentity $true `
    -identityLocation canadacentral 
#endregion


<#
# Remove all policy assignments

$scope = Get-AzManagementGroup -GroupName 'mg-root' | select -ExpandProperty Id
Get-AzPolicyAssignment -Scope $scope | Remove-AzPolicyAssignment -Scope $scope
Get-AzPolicyAssignment -Scope $scope
    

#>