local clusterParams = import '../clusterParams.libsonnet';


{
  apiVersion: 'cert-manager.io/v1',
  kind: 'Certificate',
  metadata: {
    name: clusterParams.tls.cloudflare.clusterCertificate,
    namespace: clusterParams.tls.cloudflare.namespace,
  },
  spec: {
    secretName: clusterParams.tls.cloudflare.clusterCertificateSecret,
    issuerRef: {
      kind: 'ClusterIssuer',
      name: clusterParams.tls.cloudflare.clusterIssuer,
    },
    dnsNames: clusterParams.tls.cloudflare.dnsZones
  }
}
