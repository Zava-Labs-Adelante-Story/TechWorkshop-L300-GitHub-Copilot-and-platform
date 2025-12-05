@description('The name of the Log Analytics workspace')
param name string

@description('The location for the resource')
param location string

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: name
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

output id string = logAnalyticsWorkspace.id
output name string = logAnalyticsWorkspace.name
