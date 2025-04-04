local clusterParams = import '../clusterParams.libsonnet';
local defaultVars = import '../_templates/redis/vars.libsonnet';
local Redis = import '../_templates/redis/index.libsonnet';

local instanceVars = {
  name: 'default',
  password: 'sRvojqyud9dxyl|qExvbavusl:xr5tq!',
};

local app = std.mergePatch(defaultVars, instanceVars);

Redis(app)
