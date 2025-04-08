local clusterParams = import '../clusterParams.libsonnet';


{
  apiVersion: 'cert-manager.io/v1',
  kind: 'Certificate',
  metadata: {
    name: 'kubernetes-dashboard-issuer-certificate',
    namespace: 'kubernetes-dashboard',
  },
  spec: {
    secretName: 'kubernetes-dashboard-issuer-cert',
    issuerRef: {
      kind: 'Issuer',
      name: 'kubernetes-dashboard-issuer',
    },
    dnsNames: [
      'kubernetes-dashboard.idc-ingress-nginx-lan.roywong.work'
    ],
  }
}
