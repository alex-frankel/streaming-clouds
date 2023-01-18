var location = 'westus2'

resource aks 'Microsoft.ContainerService/managedClusters@2022-04-01' existing = {
  name: 'alfrank-k8s'
}

module kubernetes './k8s.bicep' = {
  name: 'buildbicep-deploy'
  params: {
    kubeConfig: aks.listClusterAdminCredential().kubeconfigs[0].value
    mySelector: {
      matchLabels: {
        app: 'nginx'
      }
    }
  }
}

var dnsLabel = kubernetes.outputs.dnsLabel
var normalizedLocation = toLower(replace(location, ' ', ''))

output endpoint string = 'http://${dnsLabel}.${normalizedLocation}.cloudapp.azure.com'
