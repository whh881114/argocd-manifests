[
  {
    job_name: 'cvm/mysql/zabbix-master',
    metrics_path: '/metrics',
    scheme: 'http',
    static_configs: [
      {targets: ['zabbix.freedom.org:9104']},
    ]
  }
]