local clusterParams = import '../../clusterParams.libsonnet';

{
  password: 'lkizwhHnj5uu]yhrh+ryehfFv!7owtbc',
  configFile: 'default',
  storageClassName: 'redis',
  storageClassCapacity: '10Gi',

  image: clusterParams.registry + '/docker.io/redis:6.2.14',
  imagePullPolicy: 'IfNotPresent',

  env: [],

  replicas: 1,

  resources: {
    requests: {
      cpu: '100m',
      memory: '128Mi',
    },
    limits: {
      cpu: '1000m',
      memory: '1Gi',
    }
  },
}