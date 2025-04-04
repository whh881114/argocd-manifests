local clusterParams = import '../../clusterParams.libsonnet';


function(app)
	// KAFKA_BROKERS: default-broker-i:9092,default-broker-1:9092,default-broker-2:9092
  local KAFKA_BROKERS = [
    app.name + '-broker-%s:9092' % i
    for i in std.range(0, app.broker.replicas-1)
  ];

	local consoleDeployment = {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      name: app.name + '-console',
      labels: {app: app.name + '-console'},
    },
    spec: {
      replicas: 1,
      selector: {matchLabels: {app: app.name + '-console'}},
      template: {
        metadata: {
          labels: {app: app.name + '-console'},
        },
        spec: {
          imagePullSecrets: clusterParams.imagePullSecrets,
          containers: [
            {
              name: 'console',
              image: app.console.image,
              imagePullPolicy: app.imagePullPolicy,
              env: [
								{
									name: 'KAFKA_BROKERS',
									value: std.join(",", KAFKA_BROKERS),
								}
							],
              ports: [{name: 'console', containerPort: 8080}],
              resources: app.console.resources,
              volumeMounts: [
                {name: 'localtime', mountPath: '/etc/localtime', readOnly: true},
              ],
            }
          ],
          volumes: [
            {name: 'localtime', hostPath: {path: '/etc/localtime', type: 'File'}},
          ],
        },
      },
    }
	};

	[consoleDeployment]
