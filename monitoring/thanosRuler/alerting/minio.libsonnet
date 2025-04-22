local categroy = "minio";


{
  name: 'minio',
  interval: '5m',
  rules: [
    {
      expr: |||
        1-minio_cluster_usage_buckets_total_bytes{bucket="kubernetes-prometheus"}/minio_cluster_usage_buckets_quota_total_bytes{bucket="kubernetes-prometheus"}<0.2
      |||,
      'for': '5m',
      labels: {
        severity: 'warning',
        category: categroy,
      },
      annotations: {
        summary: "High bucket capacity usage detected",
        description: "Instance kubernetes-prometheus has high bucket capacity usage (80%) for the last 5 minutes."
      },
      alert: 'minioBucketUsageHigh:kubernetes-prometheus',
    },
    {
      expr: |||
        1-minio_cluster_usage_buckets_total_bytes{bucket="kubernetes-prometheus"}/minio_cluster_usage_buckets_quota_total_bytes{bucket="kubernetes-prometheus"}<0.1
      |||,
      'for': '5m',
      labels: {
        severity: 'critical',
        category: categroy,
      },
      annotations: {
        summary: "High bucket capacity usage detected",
        description: "Instance kubernetes-prometheus has high bucket capacity usage (90%) for the last 5 minutes."
      },
      alert: 'minioBucketUsageHigh:kubernetes-prometheus',
    },
    {
      expr: |||
        1-minio_cluster_usage_buckets_total_bytes{bucket="kubernetes-prometheus"}/minio_cluster_usage_buckets_quota_total_bytes{bucket="kubernetes-prometheus"}<0.05
      |||,
      'for': '5m',
      labels: {
        severity: 'disaster',
        category: categroy,
      },
      annotations: {
        summary: "High bucket capacity usage detected",
        description: "Instance kubernetes-prometheus has high bucket capacity usage (95%) for the last 5 minutes."
      },
      alert: 'minioBucketUsageHigh:kubernetes-prometheus',
    },
    {
      expr: |||
        1-minio_cluster_usage_buckets_total_bytes{bucket="kubernetes-loki"}/minio_cluster_usage_buckets_quota_total_bytes{bucket="kubernetes-loki"}<0.2
      |||,
      'for': '5m',
      labels: {
        severity: 'warning',
        category: categroy,
      },
      annotations: {
        summary: "High bucket capacity usage detected",
        description: "Instance kubernetes-loki has high bucket capacity usage (80%) for the last 5 minutes."
      },
      alert: 'minioBucketUsageHigh:kubernetes-loki',
    },
    {
      expr: |||
        1-minio_cluster_usage_buckets_total_bytes{bucket="kubernetes-loki"}/minio_cluster_usage_buckets_quota_total_bytes{bucket="kubernetes-loki"}<0.1
      |||,
      'for': '5m',
      labels: {
        severity: 'critical',
        category: categroy,
      },
      annotations: {
        summary: "High bucket capacity usage detected",
        description: "Instance kubernetes-loki has high bucket capacity usage (90%) for the last 5 minutes."
      },
      alert: 'minioBucketUsageHigh:kubernetes-loki',
    },
    {
      expr: |||
        1-minio_cluster_usage_buckets_total_bytes{bucket="kubernetes-loki"}/minio_cluster_usage_buckets_quota_total_bytes{bucket="kubernetes-loki"}<0.05
      |||,
      'for': '5m',
      labels: {
        severity: 'disaster',
        category: categroy,
      },
      annotations: {
        summary: "High bucket capacity usage detected",
        description: "Instance kubernetes-loki has high bucket capacity usage (95%) for the last 5 minutes."
      },
      alert: 'minioBucketUsageHigh:kubernetes-loki',
    },
  ],
}

