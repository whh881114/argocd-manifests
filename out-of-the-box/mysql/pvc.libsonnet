local vars = import './vars.libsonnet';


function(instance)
  local item = {
    apiVersion: 'v1',
    kind: 'PersistentVolumeClaim',
    metadata: {
      name: instance.name,
      namespace: vars.namespace,
      labels: {app: instance.name},
    },
    spec: {
      accessModes: ['ReadWriteOnce'],
      resources: {
        requests: { storage: if 'storageclass_capacity' in instance then instance.storageclass_capacity else vars.storageclass_capacity }
      },
      storageClassName: if 'storageclass_name' in instance then instance.storageclass_name else vars.storageclass_name,
    }
  };

  item