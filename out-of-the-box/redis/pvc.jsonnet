local vars = import './vars.libsonnet';
local standalone_instances = import './standalone/vars.libsonnet';


[
  {
    apiVersion: "v1",
    kind: "PersistentVolumeClaim",
    metadata: {
      name: "data-%s" % instance['name'],
      namespace: vars['namespace'],
    },
    spec: {
      accessModes: ["ReadWriteOnce"],
      resources: {
        requests: { storage: if 'storage_class_capacity' in instance then instance['storage_class_capacity'] else vars['storage_class_capacity'] }
      },
      storageClassName: if 'storage_class' in instance then instance[ 'storage_class' ] else vars[ 'storage_class' ],
    }
  }

  for instance in standalone_instances['instances']
]