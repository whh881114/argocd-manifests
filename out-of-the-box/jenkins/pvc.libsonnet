local func_vars = import './vars.libsonnet';


function(instance)
  local vars = func_vars(instance);

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
        requests: { storage: vars.storageclass_capacity }
      },
      storageClassName: vars.storageclass_name,
    }
  };

  item