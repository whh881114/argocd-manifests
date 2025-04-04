local clusterParams = import '../../clusterParams.libsonnet';

{
	namespace: 'kafka',
  image: clusterParams.registry + '/docker.io/apache/kafka:3.8.0',
  imagePullPolicy: 'IfNotPresent',
  ingressClassName: clusterParams.ingressNginxLanClassName,

  storageClassName: 'infra',
  storageClassCapacity: '100Gi',

	// 日志目录，其实就是kafka的数据目录，所以将kafkaLogDirs变量修改为kafkaDataDir，同时指定默认值。
  // kafkaLogDirs: '/tmp/kraft-combined-logs',
  kafkaDataDir: '/var/lib/kafka/data',

  controller: {
    env: [
      {name: 'KAFKA_PROCESS_ROLES',                             value: 'controller'},
      {name: 'KAFKA_INTER_BROKER_LISTENER_NAME',                value: 'PLAINTEXT'},
      {name: 'KAFKA_CONTROLLER_LISTENER_NAMES',                 value: 'CONTROLLER'},
      {name: 'KAFKA_LISTENERS',                                 value: 'CONTROLLER://:9093'},
      {name: 'KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR',          value: '1'},
      {name: 'KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS',          value: '0'},
      {name: 'KAFKA_TRANSACTION_STATE_LOG_MIN_ISR',             value: '1'},
      {name: 'KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR',  value: '1'},
    ],
    replicas: 3,
    resources: {
	    requests: {
	      cpu: '1000m',
	      memory: '2Gi',
	    },
	    limits: {
	      cpu: '2000m',
	      memory: '4Gi',
	    }
    },
  },

  broker: {
    env: [
      {name: 'KAFKA_PROCESS_ROLES',                             value: 'broker'},
      {name: 'KAFKA_LISTENERS',                                 value: 'PLAINTEXT://:19092,PLAINTEXT_HOST://:9092'},
      {name: 'KAFKA_LISTENER_SECURITY_PROTOCOL_MAP',            value: 'CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT'},
      {name: 'KAFKA_INTER_BROKER_LISTENER_NAME',                value: 'PLAINTEXT'},
      {name: 'KAFKA_CONTROLLER_LISTENER_NAMES',                 value: 'CONTROLLER'},
      {name: 'KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR',          value: '1'},
      {name: 'KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS',          value: '0'},
      {name: 'KAFKA_TRANSACTION_STATE_LOG_MIN_ISR',             value: '1'},
      {name: 'KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR',  value: '1'},
    ],
    replicas: 3,
    resources: {
	    requests: {
	      cpu: '2000m',
	      memory: '4Gi',
	    },
	    limits: {
	      cpu: '8000m',
	      memory: '16Gi',
	    }
    },
  },

  console: {
    image: clusterParams.registry + '/docker.io/redpandadata/console:v2.7.2',
    resources: {
	    requests: {
	      cpu: '100m',
	      memory: '256Mi',
	    },
	    limits: {
	      cpu: '1000m',
	      memory: '2Gi',
	    }
    },
  },
}

