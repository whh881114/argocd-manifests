local categroy = "minio";


{
  name: 'minio',
  interval: '5m',
  rules: [
    {
      expr: |||
        minio_cluster_usage_buckets_total_bytes{bucket="kubernetes-prometheus"}/minio_cluster_usage_buckets_quota_total_bytes{bucket="kubernetes-prometheus"}>0.8
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
        minio_cluster_usage_buckets_total_bytes{bucket="kubernetes-prometheus"}/minio_cluster_usage_buckets_quota_total_bytes{bucket="kubernetes-prometheus"}>0.9
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
        minio_cluster_usage_buckets_total_bytes{bucket="kubernetes-prometheus"}/minio_cluster_usage_buckets_quota_total_bytes{bucket="kubernetes-prometheus"}>0.95
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
        minio_cluster_usage_buckets_total_bytes{bucket="kubernetes-loki"}/minio_cluster_usage_buckets_quota_total_bytes{bucket="kubernetes-loki"}>0.8
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
        minio_cluster_usage_buckets_total_bytes{bucket="kubernetes-loki"}/minio_cluster_usage_buckets_quota_total_bytes{bucket="kubernetes-loki"}>0.9
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
        minio_cluster_usage_buckets_total_bytes{bucket="kubernetes-loki"}/minio_cluster_usage_buckets_quota_total_bytes{bucket="kubernetes-loki"}>0.95
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

