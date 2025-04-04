local clusterParams = import '../../clusterParams.libsonnet';


function(app)
  local initContainers = [
    {
      name: 'sysctl',
      image: clusterParams.registry + '/docker.io/busybox:1.31.1',
      imagePullPolicy: app.imagePullPolicy,
      command: ['sysctl'],
      args: ['-w', 'net.core.somaxconn=65535'],
      securityContext: {privileged: true},
    },
    {
      name: 'disable-transparent-hugepage',
      image: clusterParams.registry + '/docker.io/busybox:1.31.1',
      imagePullPolicy: app.imagePullPolicy,
      command: ['sh', '-c', 'echo never > /host-sys/kernel/mm/transparent_hugepage/enabled'],
      securityContext: {privileged: true},
      volumeMounts: [{name: 'host-sys', mountPath: '/host-sys'}]
    },
  ];
  
  local redisExporterContainer = {
    name: 'redis-expoter',
    image: clusterParams.registry + '/docker.io/bitnami/redis-exporter:1.62.0',
    imagePullPolicy: app.imagePullPolicy,
    env: [
      {name: 'REDIS_PASSWORD', value: app.password},
    ],
    ports: [{name: 'metrics', containerPort: 9121}],
  };

  local redisStatefulSet = {
      apiVersion: 'apps/v1',
      kind: 'StatefulSet',
      metadata: {
        name: app.name,
        labels: {app: app.name},
      },
      spec: {
        serviceName: app.name,
        replicas: app.replicas,
        selector: {matchLabels: {app: app.name}},
        template: {
          metadata: {
            labels: {app: app.name},
          },
          spec: {
            imagePullSecrets: clusterParams.imagePullSecrets,
            initContainers: initContainers,
            containers: [
              {
                name: 'redis',
                image: app.image,
                imagePullPolicy: app.imagePullPolicy,
                env: app.env,
                ports: [{name: 'redis', containerPort: 6379}],
                resources: app.resources,
                command: ['redis-server'],
                args: ['/usr/local/etc/redis/redis.conf'],
                volumeMounts: [
                  {name: 'conf', mountPath: '/usr/local/etc/redis/', readOnly: true},
                  {name: 'data', mountPath: '/data'},
                ],
              }, redisExporterContainer
            ],
            volumes: [
              {name: 'conf', configMap: {name: app.name}},
              {name: 'host-sys', hostPath: {path: '/sys'}},
              {name: 'data', persistentVolumeClaim: {claimName: 'data-' + app.name}},
            ],
          },
        },
      },
    };

  redisStatefulSet