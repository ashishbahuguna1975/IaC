
# Author

akhasanov@newsignature.com

# Purpose

Bulk provision Azure Resource Groups, assign Tags and RBAC

# Requirement 1

If the script is deployed via ADO releaze pipeline, ADO Service connection must be added to "AAD\Roles and administrator\Director readers" AAD group

# Requiremnt 2

Populate resourcegroups-list.csv with values for each Resource Group (RG)

- [action] - "create" to create a RG defined in the line, any other value - ignore the line
- [tenantId] - AAD tenant GUIS
- [SubscriptionName] -  Azure Subscription name
- [rgName] - RG anme
- [rgRegion] - Azure region where the RG should be created
- [application-name] - values for corresponding tag keys
- [cost-center] - values for corresponding tag keys
- [environment] - values for corresponding tag keys
- [it-department] - values for corresponding tag keys
- [business-continuity] - values for corresponding tag keys