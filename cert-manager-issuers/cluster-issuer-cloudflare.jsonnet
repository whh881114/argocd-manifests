local clusterParams = import '../clusterParams.libsonnet';

{
  apiVersion: 'cert-manager.io/v1',
  kind: 'ClusterIssuer',
  metadata: {
    name: clusterParams.tls.clusterIssuerName,
    namespace: 'cert-manager'
  },
  spec: {
    acme: {
      server: 'https://acme-v02.api.letsencrypt.org/directory',
      email: 'whh881114@gmail.com',
      privateKeySecretRef: {
        name: clusterParams.tls.clusterIssuerSecret
      },
      solvers: [
        {
          selector: {
            dnsZones: clusterParams.tls.dnsZones
          },
          dns01: {
            cloudflare: {
              apiTokenSecretRef: {
                name: clusterParams.tls.apiTokenSecret,
                key: 'api-token'      # 使用cloudflare时，api-token对应着cloudflare-api-token-secret中的stringData中的'api-token'。
              }
            }
          }
        }
      ]
    }
  }
}