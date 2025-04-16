[
  {
    "name": "k8s.rules.container_cpu_usage_seconds_total",
    "rules": [
      {
        "expr": "sum by (cluster, namespace, pod, container) (\n  irate(container_cpu_usage_seconds_total{job=\"kubelet\", metrics_path=\"/metrics/cadvisor\", image!=\"\"}[5m])\n) * on (cluster, namespace, pod) group_left(node) topk by (cluster, namespace, pod) (\n  1, max by (cluster, namespace, pod, node) (kube_pod_info{node!=\"\"})\n)",
        "record": "node_namespace_pod_container:container_cpu_usage_seconds_total:sum_irate"
      }
    ]
  },
  {
    "name": "k8s.rules.container_memory_cache",
    "rules": [
      {
        "expr": "container_memory_cache{job=\"kubelet\", metrics_path=\"/metrics/cadvisor\", image!=\"\"}\n* on (cluster, namespace, pod) group_left(node) topk by (cluster, namespace, pod) (1,\n  max by (cluster, namespace, pod, node) (kube_pod_info{node!=\"\"})\n)",
        "record": "node_namespace_pod_container:container_memory_cache"
      }
    ]
  },
  {
    "name": "k8s.rules.container_memory_rss",
    "rules": [
      {
        "expr": "container_memory_rss{job=\"kubelet\", metrics_path=\"/metrics/cadvisor\", image!=\"\"}\n* on (cluster, namespace, pod) group_left(node) topk by (cluster, namespace, pod) (1,\n  max by (cluster, namespace, pod, node) (kube_pod_info{node!=\"\"})\n)",
        "record": "node_namespace_pod_container:container_memory_rss"
      }
    ]
  },
  {
    "name": "k8s.rules.container_memory_swap",
    "rules": [
      {
        "expr": "container_memory_swap{job=\"kubelet\", metrics_path=\"/metrics/cadvisor\", image!=\"\"}\n* on (cluster, namespace, pod) group_left(node) topk by (cluster, namespace, pod) (1,\n  max by (cluster, namespace, pod, node) (kube_pod_info{node!=\"\"})\n)",
        "record": "node_namespace_pod_container:container_memory_swap"
      }
    ]
  },
  {
    "name": "k8s.rules.container_memory_working_set_bytes",
    "rules": [
      {
        "expr": "container_memory_working_set_bytes{job=\"kubelet\", metrics_path=\"/metrics/cadvisor\", image!=\"\"}\n* on (cluster, namespace, pod) group_left(node) topk by (cluster, namespace, pod) (1,\n  max by (cluster, namespace, pod, node) (kube_pod_info{node!=\"\"})\n)",
        "record": "node_namespace_pod_container:container_memory_working_set_bytes"
      }
    ]
  },
  {
    "name": "k8s.rules.container_resource",
    "rules": [
      {
        "expr": "kube_pod_container_resource_requests{resource=\"memory\",job=\"kube-state-metrics\"}  * on (namespace, pod, cluster)\ngroup_left() max by (namespace, pod, cluster) (\n  (kube_pod_status_phase{phase=~\"Pending|Running\"} == 1)\n)",
        "record": "cluster:namespace:pod_memory:active:kube_pod_container_resource_requests"
      },
      {
        "expr": "sum by (namespace, cluster) (\n    sum by (namespace, pod, cluster) (\n        max by (namespace, pod, container, cluster) (\n          kube_pod_container_resource_requests{resource=\"memory\",job=\"kube-state-metrics\"}\n        ) * on (namespace, pod, cluster) group_left() max by (namespace, pod, cluster) (\n          kube_pod_status_phase{phase=~\"Pending|Running\"} == 1\n        )\n    )\n)",
        "record": "namespace_memory:kube_pod_container_resource_requests:sum"
      },
      {
        "expr": "kube_pod_container_resource_requests{resource=\"cpu\",job=\"kube-state-metrics\"}  * on (namespace, pod, cluster)\ngroup_left() max by (namespace, pod, cluster) (\n  (kube_pod_status_phase{phase=~\"Pending|Running\"} == 1)\n)",
        "record": "cluster:namespace:pod_cpu:active:kube_pod_container_resource_requests"
      },
      {
        "expr": "sum by (namespace, cluster) (\n    sum by (namespace, pod, cluster) (\n        max by (namespace, pod, container, cluster) (\n          kube_pod_container_resource_requests{resource=\"cpu\",job=\"kube-state-metrics\"}\n        ) * on (namespace, pod, cluster) group_left() max by (namespace, pod, cluster) (\n          kube_pod_status_phase{phase=~\"Pending|Running\"} == 1\n        )\n    )\n)",
        "record": "namespace_cpu:kube_pod_container_resource_requests:sum"
      },
      {
        "expr": "kube_pod_container_resource_limits{resource=\"memory\",job=\"kube-state-metrics\"}  * on (namespace, pod, cluster)\ngroup_left() max by (namespace, pod, cluster) (\n  (kube_pod_status_phase{phase=~\"Pending|Running\"} == 1)\n)",
        "record": "cluster:namespace:pod_memory:active:kube_pod_container_resource_limits"
      },
      {
        "expr": "sum by (namespace, cluster) (\n    sum by (namespace, pod, cluster) (\n        max by (namespace, pod, container, cluster) (\n          kube_pod_container_resource_limits{resource=\"memory\",job=\"kube-state-metrics\"}\n        ) * on (namespace, pod, cluster) group_left() max by (namespace, pod, cluster) (\n          kube_pod_status_phase{phase=~\"Pending|Running\"} == 1\n        )\n    )\n)",
        "record": "namespace_memory:kube_pod_container_resource_limits:sum"
      },
      {
        "expr": "kube_pod_container_resource_limits{resource=\"cpu\",job=\"kube-state-metrics\"}  * on (namespace, pod, cluster)\ngroup_left() max by (namespace, pod, cluster) (\n (kube_pod_status_phase{phase=~\"Pending|Running\"} == 1)\n )",
        "record": "cluster:namespace:pod_cpu:active:kube_pod_container_resource_limits"
      },
      {
        "expr": "sum by (namespace, cluster) (\n    sum by (namespace, pod, cluster) (\n        max by (namespace, pod, container, cluster) (\n          kube_pod_container_resource_limits{resource=\"cpu\",job=\"kube-state-metrics\"}\n        ) * on (namespace, pod, cluster) group_left() max by (namespace, pod, cluster) (\n          kube_pod_status_phase{phase=~\"Pending|Running\"} == 1\n        )\n    )\n)",
        "record": "namespace_cpu:kube_pod_container_resource_limits:sum"
      }
    ]
  }
]