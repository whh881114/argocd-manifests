local vars = import './vars.libsonnet';
local standalone_instances = import './standalone/vars.libsonnet';
local cluster_instances = import './cluster/vars.libsonnet';


local init_containers = [
  {
    name: "sysctl",
    image: "harbor.freedom.org/docker.io/busybox:1.31.1",
    command: ["sysctl"],
    args: ["-w", "net.core.somaxconn=65535"],
    securityContext: {privileged: true},
  },
  {
    name: "disable-transparent-hugepage",
    image: "harbor.freedom.org/docker.io/busybox:1.31.1",
    command: ["sh", "-c", "echo never > /host-sys/kernel/mm/transparent_hugepage/enabled"],
    securityContext: {privileged: true},
    volumeMounts: [{name: "host-sys", mountPath: "/host-sys"}]
  },
];


local standalones =[
  {
    apiVersion: "apps/v1",
    kind: "StatefulSet",
    metadata: {
      name: instance[ 'name' ],
      namespace: vars[ 'namespace' ],
      labels: { app: instance[ 'name' ] },
    },
    spec: {
      serviceName: instance[ 'name' ],
      replicas: if 'replicas' in instance then instance[ 'replicas' ] else vars[ 'replicas' ],
      selector: { matchLabels: { app: instance[ 'name' ] } },
      template: {
        metadata: {
          labels: { app: instance[ 'name' ] },
        },
        spec: {
          initContainers: init_containers,
          containers: [
            {
              name: redis,
              image: if 'image' in instance && 'image_tag' in instance then "%s:%s" % [ instance[ 'image' ], instance[ 'image_tag' ] ]
                       else "%s:%s" % [ vars[ 'image' ], vars[ 'image_tag' ] ],
              env: [
                { name: "TZ", value: "Asia/Shanghai" },
              ],
              ports: standalone_instances['container_ports'],
              resources: {
                requests: {
                  cpu: if 'requests_cpu' in instance then instance[ 'requests_cpu' ] else vars[ 'requests_cpu' ],
                  memory: if 'requests_memory' in instance then instance[ 'requests_memory' ] else vars[ 'requests_memory' ],
                },
                limits: {
                  cpu: if 'limits_cpu' in instance then instance[ 'limits_cpu' ] else vars[ 'limits_cpu' ],
                  memory: if 'limits_memory' in instance then instance[ 'limits_memory' ] else vars[ 'limits_memory' ],
                },
              },
              command: ["redis-server"],
              args: ["/usr/local/etc/redis/redis.conf"],
              volumeMounts: [
                { name: "conf", mountPath: "/usr/local/etc/redis/", readOnly: true },
                { name: "data", mountPath: "/data" },
              ],
            },
          ],
          volumes: [
            { name: "conf", configMap: { name: instance[ 'name' ] } },
            { name: "host-sys", hostPath: { path: "/sys" }},
            { name: "data", persistentVolumeClaim: { claimName: "data-%s" % instance[ 'name' ] } },
          ]
        },
      }
    }
  }

  for instance in standalone_instances['instances']
];



local clusters =[
  {
    apiVersion: "apps/v1",
    kind: "StatefulSet",
    metadata: {
      name: "%s-cluster" % instance['name'],
      namespace: vars[ 'namespace' ],
      labels: { app: "%s-cluster" % instance['name'] },
    },
    spec: {
      serviceName: "%s-cluster" % instance['name'],
      replicas: instance['replicas'],
      selector: { matchLabels: { app: "%s-cluster" % instance['name'] } },
      template: {
        metadata: {
          labels: { app: "%s-cluster" % instance['name'] },
        },
        spec: {
          initContainers: init_containers,
          containers: [
            {
              name: redis,
              image: if 'image' in instance && 'image_tag' in instance then "%s:%s" % [ instance[ 'image' ], instance[ 'image_tag' ] ]
                       else "%s:%s" % [ vars[ 'image' ], vars[ 'image_tag' ] ],
              env: [
                { name: "TZ", value: "Asia/Shanghai" },
              ],
              ports: cluster_instances['container_ports'],
              resources: {
                requests: {
                  cpu: if 'requests_cpu' in instance then instance[ 'requests_cpu' ] else vars[ 'requests_cpu' ],
                  memory: if 'requests_memory' in instance then instance[ 'requests_memory' ] else vars[ 'requests_memory' ],
                },
                limits: {
                  cpu: if 'limits_cpu' in instance then instance[ 'limits_cpu' ] else vars[ 'limits_cpu' ],
                  memory: if 'limits_memory' in instance then instance[ 'limits_memory' ] else vars[ 'limits_memory' ],
                },
              },
              command: ["/bin/update_nodes_conf.sh", "redis-server"],
              args: ["/usr/local/etc/redis/redis.conf"],

              // 进入交互式shell
              // command: ["/bin/bash"],
              // args: ["-i"],
              // tty: true,
              volumeMounts: [
                { name: "conf", mountPath: "/usr/local/etc/redis/", readOnly: true },
                { name: "data", mountPath: "/data" },
                { name: "update-nodes-conf", mountPath: "/bin/update_nodes_conf.sh", subPath: "update_nodes_conf.sh", readOnly: true },
              ],
            },
          ],
          volumes: [
            { name: "conf", configMap: { name: "%s-cluster" % instance['name'] } },
            { name: "update-nodes-conf", configMap: { name: "update-nodes-conf", items: [{key: "update_nodes_conf.sh", path: "update_nodes_conf.sh", mode: 493}] } },   // 0755（八进制） --> 493（十进制）
            { name: "host-sys", hostPath: { path: "/sys" }},
          ]
        },
      },
    volumeClaimTemplates: [
          {
            metadata: {
              name: "data",
              annotations: {
                "volume.beta.kubernetes.io/storage-class": if 'storage_class' in instance then instance[ 'storage_class' ] else vars[ 'storage_class' ]
              },
            },
            spec: {
              accessModes: [ "ReadWriteOnce" ],
              resources: { requests: { storage: if 'storage_class_capacity' in instance then instance[ 'storage_class_capacity' ] else vars[ 'storage_class_capacity' ] } }
            }
          }
        ]
    }
  }

  for instance in cluster_instances['instances']
];




standalones + clusters