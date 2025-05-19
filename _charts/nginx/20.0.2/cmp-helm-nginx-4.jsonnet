local clusterParams = import '../../../clusterParams.libsonnet';

local fileName = std.thisFile;
local appName = std.strReplace(fileName, ".jsonnet", "");

{
  global: {
    imageRegistry: clusterParams.registry,
    security: {
      allowInsecureImages: true,
    }
  },
  nameOverride: appName,
  fullnameOverride: appName,
  namespaceOverride: 'nginx',
  image: {
    repository: 'docker.io/bitnami/nginx',
    tag: '1.28.0-debian-12-r0',
  },
  replicaCount: 1,
  service: {
    type: 'ClusterIP',
  }
}