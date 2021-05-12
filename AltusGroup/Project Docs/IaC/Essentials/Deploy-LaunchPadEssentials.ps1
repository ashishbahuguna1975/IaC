#Requires -Module @{ ModuleName = 'Az.Resources'; ModuleVersion = '1.11.0' }

[CmdletBinding()]
param (
  # Id of the target subscription for the deployment
  [Parameter(Mandatory)]
  [string]
  $SubscriptionID,

  # Subscription to deploy the template library into
  [Parameter(Mandatory)]
  [string]
  $TemplateLibrarySubscriptionId,

  # Location to deploy the template library into
  [Parameter()]
  [string]
  $Location = "uksouth"
)

Set-AzContext -SubscriptionId $TemplateLibrarySubscriptionId -ErrorAction Stop | Out-Null

# create a temporary resource group and storage account to hold the linked templates

$random = Get-Random -Minimum 100000 -Maximum 999999

$resourceGroup = New-AzResourceGroup -Name "lztemplates-$random" -Location $Location -ErrorAction Stop

$storageAccParams = @{
  ResourceGroupName = $resourceGroup.ResourceGroupName
  Name              = "lztemplate$random"
  SkuName           = "Standard_LRS"
  Location          = $Location
  Kind              = "StorageV2"
}

$storageAccount = New-AzStorageAccount @storageAccParams

$container = New-AzStorageContainer -Name "templates" -Context $storageAccount.Context

# copy the assets into blob storage

Get-ChildItem -Path $PSScriptRoot -Recurse -File | Where-Object { $_.Extension -in @('.json', '.zip') } | ForEach-Object -Process {
  Set-AzStorageBlobContent -File $_.FullName -Container $container.Name -Blob $_.Name -Context $storageAccount.Context -Force | Out-Null
}

# create a sas token and get the uris for the template and parameter files

$sasToken = New-AzStorageContainerSASToken -Container $container.Name -Context $storageAccount.Context -Permission 'r'
$templateFileBlob = Get-AzStorageBlob -Container $container.Name -Context $container.Context -Blob "LaunchPadEssentials.json"
$templateFileUri = $templateFileBlob.ICloudBlob.Uri.AbsoluteUri + $sasToken

# start the deployment

Set-AzContext -SubscriptionId $SubscriptionID

$lzdeploymentParams = @{
  Location              = $Location
  Name                  = "LandingZone-$random"
  TemplateUri           = $templateFileUri
  TemplateParameterFile = "$PSScriptRoot\LaunchPadEssentials.parameters.json"
  Verbose               = $true
}

New-AzDeployment @lzdeploymentParams

# tidy up the deployment resource group

Write-Verbose -Message "Removing resource group $($resourceGroup.ResourceGroupName)"

Remove-AzResourceGroup -Name $resourceGroup.ResourceGroupName -Force