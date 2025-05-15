local clusterParams = import '../../../clusterParams.libsonnet';

{
  global: {
    imageRegistry: clusterParams.registry,
    security: {
      allowInsecureImages: true,
    }
  },
  nameOverride: 'jsonnet-nginx-3',
  fullnameOverride: 'jsonnet-nginx-3',
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