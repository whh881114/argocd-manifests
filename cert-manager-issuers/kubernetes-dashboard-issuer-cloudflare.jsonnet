local clusterParams = import '../clusterParams.libsonnet';

{
  apiVersion: 'cert-manager.io/v1',
  kind: 'Issuer',
  metadata: {
    name: 'kubernetes-dashboard-issuer',
    namespace: 'kubernetes-dashboard'
  },
  spec: {
    acme: {
      // server: 'https://acme-v02.api.letsencrypt.org/directory',
      // 触发限速，改为非生产域名。
      server: 'https://acme-staging-v02.api.letsencrypt.org/directory',
      email: 'whh881114@gmail.com',
      privateKeySecretRef: {
        name: 'kubernetes-dashboard-key'
      },
      solvers: [
        {
          selector: {
            dnsZones: [
              'kubernetes-dashboard.idc-ingress-nginx-lan.roywong.work'
            ]
          },
          dns01: {
            cloudflare: {
              apiTokenSecretRef: {
                name: 'cloudflare-api-token-secret',
                key: 'api-token'      # 使用cloudflare时，api-token对应着cloudflare-api-token-secret中的stringData中的'api-token'。
              }
            }
          }
        }
      ]
    }
  }
}