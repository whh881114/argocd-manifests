local clusterParams = import '../clusterParams.libsonnet';
local vars = import './vars.libsonnet';

[
  {
    apiVersion: 'networking.k8s.io/v1',
    kind: 'Ingress',
    metadata: {
      name: vars.ingressName,
      annotations: {
        'nginx.ingress.kubernetes.io/rewrite-target': '/',
        'cert-manager.io/cluster-issuer': clusterParams.tls.clusterIssuerName,
        'nginx.ingress.kubernetes.io/ssl-redirect': 'true',
      }
    },
    spec: {
      ingressClassName: clusterParams.ingressNginxLanClassName,  // 指定ingress-nginx名称，系统内有部署多个ingress-nginx。
      rules: [
        {
          host: vars.serviceName + clusterParams.ingressNginxLanDomainName,
          http: {
            paths: [
              {
                path: '/',
                pathType: 'Prefix',
                backend: {
                  service: {
                    name: vars.serviceName,
                    port: {
                      number: vars.servicePort
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