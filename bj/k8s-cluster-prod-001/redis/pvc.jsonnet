local vars = import './vars.libsonnet';
local standalone_instances = import './standalone/vars.libsonnet';
local cluster_instances = import './cluster/vars.libsonnet';


// pvcs变量值只针对cluster类型创建的pvc，这样的for循环的值只能渲染给变量。
local cluster_pvcs = [
  {
    apiVersion: "v1",
    kind: "PersistentVolumeClaim",
    metadata: {
      name: "data-%s-cluster-%d" % [instance['name'], num],
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

  for instance in cluster_instances['instances']
  for num in std.range(1, instance['replicas'])
];


// standalone是固定不变的，所以这里不需要来定义变量。
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
] + cluster_pvcs