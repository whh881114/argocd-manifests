{
  registry: 'harbor.idc.roywong.work',
  ingressNginxLanDomainName: '.idc-ingress-nginx-lan.roywong.work',
  ingressNginxWanDomainName: '.idc-ingress-nginx-wan.roywong.work',
  istiogatewayLanDomainName: '.idc-istio-gateway-lan.roywong.work',
  istiogatewayWanDomainName: '.idc-istio-gateway-wan.roywong.work',

  ingressNginxLanClassName: 'ingress-nginx-lan',
  ingressNginxWanClassName: 'ingress-nginx-wan',

  appRootDir: 'argocd-manifests',

  repo: {
    url: 'git@github.com:whh881114/learning.git',
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
    name: 'roywong-work-tls',
    namespace: 'cert-manager',
    apiTokenSecret: 'cloudflare-api-token-secret',
    clusterIssuerName: self.name + '-cluster-issuer',
    clusterIssuerSecret: self.name + '-key',
    certificateName: self.name + '-certificate',
    certificateSecret: self.name + '-cert',
    dnsZones: [
      '*.idc-ingress-nginx-lan.roywong.work',
      '*.idc-ingress-nginx-wan.roywong.work',
      '*.idc-istio-gateway-lan.roywong.work',
      '*.idc-istio-gateway-wan.roywong.work',
    ],
  },
}
