#Ensure required environment variables are set.
if ($null -eq $env:launchPadEssentialsTest) {
  Write-Warning "Please ensure the launchPadEssentialsTest environment variable is set to a subscription ID to execute integration test!"
}
else {

  <# Prereqs - Set up Temporary Storage Account and Import Deployment Functions#>
  $rootFolder = $(Get-Item $PSScriptRoot).Parent.Parent.Fullname
  Import-Module "$rootFolder\_helpers\DeploymentLibrary.psm1" -Force
  $fixture = "$rootFolder\_tests\_fixtures\launchpadessentials.parameters.json"
  $sut = "launchpadessentials.json"

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
    It "Is a valid ARM template according to Azure" {
      $result = Test-SubscriptionDeployment `
        -StorageAccountName $library `
        -templateParametersFile $fixture `
        -templateFile $sut

        if ($null -ne $result) {
          Write-Output $result.code
          Write-Output $result.details
          Write-Output $result.message
          Write-Output $result.target
        }

        $result.message | Should -BeNullorEmpty
    }
  }
  try { Remove-TemplateLibrary } catch {Write-Warning "Unable to remove temporary storage account"}
}