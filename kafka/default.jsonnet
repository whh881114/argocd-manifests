local clusterParams = import '../clusterParams.libsonnet';
local defaultVars = import '../_templates/kafka/vars.libsonnet';
local Kafka = import '../_templates/kafka/index.libsonnet';

local appName = 'default';

local instanceVars = {
  name: appName,
  clusterID: '4L6g3nShT-eMCtK--X86sw',
  ingress: [
    {host: 'kafka-console' + clusterParams.ingressNginxLanDomainName, serviceName: appName + '-console', servicePortNumber: 8080, path: '/'},
  ],
};

local app = std.mergePatch(defaultVars, instanceVars);

Kafka(app)
