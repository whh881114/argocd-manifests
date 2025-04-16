local categroy = "kubernetes-storage";

[
  {
    "name": "kubernetes-storage",
    "rules": [
      {
        "alert": "KubePersistentVolumeFillingUp",
        "annotations": {
          "description": "The PersistentVolume claimed by {{ $labels.persistentvolumeclaim }} in Namespace {{ $labels.namespace }} {{ with $labels.cluster -}} on Cluster {{ . }} {{- end }} is only {{ $value | humanizePercentage }} free.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubepersistentvolumefillingup",
          "summary": "PersistentVolume is filling up."
        },
        "expr": "(\n  kubelet_volume_stats_available_bytes{job=\"kubelet\", namespace=~\".*\", metrics_path=\"/metrics\"}\n    /\n  kubelet_volume_stats_capacity_bytes{job=\"kubelet\", namespace=~\".*\", metrics_path=\"/metrics\"}\n) < 0.03\nand\nkubelet_volume_stats_used_bytes{job=\"kubelet\", namespace=~\".*\", metrics_path=\"/metrics\"} > 0\nunless on (cluster, namespace, persistentvolumeclaim)\nkube_persistentvolumeclaim_access_mode{ access_mode=\"ReadOnlyMany\"} == 1\nunless on (cluster, namespace, persistentvolumeclaim)\nkube_persistentvolumeclaim_labels{label_excluded_from_alerts=\"true\"} == 1",
        "for": "1m",
        "labels": {
          "severity": "critical",
          "category": categroy,
        }
      },
      {
        "alert": "KubePersistentVolumeFillingUp",
        "annotations": {
          "description": "Based on recent sampling, the PersistentVolume claimed by {{ $labels.persistentvolumeclaim }} in Namespace {{ $labels.namespace }} {{ with $labels.cluster -}} on Cluster {{ . }} {{- end }} is expected to fill up within four days. Currently {{ $value | humanizePercentage }} is available.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubepersistentvolumefillingup",
          "summary": "PersistentVolume is filling up."
        },
        "expr": "(\n  kubelet_volume_stats_available_bytes{job=\"kubelet\", namespace=~\".*\", metrics_path=\"/metrics\"}\n    /\n  kubelet_volume_stats_capacity_bytes{job=\"kubelet\", namespace=~\".*\", metrics_path=\"/metrics\"}\n) < 0.15\nand\nkubelet_volume_stats_used_bytes{job=\"kubelet\", namespace=~\".*\", metrics_path=\"/metrics\"} > 0\nand\npredict_linear(kubelet_volume_stats_available_bytes{job=\"kubelet\", namespace=~\".*\", metrics_path=\"/metrics\"}[6h], 4 * 24 * 3600) < 0\nunless on (cluster, namespace, persistentvolumeclaim)\nkube_persistentvolumeclaim_access_mode{ access_mode=\"ReadOnlyMany\"} == 1\nunless on (cluster, namespace, persistentvolumeclaim)\nkube_persistentvolumeclaim_labels{label_excluded_from_alerts=\"true\"} == 1",
        "for": "1h",
        "labels": {
          "severity": "warning",
          "category": categroy,
        }
      },
      {
        "alert": "KubePersistentVolumeInodesFillingUp",
        "annotations": {
          "description": "The PersistentVolume claimed by {{ $labels.persistentvolumeclaim }} in Namespace {{ $labels.namespace }} {{ with $labels.cluster -}} on Cluster {{ . }} {{- end }} only has {{ $value | humanizePercentage }} free inodes.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubepersistentvolumeinodesfillingup",
          "summary": "PersistentVolumeInodes are filling up."
        },
        "expr": "(\n  kubelet_volume_stats_inodes_free{job=\"kubelet\", namespace=~\".*\", metrics_path=\"/metrics\"}\n    /\n  kubelet_volume_stats_inodes{job=\"kubelet\", namespace=~\".*\", metrics_path=\"/metrics\"}\n) < 0.03\nand\nkubelet_volume_stats_inodes_used{job=\"kubelet\", namespace=~\".*\", metrics_path=\"/metrics\"} > 0\nunless on (cluster, namespace, persistentvolumeclaim)\nkube_persistentvolumeclaim_access_mode{ access_mode=\"ReadOnlyMany\"} == 1\nunless on (cluster, namespace, persistentvolumeclaim)\nkube_persistentvolumeclaim_labels{label_excluded_from_alerts=\"true\"} == 1",
        "for": "1m",
        "labels": {
          "severity": "critical",
          "category": categroy,
        }
      },
      {
        "alert": "KubePersistentVolumeInodesFillingUp",
        "annotations": {
          "description": "Based on recent sampling, the PersistentVolume claimed by {{ $labels.persistentvolumeclaim }} in Namespace {{ $labels.namespace }} {{ with $labels.cluster -}} on Cluster {{ . }} {{- end }} is expected to run out of inodes within four days. Currently {{ $value | humanizePercentage }} of its inodes are free.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubepersistentvolumeinodesfillingup",
          "summary": "PersistentVolumeInodes are filling up."
        },
        "expr": "(\n  kubelet_volume_stats_inodes_free{job=\"kubelet\", namespace=~\".*\", metrics_path=\"/metrics\"}\n    /\n  kubelet_volume_stats_inodes{job=\"kubelet\", namespace=~\".*\", metrics_path=\"/metrics\"}\n) < 0.15\nand\nkubelet_volume_stats_inodes_used{job=\"kubelet\", namespace=~\".*\", metrics_path=\"/metrics\"} > 0\nand\npredict_linear(kubelet_volume_stats_inodes_free{job=\"kubelet\", namespace=~\".*\", metrics_path=\"/metrics\"}[6h], 4 * 24 * 3600) < 0\nunless on (cluster, namespace, persistentvolumeclaim)\nkube_persistentvolumeclaim_access_mode{ access_mode=\"ReadOnlyMany\"} == 1\nunless on (cluster, namespace, persistentvolumeclaim)\nkube_persistentvolumeclaim_labels{label_excluded_from_alerts=\"true\"} == 1",
        "for": "1h",
        "labels": {
          "severity": "warning",
          "category": categroy,
        }
      },
      {
        "alert": "KubePersistentVolumeErrors",
        "annotations": {
          "description": "The persistent volume {{ $labels.persistentvolume }} {{ with $labels.cluster -}} on Cluster {{ . }} {{- end }} has status {{ $labels.phase }}.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubepersistentvolumeerrors",
          "summary": "PersistentVolume is having issues with provisioning."
        },
        "expr": "kube_persistentvolume_status_phase{phase=~\"Failed|Pending\",job=\"kube-state-metrics\"} > 0",
        "for": "5m",
        "labels": {
          "severity": "critical",
          "category": categroy,
        }
      }
    ]
  }
]