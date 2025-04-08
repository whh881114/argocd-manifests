{
  registry: 'harbor.idc.roywong.work',
  ingressNginxLanDomainName: '.idc-ingress-nginx-lan.roywong.work',
  ingressNginxWanDomainName: '.idc-ingress-nginx-wan.roywong.work',
  istiogatewayLanDomainName: '.idc-istio-gateway-lan.roywong.work',
  istiogatewayWanDomainName: '.idc-istio-gateway-wan.roywong.work',

  ingressNginxLanClassName: 'ingress-nginx-lan',
  ingressNginxWanClassName: 'ingress-nginx-wan',

  repo: {
    url: 'git@github.com:whh881114/argocd-manifests.git',
    branch: 'master',
  },

  argocdNamespace: 'argocd',

  imagePullSecrets: [
    {name: "docker-credential-harbor-idc-roywong-work"},
  ],

  // cert-manager相关变量
  repoSecrets: {
    url: 'git@github.com:whh881114/argocd-manifests-secrets.git',
    branch: 'master',
  },

  tls: {
    cloudflare: {
      name: 'roywong-work-tls',
      namespace: 'cert-manager',
      apiTokenSecret: 'cloudflare-api-token-secret',
      clusterIssuer: self.name + '-cluster-issuer',
      clusterIssuerPrivateKeySecret: self.name + '-private-key-secret',
      clusterCertificate: self.name + '-certificate',
      clusterCertificateSecret: self.name + '-certificate-secret',
      dnsZones: [
        '*.idc-ingress-nginx-lan.roywong.work',
        '*.idc-ingress-nginx-wan.roywong.work',
        '*.idc-istio-gateway-lan.roywong.work',
        '*.idc-istio-gateway-wan.roywong.work',
      ],
    },
  },
}
