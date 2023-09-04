local default_vars = import './default_vars.libsonnet';

function(instance)
  local item = {
    namespace: if 'namespace' in instance then instance.namespace else default_vars.namespace,
    image: if 'image' in instance then instance.image else default_vars.image,
    image_pull_policy: if 'image_pull_policy' in instance then instance.image_pull_policy else default_vars.image_pull_policy,

    replicas: if 'replicas' in instance then instance.replicas else default_vars.replicas,
    requests_cpu: if 'requests_cpu' in instance then instance.requests_cpu else default_vars.requests_cpu,
    requests_memory: if 'requests_memory' in instance then instance.requests_memory else default_vars.requests_memory,
    limits_cpu: if 'limits_cpu' in instance then instance.limits_cpu else default_vars.limits_cpu,
    limits_memory: if 'limits_memory' in instance then instance.limits_memory else default_vars.limits_memory,

    container_ports: if 'container_ports' in instance then instance.container_ports else default_vars.container_ports,

    storageclass_name: if 'storageclass_name' in instance then instance.storageclass_name else default_vars.storageclass_name,
    storageclass_capacity: if 'storageclass_capacity' in instance then instance.storageclass_capacity else default_vars.storageclass_capacity,
  };

  item