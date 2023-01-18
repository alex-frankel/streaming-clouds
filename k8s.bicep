@secure()
param kubeConfig string

import 'kubernetes@1.0.0' with {
  kubeConfig: kubeConfig
  namespace: 'default'
}

// var build = {
//   name: 'bicepbuild'
//   version: 'latest'
//   image: 'ghcr.io/anthony-c-martin/bicep-on-k8s:main'
//   port: 80
// }

// @description('Configure the BicepBuild deployment')
// resource buildDeploy 'apps/Deployment@v1' = {
//   metadata: {
//     name: build.name
//   }
//   spec: {
//     selector: {
//       matchLabels: {
//         app: build.name
//         version: build.version
//       }
//     }
//     replicas: 1
//     template: {
//       metadata: {
//         labels: {
//           app: build.name
//           version: build.version
//         }
//       }
//       spec: {
//         containers: [
//           {
//             name: build.name
//             image: build.image
//             ports: [
//               {
//                 containerPort: build.port
//               }
//             ]
//           }
//         ]
//       }
//     }
//   }
// }

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
