local clusterParams = import '../clusterParams.libsonnet';

{
  apiVersion: 'cert-manager.io/v1',
  kind: 'ClusterIssuer',
  metadata: {
    name: clusterParams.tls.cloudflare.clusterIssuer,
    namespace: 'cert-manager'
  },
  spec: {
    acme: {
      server: 'https://acme-v02.api.letsencrypt.org/directory',
      email: 'whh881114@gmail.com',
      privateKeySecretRef: {
        name: clusterParams.tls.cloudflare.clusterIssuerPrivateKeySecret,
      },
      solvers: [
        {
          selector: {
            dnsZones: clusterParams.tls.cloudflare.dnsZones,
          },
          dns01: {
            cloudflare: {
              apiTokenSecretRef: {
                name: clusterParams.tls.cloudflare.apiTokenSecret,
                key: 'api-token'      # 使用cloudflare时，api-token对应着cloudflare-api-token-secret中的stringData中的'api-token'。
              }
            }
          }
        }
      ]
    }
  }
}