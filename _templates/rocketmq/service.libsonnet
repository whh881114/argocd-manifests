function(app)
	local serviceClusterNameSrv = [
		{
		  apiVersion: 'v1',
		  kind: 'Service',
		  metadata: {
		    name:  app.name + '-namesrv-' + i,
		    labels: {app: app.name + '-namesrv-' + i},
		  },
	    spec: {
	      selector: {app: app.name + '-namesrv-' + i},
	      type: 'ClusterIP',
	      ports: [
	        {
			      name: 'namesrv',
			      port: 9876,
			      targetPort: 9876,
	        },
	        {
			      name: 'metrics',
			      port: 5557,
			      targetPort: 5557,
	        },
	      ],
	    },
	  }
	  for i in std.range(0, app.nameSrv.replicas-1)
  ];

  local serviceNodePortNameSrv = [
	  {
		  apiVersion: 'v1',
		  kind: 'Service',
		  metadata: {
		    name:  app.name + '-namesrv-' + i + '-nodeport',
		    labels: {app: app.name + '-namesrv-' + i + '-nodeport'},
		  },
	    spec: {
	      selector: {app: app.name + '-namesrv-' + i},
	      type: 'NodePort',
	      ports: [
	        {
			      name: 'namesrv',
			      port: 9876,
			      targetPort: 9876,
	        },
	        {
			      name: 'metrics',
			      port: 5557,
			      targetPort: 5557,
	        },
	      ],
	    },
	  }
    for i in std.range(0, app.nameSrv.replicas-1)
  ];

	local serviceClusterBroker = [
		{
		  apiVersion: 'v1',
		  kind: 'Service',
		  metadata: {
		    name:  app.name + '-' + i,
		    labels: {app: app.name + '-' + i},
		  },
	    spec: {
	      selector: {app: app.name + '-' + i},
	      type: 'ClusterIP',
	      ports: [
	        //10909 端口
					//作用: 主要用于 Broker 之间的通信，特别是 Master 和 Slave 之间的同步。
					//用途:
					//数据同步: Master 节点将消息同步到 Slave 节点时，会使用这个端口。
					//心跳检测: Broker 节点之间会通过这个端口发送心跳包，监测彼此的状态。
	        {
			      name: 'fast',
			      port: 10909,
			      targetPort: 10909,
	        },
	        //10911 端口
					//作用: 用于处理 Producer 发送的消息，以及 Consumer 拉取消息的请求。
					//用途:
					//消息发送: Producer 将消息发送到 Broker 时，会连接到这个端口。
					//消息消费: Consumer 从 Broker 拉取消息时，也会连接到这个端口。
	        {
			      name: 'broker',
			      port: 10911,
			      targetPort: 10911,
	        },
					//10912 端口
					//作用: 主要用于 Broker 的 VIP 通道，即 VIP Channel。
					//用途:
					//高可用: 在高可用场景下，当 Master 节点故障时，Slave 节点可以快速切换为 Master，继续提供服务。VIP 通道可以保证 Producer
					//       和 Consumer 无感知地切换到新的 Master 节点。
	        {
			      name: 'ha',
			      port: 10912,
			      targetPort: 10912,
	        },
	      ],
	    },
	  }
	  for i in [app.brokerM1.name, app.brokerS1.name, app.brokerM2.name, app.brokerS2.name]
  ];

  local serviceNodePortBroker = [
	  {
		  apiVersion: 'v1',
		  kind: 'Service',
		  metadata: {
		    name:  app.name + '-' + i + '-nodeport',
		    labels: {app: app.name + '-' + i + '-nodeport'},
		  },
	    spec: {
	      selector: {app: app.name + '-' + i},
	      type: 'NodePort',
	      ports: [
	        {
			      name: 'fast',
			      port: 10909,
			      targetPort: 10909,
	        },
	        {
			      name: 'broker',
			      port: 10911,
			      targetPort: 10911,
	        },
	        {
			      name: 'ha',
			      port: 10912,
			      targetPort: 10912,
	        },
	      ],
	    },
	  }
	  for i in [app.brokerM1.name, app.brokerS1.name, app.brokerM2.name, app.brokerS2.name]
  ];

  local serviceClusterConsole = {
	  apiVersion: 'v1',
	  kind: 'Service',
	  metadata: {
	    name:  app.name + '-console',
	    labels: {app: app.name + '-console'},
	  },
    spec: {
      selector: {app: app.name + '-console'},
      type: 'ClusterIP',
      ports: [
        {
		      name: 'console',
		      port: 8080,
		      targetPort: 8080,
        },
      ],
    },
  };

  local serviceNodePortConsole = {
	  apiVersion: 'v1',
	  kind: 'Service',
	  metadata: {
	    name:  app.name + '-console-nodeport',
	    labels: {app: app.name + '-console-nodeport'},
	  },
    spec: {
      selector: {app: app.name + '-console'},
      type: 'NodePort',
      ports: [
        {
		      name: 'console',
		      port: 8080,
		      targetPort: 8080,
        },
      ],
    },
  };

  serviceClusterNameSrv +
  serviceNodePortNameSrv +
  serviceClusterBroker +
  serviceNodePortBroker +
  [serviceClusterConsole, serviceNodePortConsole]
