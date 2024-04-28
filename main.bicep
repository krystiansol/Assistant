param location string = resourceGroup().location

resource assistantdb 'Microsoft.DocumentDB/databaseAccounts@2023-11-15' = {
  name: 'assistantdbaccount'
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    databaseAccountOfferType: 'Standard'
    enableFreeTier: true
    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
  }

  resource database 'sqlDatabases' = {
    name: 'assistantdb'
    properties: {
      resource: {
        id: 'assistantdb'
      }
    }
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: 'assistantPlan'
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: 'F1'
  }
  kind: 'linux'
}

resource appService 'Microsoft.Web/sites@2023-01-01' = {
  name: 'ksmfassistant'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|8.0'
      localMySqlEnabled: false
      appSettings: [
        {
          name: 'COSMOS_ENDPOINT'
          value: assistantdb.properties.documentEndpoint
        }
        {
          name: 'COSMOS_KEY'
          value: assistantdb.listKeys().primaryMasterKey
        }
      ]
    }
    httpsOnly: true
  }
  identity: {
    type: 'SystemAssigned'
  }
}
