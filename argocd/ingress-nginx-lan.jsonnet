local clusterParams = import '../clusterParams.libsonnet';
local Ingress = import '../_templates/_ingress_nginx/index.libsonnet';

local appName = 'argocd-server';
local app = {
  name: appName,
  ingressClassName: clusterParams.ingressNginxLanDomainName,
  ingress: {
    rules: [{hostname: appName + clusterParams.ingressNginxLanDomainName, serviceName: appName, servicePortNumber: 80, path: '/'},],
  },
};

Ingress(app)

