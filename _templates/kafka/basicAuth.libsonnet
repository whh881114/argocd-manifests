local basicAuthIndex = import './basicAuthIndex.libsonnet';

function(app)
  local authString = std.get(basicAuthIndex, app.name);

  local basicAuth = {
    apiVersion: 'v1',
    kind: 'Secret',
    metadata: {
      name: 'baisc-auth-' + app.name,
    },
    data: {
      auth: std.base64(std.toString(authString)),
    },
    type: 'Opaque',
  };

  [basicAuth]
