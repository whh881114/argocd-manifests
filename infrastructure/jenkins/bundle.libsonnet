local template = import '../../out-of-the-box/jenkins/main.libsonnet';
local instances = import './instances.libsonnet';

std.flattenArrays(
  [
    template(i)
    for i in instances
  ]
)