targetScope = 'subscription'

@description('The environment name (e.g., dev, prod)')
param environmentName string = 'dev'

@description('The Azure region for all resources')
param location string = 'westus3'

@description('Base name for resources')
param baseName string = 'zavastore'

// Generate unique suffix for globally unique resource names
var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))
var resourceGroupName = 'rg-${baseName}-${environmentName}-${location}'

// Resource Group
resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
  tags: {
    environment: environmentName
    application: 'ZavaStorefront'
  }
}

// Log Analytics Workspace
module logAnalytics 'modules/logAnalytics.bicep' = {
  scope: rg
  name: 'logAnalytics'
  params: {
    name: 'log-${baseName}-${resourceToken}'
    location: location
  }
}

// Application Insights
module appInsights 'modules/applicationInsights.bicep' = {
  scope: rg
  name: 'appInsights'
  params: {
    name: 'appi-${baseName}-${resourceToken}'
    location: location
    logAnalyticsWorkspaceId: logAnalytics.outputs.id
  }
}

// Azure Container Registry
module acr 'modules/acr.bicep' = {
  scope: rg
  name: 'acr'
  params: {
    name: 'acr${baseName}${resourceToken}'
    location: location
  }
}

// App Service Plan
module appServicePlan 'modules/appServicePlan.bicep' = {
  scope: rg
  name: 'appServicePlan'
  params: {
    name: 'plan-${baseName}-${resourceToken}'
    location: location
  }
}

// App Service (Web App for Containers)
module appService 'modules/appService.bicep' = {
  scope: rg
  name: 'appService'
  params: {
    name: 'app-${baseName}-${resourceToken}'
    location: location
    appServicePlanId: appServicePlan.outputs.id
    containerRegistryName: acr.outputs.name
    applicationInsightsConnectionString: appInsights.outputs.connectionString
    applicationInsightsInstrumentationKey: appInsights.outputs.instrumentationKey
  }
}

// Role Assignment - AcrPull for App Service managed identity
module acrPullRoleAssignment 'modules/roleAssignment.bicep' = {
  scope: rg
  name: 'acrPullRoleAssignment'
  params: {
    principalId: appService.outputs.principalId
    acrName: acr.outputs.name
  }
}

// Microsoft Foundry (AI Services)
module foundry 'modules/foundry.bicep' = {
  scope: rg
  name: 'foundry'
  params: {
    name: 'ai-${baseName}-${resourceToken}'
    location: location
  }
}

// Outputs
output AZURE_RESOURCE_GROUP string = rg.name
output AZURE_CONTAINER_REGISTRY_NAME string = acr.outputs.name
output AZURE_CONTAINER_REGISTRY_ENDPOINT string = acr.outputs.loginServer
output AZURE_APP_SERVICE_NAME string = appService.outputs.name
output AZURE_APP_SERVICE_URL string = appService.outputs.url
output APPLICATIONINSIGHTS_CONNECTION_STRING string = appInsights.outputs.connectionString
output AZURE_FOUNDRY_ENDPOINT string = foundry.outputs.endpoint
