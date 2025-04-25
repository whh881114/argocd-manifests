local clusterParams = import '../../clusterParams.libsonnet';

{
	rocketmqVersion: '4.9.7',
  image: clusterParams.registry + '/docker.io/apache/rocketmq:' + self.rocketmqVersion,
  imagePullPolicy: 'IfNotPresent',
  ingressClassName: clusterParams.ingressNginxLanClassName,
  namespace: 'rocketmq',

  storageClassName: 'infra',
  dataStorageClassCapacity: '100Gi',
  logsStorageClassCapacity: '20Gi',

  // requiredDuringSchedulingIgnoredDuringExecution.matchExpressions
  schedulers: [
      {key: 'pool', operator: 'In', values: ['middleware']},
  ],

  tolerations: [
    {key: 'pool', operator: 'Equal', value: 'middleware', effect: 'NoSchedule'}
  ],

	nameSrv: {
		env: [
			{name: 'NODE_ROLE', value: 'nameserver'},
		],
		replicas: 2,
	  resources: {
	    requests: {
	      cpu: '100m',
	      memory: '128Mi',
	    },
	    limits: {
	      cpu: '2000m',
	      memory: '4Gi',
	    }
	  },
  },

	broker: {
		env: [
			{name: 'NODE_ROLE', value: 'broker'},
		],
	  resources: {
	    requests: {
	      cpu: '100m',
	      memory: '128Mi',
	    },
	    limits: {
	      cpu: '8000m',
	      memory: '16Gi',
	    }
	  },
	},

  brokerM1: {
		name: 'broker-m1',
		replicas: 1,
		configFile: 'brokerM1',
	},
	brokerS1: {
		name: 'broker-s1',
		replicas: 1,
		configFile: 'brokerS1',
	},
	brokerM2: {
		name: 'broker-m2',
		replicas: 1,
		configFile: 'brokerM2',
	},
	brokerS2: {
		name: 'broker-s2',
		replicas: 1,
		configFile: 'brokerS2',
	},

	console: {
		image: clusterParams.registry + '/docker.io/styletang/rocketmq-console-ng:1.0.0',
		replicas: 1,
	  resources: {
	    requests: {
	      cpu: '100m',
	      memory: '128Mi',
	    },
	    limits: {
	      cpu: '1000m',
	      memory: '1Gi',
	    }
	  },
  },

}

