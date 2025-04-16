local clusterParams = import '../clusterParams.libsonnet';
local dockerCredential = import '../_templates/_docker_credentials/index.libsonnet';

local app = {
  name: 'alertmanager-qywx-bot',
  replicas: 3,
  image: 'harbor.idc.roywong.work/library/alertmanager-qywx-bot:v1.03',
  containerPort: 8080,
  servicePort: 80,
  resources: {
    requests: {
      cpu: '100m',
      memory: '128Mi',
    },
    limits: {
      cpu: '1000m',
      memory: '1Gi',
    }
  },
};

[
  {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      name: app.name
    },
    spec: {
      replicas: app.replicas,
      selector: {
        matchLabels: {
          app: app.name
        }
      },
      template: {
        metadata: {
          labels: {
            app: app.name
          }
        },
        spec: {
          imagePullSecrets: clusterParams.imagePullSecrets,
          containers: [
            {
              name: app.name,
              image: app.image,
              imagePullPolicy: 'Always',
              resources: app.resources,
              ports: [
                {
                  containerPort: app.containerPort
                }
              ]
            }
          ]
        }
      }
    }
  },
  {
    apiVersion: 'v1',
    kind: 'Service',
    metadata: {
      name: app.name
    },
    spec: {
      selector: {
        app: app.name
      },
      ports: [
        {
          port: app.servicePort,
          targetPort: app.containerPort,
          protocol: 'TCP'
        }
      ]
    }
  },
  {
    apiVersion: 'networking.k8s.io/v1',
    kind: 'Ingress',
    metadata: {
      name: app.name,
      annotations: {},
    },
    spec: {
      ingressClassName: clusterParams.ingressNginxLanClassName,
      rules: [
        {
          host: app.name + clusterParams.ingressNginxLanDomainName,
          http: {
            paths: [
              {
                path: '/',
                pathType: 'Prefix',
                backend: {
                  service: {
                    name: app.name,
                    port: {
                      number: app.servicePort
                    }
                  }
                }
              }
            ]
          }
        }
      ]
    }
  },
] + dockerCredential