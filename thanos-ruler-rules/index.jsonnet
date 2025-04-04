local prometheusDefaultRules = import './prometheusDefaultRules.libsonnet';
local minioBucketCapacity = import './minioBucketCapacity.libsonnet';


local prometheusRules = prometheusDefaultRules +
                        minioBucketCapacity;


local groups = {'groups': prometheusRules};

{
  apiVersion: 'v1',
  kind: 'ConfigMap',
  metadata: {
    name: 'thanos-ruler-rules',
  },
  data: {
    'ruler.yml': std.manifestYamlDoc(groups)
  }
}
