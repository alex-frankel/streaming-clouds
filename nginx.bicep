@secure()
param kubeConfig string

import 'kubernetes@1.0.0' with {
  namespace: 'default'
  kubeConfig: kubeConfig
}

resource appsDeployment_nginxDeployment 'apps/Deployment@v1' = {
  metadata: {
    name: 'nginx-deployment'
  }
  spec: {
    selector: {
      matchLabels: {
        app: 'nginx'
      }
    }
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