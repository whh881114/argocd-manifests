local func_vars = import './vars.libsonnet';


function(instance)
  local vars = func_vars(instance);

  local item = {
    apiVersion: 'apps/v1',
    kind: 'StatefulSet',
    metadata: {
      name: instance.name,
      namespace: vars.namespace,
      labels: { app: instance.name },
    },
    spec: {
      serviceName: instance.name,
      replicas: vars.replicas,
      selector: { matchLabels: { app: instance.name } },
      template: {
        metadata: {
          labels: { app: instance.name },
        },
        spec: {
          containers: [{
            name: 'jenkins',
            image: vars.image,
            imagePullPolicy: vars.image_pull_policy,
            env: [
              { name: 'TZ', value: 'Asia/Shanghai' },
              { name: 'JAVA_OPTS', value: '-javaagent:/lib/jmx_prometheus_javaagent.jar=60030:/etc/jmx-cfg.yml'},
            ],
            ports: vars.container_ports,
            resources: {
              requests: {
                cpu: vars.requests_cpu,
                memory: vars.requests_memory,
              },
              limits: {
                cpu: vars.limits_cpu,
                memory: vars.limits_memory,
              },
            },
            volumeMounts: [
              { name: 'data', mountPath: '/var/jenkins_home' },
            ],
          }],
          volumes: [
            { name: 'data', persistentVolumeClaim: { claimName: instance.name } },
          ]
        }
      }
    }
  };

  item