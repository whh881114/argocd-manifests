local categroy = "minio";

[
  {
    name: 'minio',
    interval: '5m',
    rules: [
      {
        expr: |||
          minio_cluster_usage_buckets_total_bytes{bucket="kubernetes-prometheus"}/1024/1024/1024 < 200
        |||,
        'for': '5m',
        labels: {
          severity: 'warning',
          category: categroy,
        },
        annotations: {
          summary: "High bucket capacity usage detected",
          description: "Instance kubernetes-prometheus has high bucket capacity usage for the last 5 minutes."
        },
        alert: 'minioBucketUsageHigh:kubernetes-prometheus',
      },
      {
        expr: |||
          minio_cluster_usage_buckets_total_bytes{bucket="kubernetes-prometheus"}/1024/1024/1024 < 100
        |||,
        'for': '5m',
        labels: {
          severity: 'critical',
          category: categroy,
        },
        annotations: {
          summary: "High bucket capacity usage detected",
          description: "Instance kubernetes-prometheus has high bucket capacity usage for the last 5 minutes."
        },
        alert: 'minioBucketUsageHigh:kubernetes-prometheus',
      },
      {
        expr: |||
          minio_cluster_usage_buckets_total_bytes{bucket="kubernetes-prometheus"}/1024/1024/1024 < 50
        |||,
        'for': '5m',
        labels: {
          severity: 'disaster',
          category: categroy,
        },
        annotations: {
          summary: "High bucket capacity usage detected",
          description: "Instance kubernetes-prometheus has high bucket capacity usage for the last 5 minutes."
        },
        alert: 'minioBucketUsageHigh:kubernetes-prometheus',
      },
    ],
  },
]
