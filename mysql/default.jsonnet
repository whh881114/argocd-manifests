local clusterParams = import '../clusterParams.libsonnet';
local defaultVars = import '../_templates/mysql/vars.libsonnet';
local Mysql = import '../_templates/mysql/index.libsonnet';

local instanceVars = {
  name: 'default',
  password: 'nx4miofxxo.iq<rexztoQ,g1eyydfGoi',
};

local app = std.mergePatch(defaultVars, instanceVars);

Mysql(app)
