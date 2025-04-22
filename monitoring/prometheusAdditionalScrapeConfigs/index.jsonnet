local scrapeConfigs = [
  import 'cvmMinio.libsonnet',
  import 'cvmMysqlZabbixMaster.libsonnet',
];


local encodedScrapeConfigs = std.base64(std.toString(scrapeConfigs));

{
  apiVersion: 'v1',
  kind: 'Secret',
  metadata: {
    name: 'additional-scrape-configs-secret',
  },
  type: 'Opaque',
  data: {
    'additional-scrape-configs.yaml': encodedScrapeConfigs,
  }
}
