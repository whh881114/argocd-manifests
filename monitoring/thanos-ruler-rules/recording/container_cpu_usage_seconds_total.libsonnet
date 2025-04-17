{
  "name": "k8s.rules.container_cpu_usage_seconds_total",
  "rules": [
    {
      "expr": "sum by (cluster, namespace, pod, container) (\n  irate(container_cpu_usage_seconds_total{job=\"kubelet\", metrics_path=\"/metrics/cadvisor\", image!=\"\"}[5m])\n) * on (cluster, namespace, pod) group_left(node) topk by (cluster, namespace, pod) (\n  1, max by (cluster, namespace, pod, node) (kube_pod_info{node!=\"\"})\n)",
      "record": "node_namespace_pod_container:container_cpu_usage_seconds_total:sum_irate"
    }
  ]
}