#Ensure required environment variables are set.
if ($null -eq $env:launchPadEssentialsTest) {
  Write-Warning "Please ensure the launchPadEssentialsTest environment variable is set to a subscription ID to execute integration test!"
}
else {

  <# Prereqs - Set up Temporary Storage Account and Import Deployment Functions#>
  $rootFolder = $(Get-Item $PSScriptRoot).Parent.Parent.Fullname
  Import-Module "$rootFolder\_helpers\DeploymentLibrary.psm1" -Force
  $fixture = "$rootFolder\_tests\_fixtures\LaunchPadEssentials.parameters.json"
  $sut = "LaunchPadEssentials.json"
  $deploymentName = $("launchpadessentialsintegrationtest" + "-" + $((Get-Date).ToUniversalTime()).ToString('MMddHHmmss'))

  try {
    $tempRgName = ("temp" + $(New-Guid).guid.split("-")[0])
    $library = Publish-TemplateLibrary `
      -AzureSubscription $env:launchPadEssentialsTest `
      -ResourceGroup $tempRgName `
      -Template $sut `
      -ArtifactStagingDirectory $rootFolder

    function Remove-TemplateLibrary {
      Remove-AzResourceGroup $tempRgName -Force | Out-Null
    }
  }
  catch {
    throw "Error in Publish-TemplateLibrary : $_"
  }

  <# Pester Tests #>
  Describe "$sut" {
    It "Deploys Successfully to Azure" {
      Publish-SubscriptionDeployment `
        -StorageAccountName $library `
        -templateFile $sut `
        -templateParametersFile $fixture `
        -DeploymentName $deploymentname
    }
  }
  Write-Host $deploymentname
  if (Get-AzResourceGroup  (Get-Content $fixture | ConvertFrom-Json).parameters.ResourceGroupName.value -erroraction silentlycontinue) {
    Remove-AzResourceGroup (Get-Content $fixture | ConvertFrom-Json).parameters.ResourceGroupName.value -force
  }
  Remove-TemplateLibrary
}