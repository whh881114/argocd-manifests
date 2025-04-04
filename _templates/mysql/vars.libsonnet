local clusterParams = import '../../clusterParams.libsonnet';

{
  password: 'pliyzKekvzas3aim[np~mfwzk7E=rkxk',
  configFile: 'default',
  storageClassName: 'mysql',
  storageClassCapacity: '50Gi',

  image: clusterParams.registry + '/docker.io/mysql:8.0.39',
  imagePullPolicy: 'IfNotPresent',

  env: [],

  replicas: 1,

  resources: {
    requests: {
      cpu: '1000m',
      memory: '1Gi',
    },
    limits: {
      cpu: '4000m',
      memory: '8Gi',
    }
  },

  exporter: {
    username: 'exporter',
    password: 'pJwtdho13jLipiyquxldnqialgrpkvl~',
  },
}