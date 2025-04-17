{
  "name": "kube-scheduler.rules",
  "rules": [
    {
      "expr": "histogram_quantile(0.99, sum(rate(scheduler_e2e_scheduling_duration_seconds_bucket{job=\"kube-scheduler\"}[5m])) without(instance, pod))",
      "labels": {
        "quantile": "0.99"
      },
      "record": "cluster_quantile:scheduler_e2e_scheduling_duration_seconds:histogram_quantile"
    },
    {
      "expr": "histogram_quantile(0.99, sum(rate(scheduler_scheduling_algorithm_duration_seconds_bucket{job=\"kube-scheduler\"}[5m])) without(instance, pod))",
      "labels": {
        "quantile": "0.99"
      },
      "record": "cluster_quantile:scheduler_scheduling_algorithm_duration_seconds:histogram_quantile"
    },
    {
      "expr": "histogram_quantile(0.99, sum(rate(scheduler_binding_duration_seconds_bucket{job=\"kube-scheduler\"}[5m])) without(instance, pod))",
      "labels": {
        "quantile": "0.99"
      },
      "record": "cluster_quantile:scheduler_binding_duration_seconds:histogram_quantile"
    },
    {
      "expr": "histogram_quantile(0.9, sum(rate(scheduler_e2e_scheduling_duration_seconds_bucket{job=\"kube-scheduler\"}[5m])) without(instance, pod))",
      "labels": {
        "quantile": "0.9"
      },
      "record": "cluster_quantile:scheduler_e2e_scheduling_duration_seconds:histogram_quantile"
    },
    {
      "expr": "histogram_quantile(0.9, sum(rate(scheduler_scheduling_algorithm_duration_seconds_bucket{job=\"kube-scheduler\"}[5m])) without(instance, pod))",
      "labels": {
        "quantile": "0.9"
      },
      "record": "cluster_quantile:scheduler_scheduling_algorithm_duration_seconds:histogram_quantile"
    },
    {
      "expr": "histogram_quantile(0.9, sum(rate(scheduler_binding_duration_seconds_bucket{job=\"kube-scheduler\"}[5m])) without(instance, pod))",
      "labels": {
        "quantile": "0.9"
      },
      "record": "cluster_quantile:scheduler_binding_duration_seconds:histogram_quantile"
    },
    {
      "expr": "histogram_quantile(0.5, sum(rate(scheduler_e2e_scheduling_duration_seconds_bucket{job=\"kube-scheduler\"}[5m])) without(instance, pod))",
      "labels": {
        "quantile": "0.5"
      },
      "record": "cluster_quantile:scheduler_e2e_scheduling_duration_seconds:histogram_quantile"
    },
    {
      "expr": "histogram_quantile(0.5, sum(rate(scheduler_scheduling_algorithm_duration_seconds_bucket{job=\"kube-scheduler\"}[5m])) without(instance, pod))",
      "labels": {
        "quantile": "0.5"
      },
      "record": "cluster_quantile:scheduler_scheduling_algorithm_duration_seconds:histogram_quantile"
    },
    {
      "expr": "histogram_quantile(0.5, sum(rate(scheduler_binding_duration_seconds_bucket{job=\"kube-scheduler\"}[5m])) without(instance, pod))",
      "labels": {
        "quantile": "0.5"
      },
      "record": "cluster_quantile:scheduler_binding_duration_seconds:histogram_quantile"
    }
  ]
}
