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