local name = 'argocd-cmp-jsonnet-nginx-3';

local image = if std.extVar('image') != '' then std.extVar('image') else 'harbor.idc.roywong.work/docker.io/nginx';
local tag = if std.extVar('tag') != '' then std.extVar('tag') else '1.27.1';

local objects = [
  {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
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
];

std.join('\n---\n', std.map(std.manifestYamlDoc, objects))
