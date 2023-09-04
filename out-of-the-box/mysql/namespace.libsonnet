local vars = import './vars.libsonnet';


function(instance)
  local namespace = if 'namespace' in instance then instance.namespace else vars.namespace;

  local item = {
    apiVersion: "v1",
     kind: "Namespace",
     metadata: {
        name: namespace,
     },
  };

  item