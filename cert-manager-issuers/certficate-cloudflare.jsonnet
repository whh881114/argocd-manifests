local clusterParams = import '../clusterParams.libsonnet';


{
  apiVersion: 'cert-manager.io/v1',
  kind: 'Certificate',
  metadata: {
    name: clusterParams.tls.certificateName,
    namespace: clusterParams.tls.namespace,
  },
  spec: {
    secretName: clusterParams.tls.certificateSecret,
    issuerRef: {
      kind: 'ClusterIssuer',
      name: clusterParams.tls.clusterIssuerName,
    },
    dnsNames: clusterParams.tls.dnsZones
  }
}
