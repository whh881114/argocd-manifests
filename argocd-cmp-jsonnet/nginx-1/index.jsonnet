local name = 'argocd-cmp-jsonnet-nginx-1';

local image = if std.extVar('image') != '' then std.extVar('image') else 'harbor.idc.roywong.work/docker.io/nginx';
local tag = if std.extVar('tag') != '' then std.extVar('tag') else '1.27.1';


{
  apiVersion: 'apps/v1',
  kind: 'Deployment',
  metadata: {
    name: name,
    labels: {
      app: name,
    }
  },
  spec: {
    replicas: 1,
    selector: {
      matchLabels: {
        app: name,
      }
    },
    template: {
      metadata: {
        labels: {
          app: name,
        }
      },
      spec: {
        containers: [
          {
            name: 'nginx',
            image: image + ':' + tag,
            ports: [
              {
                containerPort: 80
              }
            ]
          }
        ]
      }
    }
  }
}
