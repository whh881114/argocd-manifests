local clusterParams = import '../../clusterParams.libsonnet';


function(app)
  local mysqldExporterContainer = {
    name: 'mysqld-expoter',
    image: clusterParams.registry + '/docker.io/bitnami/mysqld-exporter:0.15.1',
    imagePullPolicy: app.imagePullPolicy,
	  env: [
	    { name: "MYSQLD_EXPORTER_PASSWORD", value: app.exporter.password }
	  ],
	  args: [
	    '--collect.info_schema.innodb_metrics',
      '--collect.info_schema.tables',
      '--collect.info_schema.processlist',
      '--collect.info_schema.tables.databases=*',
	    '--mysqld.username=%s' % app.exporter.username,
	  ],
    ports: [{name: 'metrics', containerPort: 9104}],
  };

  local mysqlStatefulSet = {
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
                name: 'mysql',
                image: app.image,
                imagePullPolicy: app.imagePullPolicy,
                env: [
                  {name: 'MYSQL_ROOT_PASSWORD', value: app.password},
                ] + app.env,
                ports: [{name: 'mysql', containerPort: 3306}],
                resources: app.resources,
                volumeMounts: [
                  {name: 'conf', mountPath: '/etc/my.cnf', subPath: 'my.cnf', readOnly: true},
                  {name: 'data', mountPath: '/var/lib/mysql'},
                ],
              }, mysqldExporterContainer
            ],
            volumes: [
              {name: 'conf', configMap: {name: app.name}},
              {name: 'data', persistentVolumeClaim: {claimName: 'data-' + app.name}},
            ],
          },
        },
      },
    };

  mysqlStatefulSet