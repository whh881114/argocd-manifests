local clusterParams = import '../../../clusterParams.libsonnet';

{
  global: {
    imageRegistry: clusterParams.registry,
    security: {
      allowInsecureImages: true,
    }
  },
  nameOverride: 'jsonnet-nginx-1',
  fullnameOverride: 'jsonnet-nginx-1',
  namespaceOverride: 'nginx',
  image: {
    repository: 'docker.io/nginx',
    tag: '1.27.1',
  },
  replicaCount: 1,
  containerPorts: {
    http: 80,
  },
  service: {
    type: 'ClusterIP',
  }
}