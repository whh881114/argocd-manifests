local categroy = "kubernetes-apps";


{
  "name": "kubernetes-apps",
  "rules": [
    {
      "alert": "KubePodCrashLooping",
      "annotations": {
        "description": "Pod {{ $labels.namespace }}/{{ $labels.pod }} ({{ $labels.container }}) is in waiting state (reason: \"CrashLoopBackOff\").",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubepodcrashlooping",
        "summary": "Pod is crash looping."
      },
      "expr": "max_over_time(kube_pod_container_status_waiting_reason{reason=\"CrashLoopBackOff\", job=\"kube-state-metrics\", namespace=~\".*\"}[5m]) >= 1",
      "for": "15m",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "KubePodNotReady",
      "annotations": {
        "description": "Pod {{ $labels.namespace }}/{{ $labels.pod }} has been in a non-ready state for longer than 15 minutes.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubepodnotready",
        "summary": "Pod has been in a non-ready state for more than 15 minutes."
      },
      "expr": "sum by (namespace, pod, cluster) (\n  max by (namespace, pod, cluster) (\n    kube_pod_status_phase{job=\"kube-state-metrics\", namespace=~\".*\", phase=~\"Pending|Unknown|Failed\"}\n  ) * on (namespace, pod, cluster) group_left(owner_kind) topk by (namespace, pod, cluster) (\n    1, max by (namespace, pod, owner_kind, cluster) (kube_pod_owner{owner_kind!=\"Job\"})\n  )\n) > 0",
      "for": "15m",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "KubeDeploymentGenerationMismatch",
      "annotations": {
        "description": "Deployment generation for {{ $labels.namespace }}/{{ $labels.deployment }} does not match, this indicates that the Deployment has failed but has not been rolled back.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubedeploymentgenerationmismatch",
        "summary": "Deployment generation mismatch due to possible roll-back"
      },
      "expr": "kube_deployment_status_observed_generation{job=\"kube-state-metrics\", namespace=~\".*\"}\n  !=\nkube_deployment_metadata_generation{job=\"kube-state-metrics\", namespace=~\".*\"}",
      "for": "15m",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "KubeDeploymentReplicasMismatch",
      "annotations": {
        "description": "Deployment {{ $labels.namespace }}/{{ $labels.deployment }} has not matched the expected number of replicas for longer than 15 minutes.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubedeploymentreplicasmismatch",
        "summary": "Deployment has not matched the expected number of replicas."
      },
      "expr": "(\n  kube_deployment_spec_replicas{job=\"kube-state-metrics\", namespace=~\".*\"}\n    >\n  kube_deployment_status_replicas_available{job=\"kube-state-metrics\", namespace=~\".*\"}\n) and (\n  changes(kube_deployment_status_replicas_updated{job=\"kube-state-metrics\", namespace=~\".*\"}[10m])\n    ==\n  0\n)",
      "for": "15m",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "KubeDeploymentRolloutStuck",
      "annotations": {
        "description": "Rollout of deployment {{ $labels.namespace }}/{{ $labels.deployment }} is not progressing for longer than 15 minutes.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubedeploymentrolloutstuck",
        "summary": "Deployment rollout is not progressing."
      },
      "expr": "kube_deployment_status_condition{condition=\"Progressing\", status=\"false\",job=\"kube-state-metrics\", namespace=~\".*\"}\n!= 0",
      "for": "15m",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "KubeStatefulSetReplicasMismatch",
      "annotations": {
        "description": "StatefulSet {{ $labels.namespace }}/{{ $labels.statefulset }} has not matched the expected number of replicas for longer than 15 minutes.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubestatefulsetreplicasmismatch",
        "summary": "StatefulSet has not matched the expected number of replicas."
      },
      "expr": "(\n  kube_statefulset_status_replicas_ready{job=\"kube-state-metrics\", namespace=~\".*\"}\n    !=\n  kube_statefulset_status_replicas{job=\"kube-state-metrics\", namespace=~\".*\"}\n) and (\n  changes(kube_statefulset_status_replicas_updated{job=\"kube-state-metrics\", namespace=~\".*\"}[10m])\n    ==\n  0\n)",
      "for": "15m",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "KubeStatefulSetGenerationMismatch",
      "annotations": {
        "description": "StatefulSet generation for {{ $labels.namespace }}/{{ $labels.statefulset }} does not match, this indicates that the StatefulSet has failed but has not been rolled back.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubestatefulsetgenerationmismatch",
        "summary": "StatefulSet generation mismatch due to possible roll-back"
      },
      "expr": "kube_statefulset_status_observed_generation{job=\"kube-state-metrics\", namespace=~\".*\"}\n  !=\nkube_statefulset_metadata_generation{job=\"kube-state-metrics\", namespace=~\".*\"}",
      "for": "15m",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "KubeStatefulSetUpdateNotRolledOut",
      "annotations": {
        "description": "StatefulSet {{ $labels.namespace }}/{{ $labels.statefulset }} update has not been rolled out.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubestatefulsetupdatenotrolledout",
        "summary": "StatefulSet update has not been rolled out."
      },
      "expr": "(\n  max without (revision) (\n    kube_statefulset_status_current_revision{job=\"kube-state-metrics\", namespace=~\".*\"}\n      unless\n    kube_statefulset_status_update_revision{job=\"kube-state-metrics\", namespace=~\".*\"}\n  )\n    *\n  (\n    kube_statefulset_replicas{job=\"kube-state-metrics\", namespace=~\".*\"}\n      !=\n    kube_statefulset_status_replicas_updated{job=\"kube-state-metrics\", namespace=~\".*\"}\n  )\n)  and (\n  changes(kube_statefulset_status_replicas_updated{job=\"kube-state-metrics\", namespace=~\".*\"}[5m])\n    ==\n  0\n)",
      "for": "15m",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "KubeDaemonSetRolloutStuck",
      "annotations": {
        "description": "DaemonSet {{ $labels.namespace }}/{{ $labels.daemonset }} has not finished or progressed for at least 15 minutes.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubedaemonsetrolloutstuck",
        "summary": "DaemonSet rollout is stuck."
      },
      "expr": "(\n  (\n    kube_daemonset_status_current_number_scheduled{job=\"kube-state-metrics\", namespace=~\".*\"}\n     !=\n    kube_daemonset_status_desired_number_scheduled{job=\"kube-state-metrics\", namespace=~\".*\"}\n  ) or (\n    kube_daemonset_status_number_misscheduled{job=\"kube-state-metrics\", namespace=~\".*\"}\n     !=\n    0\n  ) or (\n    kube_daemonset_status_updated_number_scheduled{job=\"kube-state-metrics\", namespace=~\".*\"}\n     !=\n    kube_daemonset_status_desired_number_scheduled{job=\"kube-state-metrics\", namespace=~\".*\"}\n  ) or (\n    kube_daemonset_status_number_available{job=\"kube-state-metrics\", namespace=~\".*\"}\n     !=\n    kube_daemonset_status_desired_number_scheduled{job=\"kube-state-metrics\", namespace=~\".*\"}\n  )\n) and (\n  changes(kube_daemonset_status_updated_number_scheduled{job=\"kube-state-metrics\", namespace=~\".*\"}[5m])\n    ==\n  0\n)",
      "for": "15m",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "KubeContainerWaiting",
      "annotations": {
        "description": "pod/{{ $labels.pod }} in namespace {{ $labels.namespace }} on container {{ $labels.container}} has been in waiting state for longer than 1 hour.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubecontainerwaiting",
        "summary": "Pod container waiting longer than 1 hour"
      },
      "expr": "sum by (namespace, pod, container, cluster) (kube_pod_container_status_waiting_reason{job=\"kube-state-metrics\", namespace=~\".*\"}) > 0",
      "for": "1h",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "KubeDaemonSetNotScheduled",
      "annotations": {
        "description": "{{ $value }} Pods of DaemonSet {{ $labels.namespace }}/{{ $labels.daemonset }} are not scheduled.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubedaemonsetnotscheduled",
        "summary": "DaemonSet pods are not scheduled."
      },
      "expr": "kube_daemonset_status_desired_number_scheduled{job=\"kube-state-metrics\", namespace=~\".*\"}\n  -\nkube_daemonset_status_current_number_scheduled{job=\"kube-state-metrics\", namespace=~\".*\"} > 0",
      "for": "10m",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "KubeDaemonSetMisScheduled",
      "annotations": {
        "description": "{{ $value }} Pods of DaemonSet {{ $labels.namespace }}/{{ $labels.daemonset }} are running where they are not supposed to run.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubedaemonsetmisscheduled",
        "summary": "DaemonSet pods are misscheduled."
      },
      "expr": "kube_daemonset_status_number_misscheduled{job=\"kube-state-metrics\", namespace=~\".*\"} > 0",
      "for": "15m",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "KubeJobNotCompleted",
      "annotations": {
        "description": "Job {{ $labels.namespace }}/{{ $labels.job_name }} is taking more than {{ \"43200\" | humanizeDuration }} to complete.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubejobnotcompleted",
        "summary": "Job did not complete in time"
      },
      "expr": "time() - max by (namespace, job_name, cluster) (kube_job_status_start_time{job=\"kube-state-metrics\", namespace=~\".*\"}\n  and\nkube_job_status_active{job=\"kube-state-metrics\", namespace=~\".*\"} > 0) > 43200",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "KubeJobFailed",
      "annotations": {
        "description": "Job {{ $labels.namespace }}/{{ $labels.job_name }} failed to complete. Removing failed job after investigation should clear this alert.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubejobfailed",
        "summary": "Job failed to complete."
      },
      "expr": "kube_job_failed{job=\"kube-state-metrics\", namespace=~\".*\"}  > 0",
      "for": "15m",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "KubeHpaReplicasMismatch",
      "annotations": {
        "description": "HPA {{ $labels.namespace }}/{{ $labels.horizontalpodautoscaler  }} has not matched the desired number of replicas for longer than 15 minutes.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubehpareplicasmismatch",
        "summary": "HPA has not matched desired number of replicas."
      },
      "expr": "(kube_horizontalpodautoscaler_status_desired_replicas{job=\"kube-state-metrics\", namespace=~\".*\"}\n  !=\nkube_horizontalpodautoscaler_status_current_replicas{job=\"kube-state-metrics\", namespace=~\".*\"})\n  and\n(kube_horizontalpodautoscaler_status_current_replicas{job=\"kube-state-metrics\", namespace=~\".*\"}\n  >\nkube_horizontalpodautoscaler_spec_min_replicas{job=\"kube-state-metrics\", namespace=~\".*\"})\n  and\n(kube_horizontalpodautoscaler_status_current_replicas{job=\"kube-state-metrics\", namespace=~\".*\"}\n  <\nkube_horizontalpodautoscaler_spec_max_replicas{job=\"kube-state-metrics\", namespace=~\".*\"})\n  and\nchanges(kube_horizontalpodautoscaler_status_current_replicas{job=\"kube-state-metrics\", namespace=~\".*\"}[15m]) == 0",
      "for": "15m",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "KubeHpaMaxedOut",
      "annotations": {
        "description": "HPA {{ $labels.namespace }}/{{ $labels.horizontalpodautoscaler  }} has been running at max replicas for longer than 15 minutes.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubehpamaxedout",
        "summary": "HPA is running at max replicas"
      },
      "expr": "kube_horizontalpodautoscaler_status_current_replicas{job=\"kube-state-metrics\", namespace=~\".*\"}\n  ==\nkube_horizontalpodautoscaler_spec_max_replicas{job=\"kube-state-metrics\", namespace=~\".*\"}",
      "for": "15m",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    }
  ]
}
