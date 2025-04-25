local clusterParams = import '../../clusterParams.libsonnet';

{
  namespace: 'zookeeper',
  image: clusterParams.registry + '/docker.io/zookeeper:3.9.2',
  imagePullPolicy: 'IfNotPresent',

  replicas: 3,
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

  storageClassName: 'infra',
  storageClassCapacity: '10Gi',

  configFile: 'default',

  // requiredDuringSchedulingIgnoredDuringExecution.matchExpressions
  schedulers: [
      {key: 'pool', operator: 'In', values: ['middleware']},
  ],

  tolerations: [
    {key: 'pool', operator: 'Equal', value: 'middleware', effect: 'NoSchedule'}
  ],
}