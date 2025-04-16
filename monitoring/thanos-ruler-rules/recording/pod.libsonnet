[
  {
    "name": "k8s.rules.pod_owner",
    "rules": [
      {
        "expr": "max by (cluster, namespace, workload, pod) (\n  label_replace(\n    label_replace(\n      kube_pod_owner{job=\"kube-state-metrics\", owner_kind=\"ReplicaSet\"},\n      \"replicaset\", \"$1\", \"owner_name\", \"(.*)\"\n    ) * on (replicaset, namespace) group_left(owner_name) topk by (replicaset, namespace) (\n      1, max by (replicaset, namespace, owner_name) (\n        kube_replicaset_owner{job=\"kube-state-metrics\"}\n      )\n    ),\n    \"workload\", \"$1\", \"owner_name\", \"(.*)\"\n  )\n)",
        "labels": {
          "workload_type": "deployment"
        },
        "record": "namespace_workload_pod:kube_pod_owner:relabel"
      },
      {
        "expr": "max by (cluster, namespace, workload, pod) (\n  label_replace(\n    kube_pod_owner{job=\"kube-state-metrics\", owner_kind=\"DaemonSet\"},\n    \"workload\", \"$1\", \"owner_name\", \"(.*)\"\n  )\n)",
        "labels": {
          "workload_type": "daemonset"
        },
        "record": "namespace_workload_pod:kube_pod_owner:relabel"
      },
      {
        "expr": "max by (cluster, namespace, workload, pod) (\n  label_replace(\n    kube_pod_owner{job=\"kube-state-metrics\", owner_kind=\"StatefulSet\"},\n    \"workload\", \"$1\", \"owner_name\", \"(.*)\"\n  )\n)",
        "labels": {
          "workload_type": "statefulset"
        },
        "record": "namespace_workload_pod:kube_pod_owner:relabel"
      },
      {
        "expr": "max by (cluster, namespace, workload, pod) (\n  label_replace(\n    kube_pod_owner{job=\"kube-state-metrics\", owner_kind=\"Job\"},\n    \"workload\", \"$1\", \"owner_name\", \"(.*)\"\n  )\n)",
        "labels": {
          "workload_type": "job"
        },
        "record": "namespace_workload_pod:kube_pod_owner:relabel"
      }
    ]
  }
]