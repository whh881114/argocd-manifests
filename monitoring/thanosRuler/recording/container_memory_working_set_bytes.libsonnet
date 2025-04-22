{
  "name": "k8s.rules.container_memory_working_set_bytes",
  "rules": [
    {
      "expr": "container_memory_working_set_bytes{job=\"kubelet\", metrics_path=\"/metrics/cadvisor\", image!=\"\"}\n* on (cluster, namespace, pod) group_left(node) topk by (cluster, namespace, pod) (1,\n  max by (cluster, namespace, pod, node) (kube_pod_info{node!=\"\"})\n)",
      "record": "node_namespace_pod_container:container_memory_working_set_bytes"
    }
  ]
}