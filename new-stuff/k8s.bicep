@secure()
param kubeConfig string

import 'kubernetes@1.0.0' with {
  kubeConfig: kubeConfig
  namespace: 'default'
}

type selector = {
  matchLabels: {
    app: string
  }
  matchExpressions?: object
}

param mySelector selector

resource nginxDeploy 'apps/Deployment@v1' = {
  metadata: {
    name: 'nginx-deployment'
  }
  spec: {
    selector: mySelector
    replicas: 2
    template: {
      metadata: {
        labels: {
          app: 'nginx'
        }
      }
      spec: {
        containers: [
          {
            name: 'nginx'
            image: 'nginx:1.14.2'
            ports: [
              {
                containerPort: 80
              }
            ]
          }
        ]
      }
    }
  }
}



@description('Configure the BicepBuild service')
resource buildService 'core/Service@v1' = {
  metadata: {
    name: 'nginx'
    annotations: {
      'service.beta.kubernetes.io/azure-dns-label-name': 'nginx'
    }
  }
  spec: {
    type: 'LoadBalancer'
    ports: [
      {
        port: 80
      }
    ]
    selector: {
      app: 'nginx'
    }
  }
}

output dnsLabel string = 'nginx'
