local staticConfigs = [
	{targets: ['minio-1.freedom.org:9000', 'minio-2.freedom.org:9000', 'minio-3.freedom.org:9000', 'minio-4.freedom.org:9000']},
];

local metrics = [
	'api',
	'system',
	'debug',
	'cluster',
	'ilm',
	'audit',
	'logger',
	'replication',
	'notification',
	'scanner',
];

local jobs = [
  {
    job_name: 'cvm/minio/' + metric,
    metrics_path: '/minio/metrics/v3/' + metric,
    scheme: 'http',
    static_configs: staticConfigs
  }
  for metric in metrics
];

jobs