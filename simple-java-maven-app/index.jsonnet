local name = 'simple-java-maven-app';

local image = if std.extVar('image') != '' then std.extVar('image') else 'harbor.idc.roywong.work/docker.io/library/busybox';
local tag = if std.extVar('tag') != '' then std.extVar('tag') else '1.37.0-glibc';

local objects = [
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
                  containerPort: 8080
                }
              ]
            }
          ]
        }
      }
    }
  },
];

std.join('\n---\n', std.map(std.manifestYamlDoc, objects))