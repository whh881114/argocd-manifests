local vars = import './vars.libsonnet';
local standalone_instances = import './standalone/vars.libsonnet';
local cluster_instances = import './cluster/vars.libsonnet';

local standalone_configmaps = [
  local conf_1 = if 'conf' in instance then instance['conf'] else standalone_instances['default_conf'];
  local conf_2 = std.strReplace(conf_1, "[indiviual_redis_password]", instance['password']);

  local memory = if 'memory' in instance then instance['memory'] else vars['limits_memory'];
  local conf = std.strReplace(conf_2, "[indiviual_redis_memory]", memory);

  {
    apiVersion: "v1",
    kind: "ConfigMap",
    metadata: {
      name: "%s" % instance['name'],
      namespace: vars['namespace'],
    },
    data: {
      "redis.conf": conf,
    }
  }

  for instance in standalone_instances['instances']
];

local cluster_configmaps = [
  local conf_1 = if 'conf' in instance then instance['conf'] else cluster_instances['default_conf'];
  local conf_2 = std.strReplace(conf_1, "[indiviual_redis_password]", instance['password']);

  local memory = if 'memory' in instance then instance['memory'] else vars['limits_memory'];
  local conf = std.strReplace(conf_2, "[indiviual_redis_memory]", memory);

  {
    apiVersion: "v1",
    kind: "ConfigMap",
    metadata: {
      name: "%s-cluster" % instance['name'],
      namespace: vars['namespace'],
    },
    data: {
      "redis.conf": conf,
    }
  }

  for instance in cluster_instances['instances']
];

standalone_configmaps + cluster_configmaps