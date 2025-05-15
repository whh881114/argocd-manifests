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