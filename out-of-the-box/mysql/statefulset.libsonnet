local global_vars = import '../../global_vars.libsonnet';
local vars = import './vars.libsonnet';


function(instance)
  local namespace = if 'namespace' in instance then instance.namespace else vars.namespace;
  local mysql_root_password = if 'root_password' in instance then instance.root_password else vars.root_password;
  local mysql_conf = if 'conf' in instance then instance.conf else vars.conf;
  local mysqld_exporter_data_source_name = if 'mysqld_exporter_data_source_name' in instance then instance.mysqld_exporter_data_source_name else vars.mysqld_exporter_data_source_name;

  local item = {
    apiVersion: 'apps/v1',
    kind: 'StatefulSet',
    metadata: {
      name: instance.name,
      namespace: namespace,
      labels: { app: instance.name },
    },
    spec: {
      serviceName: instance.name,
      replicas: if 'replicas' in instance then instance.replicas else vars.replicas,
      selector: { matchLabels: { app: instance.name } },
      template: {
        metadata: {
          labels: { app: instance.name },
        },
        spec: {
          containers: [
            {
              name: 'mysqld-exporter',
              image: vars.mysqld_exporter_image,
              imagePullPolicy: global_vars.image_pull_policy,
            env: [
    { name: 'DATA_SOURCE_NAME', valueFrom: { configMapKeyRef: { name: instance.name, key: 'DATA_SOURCE_NAME' } } }
  ],
  ports: [
    { name: 'metrics', containerPort: 9104 }
  ]
},
            {
              name: 'mysql',
              image: if 'image' in instance && 'image_tag' in instance then '%s:%s' % [ instance[ 'image' ], instance[ 'image_tag' ] ]
                       else '%s:%s' % [ vars[ 'image' ], vars[ 'image_tag' ] ],
              env: [
                { name: 'TZ', value: 'Asia/Shanghai' },
                { name: 'MYSQL_ROOT_PASSWORD', valueFrom: { configMapKeyRef: { name: instance[ 'name' ], key: 'MYSQL_ROOT_PASSWORD' } } },
              ],
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
                { name: 'conf', mountPath: '/etc/mysql/conf.d', readOnly: true },
                { name: 'data', mountPath: '/var/lib/mysql' },
              ],
            },
          ],
          volumes: [
            { name: 'mysqld-exporter', configMap: { name: 'mysqld-exporter' } },
            { name: 'conf', configMap: { name: instance[ 'name' ] } },
            { name: 'data', persistentVolumeClaim: { claimName: 'data-%s' % instance[ 'name' ] } },
          ]
        }
      }
    }
  };

  item