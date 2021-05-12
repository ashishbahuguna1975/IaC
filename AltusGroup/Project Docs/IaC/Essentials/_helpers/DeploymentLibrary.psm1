Function Publish-TemplateLibrary {
  [CmdletBinding(DefaultParameterSetName = 'AllVariables')]
  Param (
    [string] $AzureSubscription = '',
    [string] $ResourceGroup = '',
    [string] $Template = '',
    [string] $SourceFolder = $PSScriptRoot,
    [string] $ArtifactStagingDirectory = $PSScriptRoot
  )

  Select-AzSubscription -Subscription $AzureSubscription | Out-Null
  if ($null -eq $(Get-AzResourceGroup $ResourceGroup -ErrorAction SilentlyContinue)) {
    New-AzResourceGroup -Name $ResourceGroup -Location "uksouth" | Out-Null
  }

  $DeploymentLibrary = New-AzResourceGroupDeployment -Name ("DeploymentLibrary" + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
    -ResourceGroupName $ResourceGroup `
    -TemplateFile "$($SourceFolder)\DeploymentLibrary.json" `
    -Force `
    -SkipTemplateParameterPrompt `
    -ErrorVariable ErrorMessages

  $StorageAccount = (Get-AzStorageAccount | Where-Object { $_.StorageAccountName -eq $DeploymentLibrary.Outputs.item("storageAccount").value })
  $StorageContainerName = "uploadlocation"

  # Copy files from the local storage staging location to the storage account container
  New-AzStorageContainer -Name $StorageContainerName -Context $StorageAccount.Context -ErrorAction SilentlyContinue | Out-Null

  Get-ChildItem $ArtifactStagingDirectory -Recurse -File | ForEach-Object -Process {
    #foreach ($SourcePath in $ArtifactFilePaths) {
    Set-AzStorageBlobContent -File $_.FullName -Blob $_.Name -Container $StorageContainerName -Context $StorageAccount.Context -Force | Out-Null
  }

  return $DeploymentLibrary.Outputs.item("storageAccount").value
}


Function Publish-SubscriptionDeployment {
  [CmdletBinding(DefaultParameterSetName = 'AllVariables')]
  Param(
    [string] $StorageAccountName = '',
    [string] $StorageContainerName = 'uploadlocation',
    [string] $TemplateFile = '',
    [string] $TemplateParametersFile = '',
    [string] $deploymentName = $($templatefile.split('.')[0] + "-" + $((Get-Date).ToUniversalTime()).ToString('MMddHHmmss'))
  )

  $ErrorActionPreference = 'Stop'
  Set-StrictMode -Version 3

  $StorageAccount = (Get-AzStorageAccount | Where-Object { $_.StorageAccountName -eq $StorageAccountName })
  $artifactLocation = $StorageAccount.Context.BlobEndPoint + $StorageContainerName + '/'
  $sas = (New-AzStorageContainerSASToken -Container $StorageContainerName -Context $StorageAccount.Context -Permission r -ExpiryTime (Get-Date).AddHours(4))

  $TemplateFile = $artifactLocation + $TemplateFile + $sas


  New-AzDeployment -Name $deploymentName `
    -TemplateUri $TemplateFile `
    -TemplateParameterFile $TemplateParametersFile  `
    -DeploymentDebugLogLevel All `
    -Location "uksouth" `
    -SkipTemplateParameterPrompt `
    -ErrorAction Stop | Write-Host
}

Function Test-SubscriptionDeployment {
  [CmdletBinding(DefaultParameterSetName = 'AllVariables')]
  Param(
    [string] $StorageAccountName = '',
    [string] $StorageContainerName = 'uploadlocation',
    [string] $TemplateFile = '',
    [string] $TemplateParametersFile = ''
  )

  $ErrorActionPreference = 'Stop'
  Set-StrictMode -Version 3

  $StorageAccount = (Get-AzStorageAccount | Where-Object { $_.StorageAccountName -eq $StorageAccountName })
  $artifactLocation = $StorageAccount.Context.BlobEndPoint + $StorageContainerName + '/'
  $sas = (New-AzStorageContainerSASToken -Container $StorageContainerName -Context $StorageAccount.Context -Permission r -ExpiryTime (Get-Date).AddHours(4))

  $TemplateFile = $artifactLocation + $TemplateFile + $sas


  $test = Test-AzDeployment `
    -TemplateUri $TemplateFile `
    -TemplateParameterFile $TemplateParametersFile  `
    -Location "uksouth" `
    -SkipTemplateParameterPrompt `
    -ErrorAction Stop | Write-Host

  return $test
}

Function Publish-ManagementGroupDeployment {
  [CmdletBinding(DefaultParameterSetName = 'AllVariables')]
  Param(
    [string] $ManagementGroupId = '',
    [string] $StorageAccountName = '',
    [string] $StorageContainerName = 'uploadlocation',
    [string] $TemplateFile = '',
    [string] $TemplateParametersFile = '',
    [string] $deploymentName = $($templatefile.split('.')[0] + "-" + $((Get-Date).ToUniversalTime()).ToString('MMddHHmmss'))
  )

  $ErrorActionPreference = 'Stop'
  Set-StrictMode -Version 3

  $StorageAccount = (Get-AzStorageAccount | Where-Object { $_.StorageAccountName -eq $StorageAccountName })
  $artifactLocation = $StorageAccount.Context.BlobEndPoint + $StorageContainerName + '/'
  $sas = (New-AzStorageContainerSASToken -Container $StorageContainerName -Context $StorageAccount.Context -Permission r -ExpiryTime (Get-Date).AddHours(4))

  $TemplateFile = $artifactLocation + $TemplateFile + $sas


  New-AzManagementGroupDeployment -Name $deploymentName `
    -ManagementGroupId $ManagementGroupId `
    -TemplateUri $TemplateFile `
    -TemplateParameterFile $TemplateParametersFile  `
    -DeploymentDebugLogLevel All `
    -Location "uksouth" `
    -SkipTemplateParameterPrompt `
    -ErrorAction Stop | Write-Host
}


Function Test-ManagementGroupDeployment {
  [CmdletBinding(DefaultParameterSetName = 'AllVariables')]
  Param(
    [string] $ManagementGroupId = '',
    [string] $StorageAccountName = '',
    [string] $StorageContainerName = 'uploadlocation',
    [string] $TemplateFile = '',
    [string] $TemplateParametersFile = ''
  )

  $ErrorActionPreference = 'Stop'
  Set-StrictMode -Version 3

  $StorageAccount = (Get-AzStorageAccount | Where-Object { $_.StorageAccountName -eq $StorageAccountName })
  $artifactLocation = $StorageAccount.Context.BlobEndPoint + $StorageContainerName + '/'
  $sas = (New-AzStorageContainerSASToken -Container $StorageContainerName -Context $StorageAccount.Context -Permission r -ExpiryTime (Get-Date).AddHours(4))

  $TemplateFile = $artifactLocation + $TemplateFile + $sas

  $test = Test-AzManagementGroupDeployment `
    -ManagementGroupId $ManagementGroupId `
    -TemplateUri $TemplateFile `
    -TemplateParameterFile $TemplateParametersFile `
    -Location "uksouth" `
    -SkipTemplateParameterPrompt `
    -ErrorAction Stop

  return $test
}

Export-ModuleMember -Function `
  Publish-TemplateLibrary, `
  Publish-SubscriptionDeployment, `
  Test-SubscriptionDeployment, `
  Test-ManagementGroupDeployment, `
  Publish-ManagementGroupDeployment
