local clusterParams = import '../clusterParams.libsonnet';

[
  {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      name: 'nginx',
      labels: {
        app: 'nginx'
      }
    },
    spec: {
      replicas: 1,
      selector: {
        matchLabels: {
          app: 'nginx'
        }
      },
      template: {
        metadata: {
          labels: {
            app: 'nginx'
          }
        },
        spec: {
          containers: [
            {
              name: 'nginx',
              image: 'harbor.idc.roywong.work/docker.io/nginx:1.27.1',
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
  },
  {
    apiVersion: 'v1',
    kind: 'Service',
    metadata: {
      name: 'nginx'
    },
    spec: {
      selector: {
        app: 'nginx'
      },
      ports: [
        {
          protocol: 'TCP',
          port: 80,
          targetPort: 80
        }
      ],
      type: 'ClusterIP'
    }
  },
  {
    apiVersion: 'networking.k8s.io/v1',
    kind: 'Ingress',
    metadata: {
      name: 'www-lan',
      annotations: {
        'nginx.ingress.kubernetes.io/rewrite-target': '/',
        'cert-manager.io/cluster-issuer': clusterParams.tls.clusterIssuerName,
        'nginx.ingress.kubernetes.io/ssl-redirect': 'true',
      }
    },
    spec: {
      ingressClassName: 'ingress-nginx-lan',  // 指定ingress-nginx名称，系统内有部署多个ingress-nginx。
      rules: [
        {
          host: 'www.idc-ingress-nginx-lan.roywong.work',
          http: {
            paths: [
              {
                path: '/',
                pathType: 'Prefix',
                backend: {
                  service: {
                    name: 'nginx',
                    port: {
                      number: 80
                    }
                  }
                }
              }
            ]
          }
        }
      ],
      tls: [
        {
          hosts: clusterParams.tls.dnsZones,
          secretName: clusterParams.tls.certificateSecret
        }
      ]
    }
  },
  {
    apiVersion: 'networking.k8s.io/v1',
    kind: 'Ingress',
    metadata: {
      name: 'www-wan',
      annotations: {
        'nginx.ingress.kubernetes.io/rewrite-target': '/',
        'cert-manager.io/cluster-issuer': clusterParams.tls.clusterIssuerName,
        'nginx.ingress.kubernetes.io/ssl-redirect': 'true',
      }
    },
    spec: {
      ingressClassName: 'ingress-nginx-wan',  // 指定ingress-nginx名称，系统内有部署多个ingress-nginx。
      rules: [
        {
          host: 'www.idc-ingress-nginx-wan.roywong.work',
          http: {
            paths: [
              {
                path: '/',
                pathType: 'Prefix',
                backend: {
                  service: {
                    name: 'nginx',
                    port: {
                      number: 80
                    }
                  }
                }
              }
            ]
          }
        }
      ],
      tls: [
        {
          hosts: clusterParams.tls.dnsZones,
          secretName: clusterParams.tls.certificateSecret
        }
      ]
    }
  }
]


