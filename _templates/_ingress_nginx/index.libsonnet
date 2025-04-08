local clusterParams = import '../../clusterParams.libsonnet';

function(app)
  local ingress = {
    apiVersion: 'networking.k8s.io/v1',
    kind: 'Ingress',
    metadata: {
      annotations: {
        'nginx.ingress.kubernetes.io/rewrite-target': '/',
        'nginx.ingress.kubernetes.io/ssl-redirect': 'true',
        'cert-manager.io/cluster-issuer': clusterParams.tls.cloudflare.clusterIssuerName,
        } + if app.ingress.basicAuth then {
          'nginx.ingress.kubernetes.io/auth-type': 'basic',
          'nginx.ingress.kubernetes.io/auth-secret': 'baisc-auth-' + app.name,
          'nginx.ingress.kubernetes.io/auth-realm': 'Authentication Required',
        } else {},
      labels: {app: app.name},
      name: app.name,
    },
    spec: {
      ingressClassName: app.ingressClassName,
      rules: [
        {
          host: host.hostname,
          http: {
            paths: [
              {
                backend: {
                  service: {
                    name: host.serviceName,
                    port: {
                      number: host.servicePortNumber,
                    },
                  },
                },
                path: ingress.path,
                pathType: 'ImplementationSpecific',
              },
            ],
          },
        },
        for host in app.ingress.hosts
      ],
      tls: [
        {
          hosts: [
            '*%s' % [clusterParams.ingressNginxLanDomainName],
          ],
          'secretName': app.name + '-tls-certificate-secret',
        }
      ]
    },
  };

  [ingress]