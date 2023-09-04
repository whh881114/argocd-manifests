local template = import '../main.libsonnet';
local instances = import './instances.libsonnet';

std.flattenArrays(
  [
    template(i)
    for i in instances
  ]
)