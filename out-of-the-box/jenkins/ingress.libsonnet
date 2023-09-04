local func_vars = import './vars.libsonnet';
local global_vars = import '../../global_vars.libsonnet';


function(instance)
  local vars = func_vars(instance);
  local http_port_number = 8080;

  local item = {
    apiVersion: 'networking.k8s.io/v1',
    kind: 'Ingress',
    metadata: {
      name: instance.name,
      namespace: vars.namespace,
      annotations: {
        'kubernetes.io/ingress.class': 'nginx',
        'nginx.ingress.kubernetes.io/proxy-body-size': '200m',
      }
    },
    spec: {
      rules: [{
        host: '%s.%s.%s' % [instance.name, vars.namespace, global_vars.domain_name],
        http: {
          paths: [{
            path: '/',
            pathType: 'ImplementationSpecific',
            backend: {
              service: {
                name: instance.name,
                port: {number: http_port_number}
              }
            }
          }]
        }
      }]
    }
  };

  item