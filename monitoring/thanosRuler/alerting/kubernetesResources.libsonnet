local categroy = "kubernetes-resources";


{
  "name": "kubernetes-resources",
  "rules": [
    {
      "alert": "KubeCPUOvercommit",
      "annotations": {
        "description": "Cluster {{ $labels.cluster }} has overcommitted CPU resource requests for Pods by {{ $value }} CPU shares and cannot tolerate node failure.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubecpuovercommit",
        "summary": "Cluster has overcommitted CPU resource requests."
      },
      "expr": "sum(namespace_cpu:kube_pod_container_resource_requests:sum{job=\"kube-state-metrics\",}) by (cluster) - (sum(kube_node_status_allocatable{job=\"kube-state-metrics\",resource=\"cpu\"}) by (cluster) - max(kube_node_status_allocatable{job=\"kube-state-metrics\",resource=\"cpu\"}) by (cluster)) > 0\nand\n(sum(kube_node_status_allocatable{job=\"kube-state-metrics\",resource=\"cpu\"}) by (cluster) - max(kube_node_status_allocatable{job=\"kube-state-metrics\",resource=\"cpu\"}) by (cluster)) > 0",
      "for": "10m",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "KubeMemoryOvercommit",
      "annotations": {
        "description": "Cluster {{ $labels.cluster }} has overcommitted memory resource requests for Pods by {{ $value | humanize }} bytes and cannot tolerate node failure.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubememoryovercommit",
        "summary": "Cluster has overcommitted memory resource requests."
      },
      "expr": "sum(namespace_memory:kube_pod_container_resource_requests:sum{}) by (cluster) - (sum(kube_node_status_allocatable{resource=\"memory\", job=\"kube-state-metrics\"}) by (cluster) - max(kube_node_status_allocatable{resource=\"memory\", job=\"kube-state-metrics\"}) by (cluster)) > 0\nand\n(sum(kube_node_status_allocatable{resource=\"memory\", job=\"kube-state-metrics\"}) by (cluster) - max(kube_node_status_allocatable{resource=\"memory\", job=\"kube-state-metrics\"}) by (cluster)) > 0",
      "for": "10m",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "KubeCPUQuotaOvercommit",
      "annotations": {
        "description": "Cluster {{ $labels.cluster }}  has overcommitted CPU resource requests for Namespaces.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubecpuquotaovercommit",
        "summary": "Cluster has overcommitted CPU resource requests."
      },
      "expr": "sum(min without(resource) (kube_resourcequota{job=\"kube-state-metrics\", type=\"hard\", resource=~\"(cpu|requests.cpu)\"})) by (cluster)\n  /\nsum(kube_node_status_allocatable{resource=\"cpu\", job=\"kube-state-metrics\"}) by (cluster)\n  > 1.5",
      "for": "5m",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "KubeMemoryQuotaOvercommit",
      "annotations": {
        "description": "Cluster {{ $labels.cluster }}  has overcommitted memory resource requests for Namespaces.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubememoryquotaovercommit",
        "summary": "Cluster has overcommitted memory resource requests."
      },
      "expr": "sum(min without(resource) (kube_resourcequota{job=\"kube-state-metrics\", type=\"hard\", resource=~\"(memory|requests.memory)\"})) by (cluster)\n  /\nsum(kube_node_status_allocatable{resource=\"memory\", job=\"kube-state-metrics\"}) by (cluster)\n  > 1.5",
      "for": "5m",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "KubeQuotaAlmostFull",
      "annotations": {
        "description": "Namespace {{ $labels.namespace }} is using {{ $value | humanizePercentage }} of its {{ $labels.resource }} quota.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubequotaalmostfull",
        "summary": "Namespace quota is going to be full."
      },
      "expr": "kube_resourcequota{job=\"kube-state-metrics\", type=\"used\"}\n  / ignoring(instance, job, type)\n(kube_resourcequota{job=\"kube-state-metrics\", type=\"hard\"} > 0)\n  > 0.9 < 1",
      "for": "15m",
      "labels": {
        "severity": "info",
        "category": categroy,
      }
    },
    {
      "alert": "KubeQuotaFullyUsed",
      "annotations": {
        "description": "Namespace {{ $labels.namespace }} is using {{ $value | humanizePercentage }} of its {{ $labels.resource }} quota.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubequotafullyused",
        "summary": "Namespace quota is fully used."
      },
      "expr": "kube_resourcequota{job=\"kube-state-metrics\", type=\"used\"}\n  / ignoring(instance, job, type)\n(kube_resourcequota{job=\"kube-state-metrics\", type=\"hard\"} > 0)\n  == 1",
      "for": "15m",
      "labels": {
        "severity": "info",
        "category": categroy,
      }
    },
    {
      "alert": "KubeQuotaExceeded",
      "annotations": {
        "description": "Namespace {{ $labels.namespace }} is using {{ $value | humanizePercentage }} of its {{ $labels.resource }} quota.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubequotaexceeded",
        "summary": "Namespace quota has exceeded the limits."
      },
      "expr": "kube_resourcequota{job=\"kube-state-metrics\", type=\"used\"}\n  / ignoring(instance, job, type)\n(kube_resourcequota{job=\"kube-state-metrics\", type=\"hard\"} > 0)\n  > 1",
      "for": "15m",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "CPUThrottlingHigh",
      "annotations": {
        "description": "{{ $value | humanizePercentage }} throttling of CPU in namespace {{ $labels.namespace }} for container {{ $labels.container }} in pod {{ $labels.pod }}.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/cputhrottlinghigh",
        "summary": "Processes experience elevated CPU throttling."
      },
      "expr": "sum(increase(container_cpu_cfs_throttled_periods_total{container!=\"\", }[5m])) by (cluster, container, pod, namespace)\n  /\nsum(increase(container_cpu_cfs_periods_total{}[5m])) by (cluster, container, pod, namespace)\n  > ( 25 / 100 )",
      "for": "15m",
      "labels": {
        "severity": "info",
        "category": categroy,
      }
    }
  ]
}
