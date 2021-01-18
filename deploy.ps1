param(
 [Parameter(Mandatory=$True)]
 [string]
 $subscriptionId,

 [Parameter(Mandatory=$True)]
 [string]
 $resourceGroupName, 
	
 [string]
 $resourceGroupLocation,

 [Parameter(Mandatory=$True)]
 [string]
 $deploymentName,

 [string]
 $templateFilePath = "template.json",

 [string]
 $parametersFilePath = "parameters.json"
)

# sign in
Write-Host "Loggig in...";
Connect-AzAccount

# select subscription
Write-Host "Selecting subscription '$subscriptionId'";
Select-AzSubscription -SubscriptionId $subscriptionId;

#Create or check for existing resource group
$resourceGroup = Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if(!$resourceGroup)   
{
	Write-Host "Resource group '$resourceGroupName' does not exist. To create a resource group, please enter a location.";
	if(!$resourceGroupLocation) {
		$resourceGroupLocation = Read-Host "resourceGroupLocation";
	}
	Write-Host "Creating resource group '$resourceGroupName' in location '$resourceGroupLocation'";
	New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation 
} else {
	Write-Host "Using existing resource gorup '$resourceGroupName'";
}

# Start the deployment 
Write-Host "Starting deployment...";
if(Test-Path $parametersFilePath) {
	New-AzResourceGroupDeployment -Name $deploymentName -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath -TemplateParameterFile $parametersFilePath;
} else {
	New-AzResourceGroupDeployment -Name $deploymentName -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath;
}