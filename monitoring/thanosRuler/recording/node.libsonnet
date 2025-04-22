{
  "name": "node.rules",
  "rules": [
    {
      "expr": "topk by (cluster, namespace, pod) (1,\n  max by (cluster, node, namespace, pod) (\n    label_replace(kube_pod_info{job=\"kube-state-metrics\",node!=\"\"}, \"pod\", \"$1\", \"pod\", \"(.*)\")\n))",
      "record": "node_namespace_pod:kube_pod_info:"
    },
    {
      "expr": "count by (cluster, node) (\n  node_cpu_seconds_total{mode=\"idle\",job=\"node-exporter\"}\n  * on (cluster, namespace, pod) group_left(node)\n  topk by (cluster, namespace, pod) (1, node_namespace_pod:kube_pod_info:)\n)",
      "record": "node:node_num_cpu:sum"
    },
    {
      "expr": "sum(\n  node_memory_MemAvailable_bytes{job=\"node-exporter\"} or\n  (\n    node_memory_Buffers_bytes{job=\"node-exporter\"} +\n    node_memory_Cached_bytes{job=\"node-exporter\"} +\n    node_memory_MemFree_bytes{job=\"node-exporter\"} +\n    node_memory_Slab_bytes{job=\"node-exporter\"}\n  )\n) by (cluster)",
      "record": ":node_memory_MemAvailable_bytes:sum"
    },
    {
      "expr": "avg by (cluster, node) (\n  sum without (mode) (\n    rate(node_cpu_seconds_total{mode!=\"idle\",mode!=\"iowait\",mode!=\"steal\",job=\"node-exporter\"}[5m])\n  )\n)",
      "record": "node:node_cpu_utilization:ratio_rate5m"
    },
    {
      "expr": "avg by (cluster) (\n  node:node_cpu_utilization:ratio_rate5m\n)",
      "record": "cluster:node_cpu:ratio_rate5m"
    }
  ]
}
