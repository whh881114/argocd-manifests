local clusterParams = import '../clusterParams.libsonnet';
local defaultVars = import '../_templates/rocketmq/vars.libsonnet';
local Rocketmq = import '../_templates/rocketmq/index.libsonnet';

local appName = 'default';

local instanceVars = {
  name: appName,
  ingress: [
    {host: 'rocketmq-console' + clusterParams.ingressNginxLanDomainName, serviceName: appName + '-console', servicePortNumber: 8080, path: '/'},
  ],
};

local app = std.mergePatch(defaultVars, instanceVars);

Rocketmq(app)