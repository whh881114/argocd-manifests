local clusterParams = import '../../clusterParams.libsonnet';


function(app)
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
			      name: 'JAVA_OPTS',
			      value: '-Drocketmq.namesrv.addr=%s-namesrv-0:9876;%s-namesrv-1:9876; -Dcom.rocketmq.sendMessageWithVIPChannel=false -Duser.timezone="Asia/Shanghai"' % [ app.name, app.name]
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
