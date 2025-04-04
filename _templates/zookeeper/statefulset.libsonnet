local clusterParams = import '../../clusterParams.libsonnet';


function(app)
  // 改写command参数，启动服务前生成myid文件。
  local command = ['sh', '-c', '/bin/myid.sh && zkServer.sh start-foreground'];

  local zookeeperStatefulset = {
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
          containers: [
            {
              name: 'zookeeper',
              image: app.image,
              env: [
                {name: 'TZ', value: 'Asia/Shanghai'},
              ],
              command: command,
              ports: [
                {name: 'client', containerPort: 2181},
                {name: 'server', containerPort: 2888},
                {name: 'leader-election', containerPort: 3888},
              ],
              resources: app.resources,
              volumeMounts: [
                {name: 'conf', mountPath: '/conf', readOnly: true},
                {name: 'myid', mountPath: '/bin/myid.sh', subPath: 'myid.sh', readOnly: true},
                {name: 'data', mountPath: '/data', subPath: 'data'},
                {name: 'data', mountPath: '/datalog', subPath: 'datalog'},
                {name: 'data', mountPath: '/logs', subPath: 'logs'},
              ],
            },
          ],
          volumes: [
            {name: 'conf', configMap: { name: app.name, items: [{key: 'zoo.cfg', path: 'zoo.cfg', mode: 420}]}},
            {name: 'myid', configMap: { name: app.name, items: [{key: 'myid.sh', path: 'myid.sh', mode: 493}]}},
          ]
        },
      },
      volumeClaimTemplates: [
        {
          metadata: {
            name:  'data',
          },
          spec: {
            accessModes: ['ReadWriteOnce'],
            resources: {
              requests: {storage: app.storageClassCapacity},
            },
            storageClassName: app.storageClassName,
          },
        },
      ],
    },
  };

  [zookeeperStatefulset]
