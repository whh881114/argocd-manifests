local vars = import './vars.libsonnet';


[
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
          containers: [{
            name: "jenkins",
            image: if 'image' in instance && 'image_tag' in instance then "%s:%s" % [ instance[ 'image' ], instance[ 'image_tag' ] ]
                     else "%s:%s" % [ vars[ 'image' ], vars[ 'image_tag' ] ],
            env: [
              { name: "TZ", value: "Asia/Shanghai" },
            ],
            args: ["-javaagent:/lib/jmx_prometheus_javaagent.jar=60030:/etc/jmx-cfg.yml"],
            ports: vars['container_ports'],
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
            volumeMounts: [
              { name: "data", mountPath: "/var/jenkins_home" },
            ],
          }],
          volumes: [
            { name: "data", persistentVolumeClaim: { claimName: "data-%s" % instance[ 'name' ] } },
          ]
        }
      }
    }
  }

  for instance in vars['instances']
]
