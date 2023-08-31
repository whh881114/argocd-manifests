local global_vars = import '../../global_vars.libsonnet';
local vars = import './vars.libsonnet';

local ports = vars.container_ports;

local env = [{name: 'TZ', value: 'Asia/Shanghai'},
             {name: 'HOSTIP', valueFrom: {fieldRef: {fieldPath: 'status.hostIP'}}},
             {name: 'HOSTNAME', valueFrom: {fieldRef: {fieldPath: 'spec.nodeName'}}},
             {name: 'NAMESPACE', value: global_vars.consul_namespace},];
             # 使用jsonnet实现yaml渲染，此处不依赖于metadata.namespace变量值。
             # {name: 'NAMESPACE', valueFrom: {fieldRef: {fieldPath: 'metadata.namespace'}}},];

local args_retry_join = [
  '-retry-join=%s' % x for x in global_vars.consul_server_args_retry_json
];

local args_partial = [
  'agent',
  '-config-dir=/consul/config',
  '-log-level=debug',
  '-log-json',
  '-bind=0.0.0.0',
  '-client=0.0.0.0',
  '-advertise=$(HOSTIP)',
  '-disable-host-node-id',
  '-datacenter=%s' % global_vars.consul_datacenter,
  '-node=$(HOSTNAME)',
];

local args = args_partial + args_retry_join;


{
  apiVersion: 'apps/v1',
  kind: 'DaemonSet',
  metadata: {
    name: 'consul-agent',
    labels: {app: 'consul-agent'},
    },
  spec: {
    selector: {
      matchLabels: {app: 'consul-agent'}
    },
    template: {
      metadata: {
        name: 'consul-agent',
        labels: {app: 'consul-agent'},
      },
      spec: {
        initContainers: [{
          name: 'coredns',
          image: global_vars.busybox_image,
          imagePullPolicy: global_vars.image_pull_policy,
          command: [ 'sh', '-c', 'echo "nameserver %s" > /etc/resolv.conf' % global_vars.coredns_ip],
        }],
        containers:[{
          name: 'consul-agent',
          image: global_vars.consul_image,
          env: env,
          args: args,
          ports: ports,
          imagePullPolicy: global_vars.image_pull_policy,
          resources:{
            requests: {
              cpu: vars.requests_cpu,
              memory: vars.requests_memory,
            },
            limits: {
              cpu: vars.limits_cpu,
              memory: vars.limits_memory,
            },
         },
          readinessProbe: {
            httpGet: {
              port: 8500,
              path: '/',
              scheme: 'HTTP',
            },
            initialDelaySeconds: 10,
            periodSeconds: 5,
            timeoutSeconds: 60,
          },
          livenessProbe:{
            httpGet: {
              port: 8500,
              path: '/',
              scheme: 'HTTP',
            },
            initialDelaySeconds: 10,
            periodSeconds: 5,
            timeoutSeconds: 60,
          },
          volumeMounts: [{
            name: 'config',
            mountPath: '/consul/config/agent.json',
            subPath: 'agent.json',
          }],
        }],
        hostNetwork: true,
        volumes: [{
            name: 'config',
            configMap: { name: vars.config_name},
        }]
      }
    }
  }
}