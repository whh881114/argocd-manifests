local func_vars = import './vars.libsonnet';


function(instance)
  local vars = func_vars(instance);

  local item = {
    apiVersion: "v1",
     kind: "Namespace",
     metadata: {
        name: vars.namespace,
     },
  };

  item