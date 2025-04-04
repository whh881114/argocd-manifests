[
  {
    name: 'minio:BucketCapacity:kubernetes-prometheus',
    interval: '5m',
    rules: [
      {
        expr: |||
          minio_cluster_usage_buckets_total_bytes{bucket="kubernetes-prometheus"}/1024/1024/1024 < 200
        |||,
        'for': '5m',
        labels: {severity: 'warning'},
        annotations: {
          summary: "High bucket capacity usage detected",
          description: "Instance kubernetes-prometheus has high bucket capacity usage for the last 5 minutes."
        },
        alert: 'minio:BucketCapacity:kubernetes-prometheus',
      }
    ],
  },
]
