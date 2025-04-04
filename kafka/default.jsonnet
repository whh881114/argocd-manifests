local clusterParams = import '../clusterParams.libsonnet';
local defaultVars = import '../_templates/kafka/vars.libsonnet';
local Kafka = import '../_templates/kafka/index.libsonnet';

local instanceVars = {
  name: 'default',
  clusterID: '4L6g3nShT-eMCtK--X86sw',
};

local app = std.mergePatch(defaultVars, instanceVars);

Kafka(app)
