local template = import '../../out-of-the-box/mysql/main.libsonnet';
local instances = import './instances.libsonnet';

std.flattenArrays(
  [
    template(i)
    for i in instances
  ]
)