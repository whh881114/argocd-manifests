local clusterParams = import '../../clusterParams.libsonnet';

function(app)
  local ingress = {
    apiVersion: 'networking.k8s.io/v1',
    kind: 'Ingress',
    metadata: {
      annotations: {
        'nginx.ingress.kubernetes.io/rewrite-target': '/',
        'nginx.ingress.kubernetes.io/ssl-redirect': 'true',
        // 'nginx.ingress.kubernetes.io/auth-type': 'basic',
        // 'nginx.ingress.kubernetes.io/auth-secret': 'baisc-auth-' + app.name,
        // 'nginx.ingress.kubernetes.io/auth-realm': 'Authentication Required',
        'cert-manager.io/cluster-issuer': clusterParams.tls.clusterIssuerName,
      },
      labels: {app: app.name},
      name: app.name,
    },
    spec: {
      ingressClassName: app.ingressClassName,
      rules: [
        {
          host: ingress.host,
          http: {
            paths: [
              {
                backend: {
                  service: {
                    name: ingress.serviceName,
                    port: {
                      number: ingress.servicePortNumber,
                    },
                  },
                },
                path: ingress.path,
                pathType: 'ImplementationSpecific',
              },
            ],
          },
        },
        for ingress in app.ingress
      ],
      tls: [
        {
          hosts: [
            '*%s' % [clusterParams.ingressNginxLanDomainName],
          ],
          'secretName': clusterParams.tls.certificateSecret,
        }
      ]
    },
  };

  [ingress]