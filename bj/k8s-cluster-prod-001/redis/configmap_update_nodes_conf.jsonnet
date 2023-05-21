local vars = import './vars.libsonnet';

{
  apiVersion: "v1",
  kind: "ConfigMap",
  metadata: {
    name: "update-nodes-conf",
    namespace: vars['namespace'],
  },
  data: {
    "update_node.sh": |||
      #!/bin/bash
      REDIS_NODES="/data/nodes.conf"
      sed -i -e "/myself/ s/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/${POD_IP}/" ${REDIS_NODES}
      exec "$@"
    |||,
  }
}