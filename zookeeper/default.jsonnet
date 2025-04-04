local clusterParams = import '../clusterParams.libsonnet';
local defaultVars = import '../_templates/zookeeper/vars.libsonnet';
local Zookeeper = import '../_templates/zookeeper/index.libsonnet';

local instanceVars = {
  name: 'default',
};

local app = std.mergePatch(defaultVars, instanceVars);

Zookeeper(app)
