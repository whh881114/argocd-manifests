local clusterParams = import '../../clusterParams.libsonnet';

function(app)
  local ingress = {
    apiVersion: 'networking.k8s.io/v1',
    kind: 'Ingress',
    metadata: {
      annotations: {
        'nginx.ingress.kubernetes.io/rewrite-target': '/',
        'nginx.ingress.kubernetes.io/ssl-redirect': 'true',
        'cert-manager.io/cluster-issuer': clusterParams.tls.cloudflare.clusterIssuer,
        } + if std.objectHas(app.ingress, 'basicAuth') && app.ingress.basicAuth then {
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
          host: rule.hostname,
          http: {
            paths: [
              {
                backend: {
                  service: {
                    name: rule.serviceName,
                    port: {
                      number: rule.servicePortNumber,
                    },
                  },
                },
                path: rule.path,
                pathType: 'ImplementationSpecific',
              },
            ],
          },
        },
        for rule in app.ingress.rules
      ],
      tls: [
        {
          hosts: [
            rule.hostname,
            for rule in app.ingress.rules
          ],
          'secretName': 'tls-certificate-secret-' + app.name,
        }
      ]
    },
  };

  [ingress]