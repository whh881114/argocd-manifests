local clusterParams = import '../clusterParams.libsonnet';
local defaultVars = import '../_templates/mysql/vars.libsonnet';
local Mysql = import '../_templates/mysql/index.libsonnet';

local instanceVars = {
  name: 'zabbix-slave',
  password: '5aoGeawuesfaekowzwrsJ<a6talmreag',
  configFile: 'zabbix_slave',
  storageClassCapacity: '100Gi',
};

local app = std.mergePatch(defaultVars, instanceVars);

Mysql(app)
