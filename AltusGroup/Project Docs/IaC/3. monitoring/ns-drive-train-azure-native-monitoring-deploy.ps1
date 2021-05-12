
# Validate Az PowerShell Module ver 4.7.0
Get-InstalledModule -Name Az -AllVersions | select-object -property Name,Version
# must have single AZ module ver 4.7.0.
#  If not – remove all Az modules  and install module 4.7.0
# Get-InstalledModule -Name Az -AllVersions | Uninstall-Module
# Install-Module az -RequiredVersion 4.7.0 -AllowClobber
# Get-InstalledModule -Name Az -AllVersions | select-object -property Name,Version


# Validate .Net Framework v4.6
(Get-ItemProperty "HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full").Release
<#.NET Framework 4.6	On Windows 10: 393295
On all other Windows operating systems: 393297
.NET Framework 4.6.1	On Windows 10 November Update systems: 394254
On all other Windows operating systems (including Windows 10): 394271
.NET Framework 4.6.2	On Windows 10 Anniversary Update and Windows Server 2016: 394802
On all other Windows operating systems (including other Windows 10 operating systems): 394806
.NET Framework 4.7	On Windows 10 Creators Update: 460798
On all other Windows operating systems (including other Windows 10 operating systems): 460805
.NET Framework 4.7.1	On Windows 10 Fall Creators Update and Windows Server, version 1709: 461308
On all other Windows operating systems (including other Windows 10 operating systems): 461310
.NET Framework 4.7.2	On Windows 10 April 2018 Update and Windows Server, version 1803: 461808
On all Windows operating systems other than Windows 10 April 2018 Update and Windows Server, version 1803: 461814
.NET Framework 4.8	On Windows 10 May 2019 Update and Windows 10 November 2019 Update: 528040
On Windows 10 May 2020 Update: 528372
On all other Windows operating systems (including other Windows 10 operating systems): 528049
#>


# Validate Az.Resources – must be 2.5.1
get-installedModule -Name Az.Resources
# get-installedModule -Name Az.Resources | Uninstall-Module
# install-Module -Name Az.Resources -RequiredVersion  2.5.1


# Validate Az.ManagedServiceIdentity version – must be 0.7.3
get-installedModule -Name Az.ManagedServiceIdentity
# get-installedModule -Name Az.ManagedServiceIdentity | Uninstall-Module
# install-Module -Name Az.ManagedServiceIdentity -RequiredVersion 0.7.3


# Valide  Blueprint module – must be 0.2.10
get-installedModule -Name Az.Blueprint
# get-installedModule -Name Az.Blueprint  | Uninstall-Module
# Install-Module -Name Az.Blueprint -RequiredVersion 0.2.13
import-module Az.Blueprint -RequiredVersion 0.2.13


# Validate security module – must be 0.8.0
get-installedModule -Name Az.Security
# get-installedModule -Name Az.Security | Uninstall-Module
# install-Module -Name Az.Security -RequiredVersion 0.8.0


# Validate Az.Accounts module – must be 1.8.0
get-installedModule -Name Az.Accounts
# get-installedModule -Name Az.Security | Uninstall-Module
# install-Module -Name Az.Security -RequiredVersion 0.8.0
import-module Az.Accounts -RequiredVersion 1.8.0

# Load deployment package
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force
az login -t a1a2578a-8fd3-4595-bb18-7d17df8944b0
az artifacts universal download --organization "https://dev.azure.com/newsigcode/" --feed "DriveTrain@Release" --name "newsig.arm.infrastructure" --version "1.6.0" --path C:\Temp\InfrastructureMonitoring-1.6.0


# Close and re-open PowerShell in elevated mode
# import-module Az -RequiredVersion 4.7.0
# import-module Az.Blueprint 
# disconnect-azaccount
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force -Scope CurrentUser
# az login -t 5a663d26-4247-4867-9361-d0807c64458f
# -------->  Connect-AzAccount -Tenant 5a663d26-4247-4867-9361-d0807c64458f
import-module Az.Accounts -RequiredVersion 1.8.0
import-module Az.Blueprint -RequiredVersion 0.2.13
Set-Location C:\Temp\InfrastructureMonitoring-1.6.0


# cleanup Unknown identity at the root management group level
# Review https://docs.microsoft.com/en-us/azure/role-based-access-control/elevate-access-global-admin#remove-a-role-assignment-at-the-root-scope-
# Get-AzRoleAssignment | where {$_.RoleDefinitionName -eq "User Access Administrator" -and $_.Scope -eq "/"}
# et-AzRoleAssignment | where {$_.RoleDefinitionName -eq "User Access Administrator" -and $_.ObjectId -eq "3ad87826-d687-4f0c-9fa6-bc445c037ed7" -and $_.Scope -eq "/"}
# Get-AzRoleAssignment | where {$_.RoleDefinitionName -eq "User Access Administrator" -and $_.ObjectId -eq "3ad87826-d687-4f0c-9fa6-bc445c037ed7" -and $_.Scope -eq "/"} | Remove-AzRoleAssignment 



# initiate deployment
.\Install-InfrastructureMonitoring.ps1 `
-workspaceName "la-canadacentral"  `
-Architecture Multiple `
-AzureTenantId df64be21-062a-4c81-9a93-a6bb3fea4c60  `
-AzureSubscription 2e99fe90-cfca-48ab-8684-296b02d259b4 `
-ResourceGroupName rg-monitoring `
-ResourceGroupLocation canadacentral `
-ManagementGroupId mg-root `
-Environment DEV `
-EnableSecurity $true `
-ChangeRetentionDays $true `
-SkipUserCheck `
-ServiceNowToken 12345678-1234-1234-1234-123456789012


# Action Groups
# EMail to Peter.Saverino@dehavilland.com
# Email to Eduard.Lelko@dehavilland.com
# WebHook: https://newsignature.service-now.com/api/global/em/ns_inbound_event_azure?token=663f7dbd-5d3c-4145-90af-4e3b9ea18800



<# 
	This PowerShell script was automatically converted to PowerShell Workflow so it can be run as a runbook.
	Specific changes that have been made are marked with a comment starting with “Converter:”
#>
workflow mainRunbookmlzxlkxyz7u3a {
	Param(
    	[parameter (Mandatory = $false)]
    	[object] $WebhookData,
	
    	[parameter (Mandatory = $false)]
    	$ChannelURL
	
	)
	# Converter: Wrapping initial script in an InlineScript activity, and passing any parameters for use within the InlineScript
	# Converter: If you want this InlineScript to execute on another host rather than the Automation worker, simply add some combination of -PSComputerName, -PSCredential, -PSConnectionURI, or other workflow common parameters (http://technet.microsoft.com/en-us/library/jj129719.aspx) as parameters of the InlineScript
	inlineScript {
		$WebhookData = $using:WebhookData
		$ChannelURL = $using:ChannelURL
		
		
		if($null -ne $WebhookData){
			$RequestBody = $WebhookData.RequestBody | ConvertFrom-Json
			$Data = $RequestBody.data
			$data
		}
		
		"Logging in to Azure..."
		$conn = Get-AutomationConnection -Name AzureRunAsConnection 
		Add-AzureRMAccount -ServicePrincipal -Tenant $conn.TenantID -ApplicationId $conn.ApplicationID -CertificateThumbprint $conn.CertificateThumbprint
		
		"Selecting Azure subscription..."
		$subId = Get-AutomationVariable -Name AzureSubscriptionId
		Select-AzureRmSubscription -SubscriptionId $subId -TenantId $conn.TenantID 
		
		"Enabling Schedule..."
		$automationAccountName = Get-AutomationVariable -Name AutomationAccountName
		$scheduleName = Get-AutomationVariable -Name ScheduleNameToEnable
		$rgName = Get-AutomationVariable -Name ResourceGroupName
		Set-AzureRmAutomationSchedule -ResourceGroupName $rgName -AutomationAccountName $automationAccountName -Name $scheduleName -IsEnabled $true
	}
}



<# 
	This PowerShell script was automatically converted to PowerShell Workflow so it can be run as a runbook.
	Specific changes that have been made are marked with a comment starting with “Converter:”
#>
workflow Sample {
	
	# Converter: Wrapping initial script in an InlineScript activity, and passing any parameters for use within the InlineScript
	# Converter: If you want this InlineScript to execute on another host rather than the Automation worker, simply add some combination of -PSComputerName, -PSCredential, -PSConnectionURI, or other workflow common parameters (http://technet.microsoft.com/en-us/library/jj129719.aspx) as parameters of the InlineScript
	inlineScript {
		"I am now Enabled and up and running"
		
		"Logging in to Azure..."
		$conn = Get-AutomationConnection -Name AzureRunAsConnection 
		Add-AzureRMAccount -ServicePrincipal -Tenant $conn.TenantID -ApplicationId $conn.ApplicationID -CertificateThumbprint $conn.CertificateThumbprint
		
		"Selecting Azure subscription..."
		$subId = Get-AutomationVariable -Name AzureSubscriptionId
		Select-AzureRmSubscription -SubscriptionId $subId -TenantId $conn.TenantID 
		
		"Disabling Schedule..."
		$automationAccountName = Get-AutomationVariable -Name AutomationAccountName
		$scheduleName = Get-AutomationVariable -Name ScheduleNameToEnable
		$rgName = Get-AutomationVariable -Name ResourceGroupName
		Set-AzureRmAutomationSchedule -ResourceGroupName $rgName -AutomationAccountName $automationAccountName -Name $scheduleName -IsEnabled $false
		
	}
}




