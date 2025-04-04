local clusterParams = import '../clusterParams.libsonnet';
local defaultVars = import '../_templates/rocketmq/vars.libsonnet';
local Rocketmq = import '../_templates/rocketmq/index.libsonnet';

local instanceVars = {
	name: 'default',
};

local app = std.mergePatch(defaultVars, instanceVars);

Rocketmq(app)
