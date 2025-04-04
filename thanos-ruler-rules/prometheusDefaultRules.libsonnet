[
  {
    "name": "alertmanager.rules",
    "rules": [
      {
        "alert": "AlertmanagerFailedReload",
        "annotations": {
          "description": "Configuration has failed to load for {{ $labels.namespace }}/{{ $labels.pod}}.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/alertmanager/alertmanagerfailedreload",
          "summary": "Reloading an Alertmanager configuration has failed."
        },
        "expr": "# Without max_over_time, failed scrapes could create false negatives, see\n# https://www.robustperception.io/alerting-on-gauges-in-prometheus-2-0 for details.\nmax_over_time(alertmanager_config_last_reload_successful{job=\"prometheus-kube-prometheus-alertmanager\",namespace=\"monitoring\"}[5m]) == 0",
        "for": "10m",
        "labels": {
          "severity": "critical"
        }
      },
      {
        "alert": "AlertmanagerMembersInconsistent",
        "annotations": {
          "description": "Alertmanager {{ $labels.namespace }}/{{ $labels.pod}} has only found {{ $value }} members of the {{$labels.job}} cluster.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/alertmanager/alertmanagermembersinconsistent",
          "summary": "A member of an Alertmanager cluster has not found all other cluster members."
        },
        "expr": "# Without max_over_time, failed scrapes could create false negatives, see\n# https://www.robustperception.io/alerting-on-gauges-in-prometheus-2-0 for details.\n  max_over_time(alertmanager_cluster_members{job=\"prometheus-kube-prometheus-alertmanager\",namespace=\"monitoring\"}[5m])\n< on (namespace,service,cluster) group_left\n  count by (namespace,service,cluster) (max_over_time(alertmanager_cluster_members{job=\"prometheus-kube-prometheus-alertmanager\",namespace=\"monitoring\"}[5m]))",
        "for": "15m",
        "labels": {
          "severity": "critical"
        }
      },
      {
        "alert": "AlertmanagerFailedToSendAlerts",
        "annotations": {
          "description": "Alertmanager {{ $labels.namespace }}/{{ $labels.pod}} failed to send {{ $value | humanizePercentage }} of notifications to {{ $labels.integration }}.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/alertmanager/alertmanagerfailedtosendalerts",
          "summary": "An Alertmanager instance failed to send notifications."
        },
        "expr": "(\n  rate(alertmanager_notifications_failed_total{job=\"prometheus-kube-prometheus-alertmanager\",namespace=\"monitoring\"}[5m])\n/\n  ignoring (reason) group_left rate(alertmanager_notifications_total{job=\"prometheus-kube-prometheus-alertmanager\",namespace=\"monitoring\"}[5m])\n)\n> 0.01",
        "for": "5m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "AlertmanagerClusterFailedToSendAlerts",
        "annotations": {
          "description": "The minimum notification failure rate to {{ $labels.integration }} sent from any instance in the {{$labels.job}} cluster is {{ $value | humanizePercentage }}.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/alertmanager/alertmanagerclusterfailedtosendalerts",
          "summary": "All Alertmanager instances in a cluster failed to send notifications to a critical integration."
        },
        "expr": "min by (namespace,service, integration) (\n  rate(alertmanager_notifications_failed_total{job=\"prometheus-kube-prometheus-alertmanager\",namespace=\"monitoring\", integration=~`.*`}[5m])\n/\n  ignoring (reason) group_left rate(alertmanager_notifications_total{job=\"prometheus-kube-prometheus-alertmanager\",namespace=\"monitoring\", integration=~`.*`}[5m])\n)\n> 0.01",
        "for": "5m",
        "labels": {
          "severity": "critical"
        }
      },
      {
        "alert": "AlertmanagerClusterFailedToSendAlerts",
        "annotations": {
          "description": "The minimum notification failure rate to {{ $labels.integration }} sent from any instance in the {{$labels.job}} cluster is {{ $value | humanizePercentage }}.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/alertmanager/alertmanagerclusterfailedtosendalerts",
          "summary": "All Alertmanager instances in a cluster failed to send notifications to a non-critical integration."
        },
        "expr": "min by (namespace,service, integration) (\n  rate(alertmanager_notifications_failed_total{job=\"prometheus-kube-prometheus-alertmanager\",namespace=\"monitoring\", integration!~`.*`}[5m])\n/\n  ignoring (reason) group_left rate(alertmanager_notifications_total{job=\"prometheus-kube-prometheus-alertmanager\",namespace=\"monitoring\", integration!~`.*`}[5m])\n)\n> 0.01",
        "for": "5m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "AlertmanagerConfigInconsistent",
        "annotations": {
          "description": "Alertmanager instances within the {{$labels.job}} cluster have different configurations.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/alertmanager/alertmanagerconfiginconsistent",
          "summary": "Alertmanager instances within the same cluster have different configurations."
        },
        "expr": "count by (namespace,service,cluster) (\n  count_values by (namespace,service,cluster) (\"config_hash\", alertmanager_config_hash{job=\"prometheus-kube-prometheus-alertmanager\",namespace=\"monitoring\"})\n)\n!= 1",
        "for": "20m",
        "labels": {
          "severity": "critical"
        }
      },
      {
        "alert": "AlertmanagerClusterDown",
        "annotations": {
          "description": "{{ $value | humanizePercentage }} of Alertmanager instances within the {{$labels.job}} cluster have been up for less than half of the last 5m.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/alertmanager/alertmanagerclusterdown",
          "summary": "Half or more of the Alertmanager instances within the same cluster are down."
        },
        "expr": "(\n  count by (namespace,service,cluster) (\n    avg_over_time(up{job=\"prometheus-kube-prometheus-alertmanager\",namespace=\"monitoring\"}[5m]) < 0.5\n  )\n/\n  count by (namespace,service,cluster) (\n    up{job=\"prometheus-kube-prometheus-alertmanager\",namespace=\"monitoring\"}\n  )\n)\n>= 0.5",
        "for": "5m",
        "labels": {
          "severity": "critical"
        }
      },
      {
        "alert": "AlertmanagerClusterCrashlooping",
        "annotations": {
          "description": "{{ $value | humanizePercentage }} of Alertmanager instances within the {{$labels.job}} cluster have restarted at least 5 times in the last 10m.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/alertmanager/alertmanagerclustercrashlooping",
          "summary": "Half or more of the Alertmanager instances within the same cluster are crashlooping."
        },
        "expr": "(\n  count by (namespace,service,cluster) (\n    changes(process_start_time_seconds{job=\"prometheus-kube-prometheus-alertmanager\",namespace=\"monitoring\"}[10m]) > 4\n  )\n/\n  count by (namespace,service,cluster) (\n    up{job=\"prometheus-kube-prometheus-alertmanager\",namespace=\"monitoring\"}\n  )\n)\n>= 0.5",
        "for": "5m",
        "labels": {
          "severity": "critical"
        }
      }
    ]
  }
,
  {
    "name": "config-reloaders",
    "rules": [
      {
        "alert": "ConfigReloaderSidecarErrors",
        "annotations": {
          "description": "Errors encountered while the {{$labels.pod}} config-reloader sidecar attempts to sync config in {{$labels.namespace}} namespace.\nAs a result, configuration for service running in {{$labels.pod}} may be stale and cannot be updated anymore.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/prometheus-operator/configreloadersidecarerrors",
          "summary": "config-reloader sidecar has not had a successful reload for 10m"
        },
        "expr": "max_over_time(reloader_last_reload_successful{namespace=~\".+\"}[5m]) == 0",
        "for": "10m",
        "labels": {
          "severity": "warning"
        }
      }
    ]
  }
,
  {
    "name": "etcd",
    "rules": [
      {
        "alert": "etcdMembersDown",
        "annotations": {
          "description": "etcd cluster \"{{ $labels.job }}\": members are down ({{ $value }}).",
          "summary": "etcd cluster members are down."
        },
        "expr": "max without (endpoint) (\n  sum without (instance) (up{job=~\".*etcd.*\"} == bool 0)\nor\n  count without (To) (\n    sum without (instance) (rate(etcd_network_peer_sent_failures_total{job=~\".*etcd.*\"}[120s])) > 0.01\n  )\n)\n> 0",
        "for": "10m",
        "labels": {
          "severity": "critical"
        }
      },
      {
        "alert": "etcdInsufficientMembers",
        "annotations": {
          "description": "etcd cluster \"{{ $labels.job }}\": insufficient members ({{ $value }}).",
          "summary": "etcd cluster has insufficient number of members."
        },
        "expr": "sum(up{job=~\".*etcd.*\"} == bool 1) without (instance) < ((count(up{job=~\".*etcd.*\"}) without (instance) + 1) / 2)",
        "for": "3m",
        "labels": {
          "severity": "critical"
        }
      },
      {
        "alert": "etcdNoLeader",
        "annotations": {
          "description": "etcd cluster \"{{ $labels.job }}\": member {{ $labels.instance }} has no leader.",
          "summary": "etcd cluster has no leader."
        },
        "expr": "etcd_server_has_leader{job=~\".*etcd.*\"} == 0",
        "for": "1m",
        "labels": {
          "severity": "critical"
        }
      },
      {
        "alert": "etcdHighNumberOfLeaderChanges",
        "annotations": {
          "description": "etcd cluster \"{{ $labels.job }}\": {{ $value }} leader changes within the last 15 minutes. Frequent elections may be a sign of insufficient resources, high network latency, or disruptions by other components and should be investigated.",
          "summary": "etcd cluster has high number of leader changes."
        },
        "expr": "increase((max without (instance) (etcd_server_leader_changes_seen_total{job=~\".*etcd.*\"}) or 0*absent(etcd_server_leader_changes_seen_total{job=~\".*etcd.*\"}))[15m:1m]) >= 4",
        "for": "5m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "etcdHighNumberOfFailedGRPCRequests",
        "annotations": {
          "description": "etcd cluster \"{{ $labels.job }}\": {{ $value }}% of requests for {{ $labels.grpc_method }} failed on etcd instance {{ $labels.instance }}.",
          "summary": "etcd cluster has high number of failed grpc requests."
        },
        "expr": "100 * sum(rate(grpc_server_handled_total{job=~\".*etcd.*\", grpc_code=~\"Unknown|FailedPrecondition|ResourceExhausted|Internal|Unavailable|DataLoss|DeadlineExceeded\"}[5m])) without (grpc_type, grpc_code)\n  /\nsum(rate(grpc_server_handled_total{job=~\".*etcd.*\"}[5m])) without (grpc_type, grpc_code)\n  > 1",
        "for": "10m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "etcdHighNumberOfFailedGRPCRequests",
        "annotations": {
          "description": "etcd cluster \"{{ $labels.job }}\": {{ $value }}% of requests for {{ $labels.grpc_method }} failed on etcd instance {{ $labels.instance }}.",
          "summary": "etcd cluster has high number of failed grpc requests."
        },
        "expr": "100 * sum(rate(grpc_server_handled_total{job=~\".*etcd.*\", grpc_code=~\"Unknown|FailedPrecondition|ResourceExhausted|Internal|Unavailable|DataLoss|DeadlineExceeded\"}[5m])) without (grpc_type, grpc_code)\n  /\nsum(rate(grpc_server_handled_total{job=~\".*etcd.*\"}[5m])) without (grpc_type, grpc_code)\n  > 5",
        "for": "5m",
        "labels": {
          "severity": "critical"
        }
      },
      {
        "alert": "etcdGRPCRequestsSlow",
        "annotations": {
          "description": "etcd cluster \"{{ $labels.job }}\": 99th percentile of gRPC requests is {{ $value }}s on etcd instance {{ $labels.instance }} for {{ $labels.grpc_method }} method.",
          "summary": "etcd grpc requests are slow"
        },
        "expr": "histogram_quantile(0.99, sum(rate(grpc_server_handling_seconds_bucket{job=~\".*etcd.*\", grpc_method!=\"Defragment\", grpc_type=\"unary\"}[5m])) without(grpc_type))\n> 0.15",
        "for": "10m",
        "labels": {
          "severity": "critical"
        }
      },
      {
        "alert": "etcdMemberCommunicationSlow",
        "annotations": {
          "description": "etcd cluster \"{{ $labels.job }}\": member communication with {{ $labels.To }} is taking {{ $value }}s on etcd instance {{ $labels.instance }}.",
          "summary": "etcd cluster member communication is slow."
        },
        "expr": "histogram_quantile(0.99, rate(etcd_network_peer_round_trip_time_seconds_bucket{job=~\".*etcd.*\"}[5m]))\n> 0.15",
        "for": "10m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "etcdHighNumberOfFailedProposals",
        "annotations": {
          "description": "etcd cluster \"{{ $labels.job }}\": {{ $value }} proposal failures within the last 30 minutes on etcd instance {{ $labels.instance }}.",
          "summary": "etcd cluster has high number of proposal failures."
        },
        "expr": "rate(etcd_server_proposals_failed_total{job=~\".*etcd.*\"}[15m]) > 5",
        "for": "15m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "etcdHighFsyncDurations",
        "annotations": {
          "description": "etcd cluster \"{{ $labels.job }}\": 99th percentile fsync durations are {{ $value }}s on etcd instance {{ $labels.instance }}.",
          "summary": "etcd cluster 99th percentile fsync durations are too high."
        },
        "expr": "histogram_quantile(0.99, rate(etcd_disk_wal_fsync_duration_seconds_bucket{job=~\".*etcd.*\"}[5m]))\n> 0.5",
        "for": "10m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "etcdHighFsyncDurations",
        "annotations": {
          "description": "etcd cluster \"{{ $labels.job }}\": 99th percentile fsync durations are {{ $value }}s on etcd instance {{ $labels.instance }}.",
          "summary": "etcd cluster 99th percentile fsync durations are too high."
        },
        "expr": "histogram_quantile(0.99, rate(etcd_disk_wal_fsync_duration_seconds_bucket{job=~\".*etcd.*\"}[5m]))\n> 1",
        "for": "10m",
        "labels": {
          "severity": "critical"
        }
      },
      {
        "alert": "etcdHighCommitDurations",
        "annotations": {
          "description": "etcd cluster \"{{ $labels.job }}\": 99th percentile commit durations {{ $value }}s on etcd instance {{ $labels.instance }}.",
          "summary": "etcd cluster 99th percentile commit durations are too high."
        },
        "expr": "histogram_quantile(0.99, rate(etcd_disk_backend_commit_duration_seconds_bucket{job=~\".*etcd.*\"}[5m]))\n> 0.25",
        "for": "10m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "etcdDatabaseQuotaLowSpace",
        "annotations": {
          "description": "etcd cluster \"{{ $labels.job }}\": database size exceeds the defined quota on etcd instance {{ $labels.instance }}, please defrag or increase the quota as the writes to etcd will be disabled when it is full.",
          "summary": "etcd cluster database is running full."
        },
        "expr": "(last_over_time(etcd_mvcc_db_total_size_in_bytes{job=~\".*etcd.*\"}[5m]) / last_over_time(etcd_server_quota_backend_bytes{job=~\".*etcd.*\"}[5m]))*100 > 95",
        "for": "10m",
        "labels": {
          "severity": "critical"
        }
      },
      {
        "alert": "etcdExcessiveDatabaseGrowth",
        "annotations": {
          "description": "etcd cluster \"{{ $labels.job }}\": Predicting running out of disk space in the next four hours, based on write observations within the past four hours on etcd instance {{ $labels.instance }}, please check as it might be disruptive.",
          "summary": "etcd cluster database growing very fast."
        },
        "expr": "predict_linear(etcd_mvcc_db_total_size_in_bytes{job=~\".*etcd.*\"}[4h], 4*60*60) > etcd_server_quota_backend_bytes{job=~\".*etcd.*\"}",
        "for": "10m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "etcdDatabaseHighFragmentationRatio",
        "annotations": {
          "description": "etcd cluster \"{{ $labels.job }}\": database size in use on instance {{ $labels.instance }} is {{ $value | humanizePercentage }} of the actual allocated disk space, please run defragmentation (e.g. etcdctl defrag) to retrieve the unused fragmented disk space.",
          "runbook_url": "https://etcd.io/docs/v3.5/op-guide/maintenance/#defragmentation",
          "summary": "etcd database size in use is less than 50% of the actual allocated storage."
        },
        "expr": "(last_over_time(etcd_mvcc_db_total_size_in_use_in_bytes{job=~\".*etcd.*\"}[5m]) / last_over_time(etcd_mvcc_db_total_size_in_bytes{job=~\".*etcd.*\"}[5m])) < 0.5 and etcd_mvcc_db_total_size_in_use_in_bytes{job=~\".*etcd.*\"} > 104857600",
        "for": "10m",
        "labels": {
          "severity": "warning"
        }
      }
    ]
  }
,
  {
    "name": "general.rules",
    "rules": [
      {
        "alert": "TargetDown",
        "annotations": {
          "description": "{{ printf \"%.4g\" $value }}% of the {{ $labels.job }}/{{ $labels.service }} targets in {{ $labels.namespace }} namespace are down.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/general/targetdown",
          "summary": "One or more targets are unreachable."
        },
        "expr": "100 * (count(up == 0) BY (cluster, job, namespace, service) / count(up) BY (cluster, job, namespace, service)) > 10",
        "for": "10m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "Watchdog",
        "annotations": {
          "description": "This is an alert meant to ensure that the entire alerting pipeline is functional.\nThis alert is always firing, therefore it should always be firing in Alertmanager\nand always fire against a receiver. There are integrations with various notification\nmechanisms that send a notification when this alert is not firing. For example the\n\"DeadMansSnitch\" integration in PagerDuty.\n",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/general/watchdog",
          "summary": "An alert that should always be firing to certify that Alertmanager is working properly."
        },
        "expr": "vector(1)",
        "labels": {
          "severity": "none"
        }
      },
      {
        "alert": "InfoInhibitor",
        "annotations": {
          "description": "This is an alert that is used to inhibit info alerts.\nBy themselves, the info-level alerts are sometimes very noisy, but they are relevant when combined with\nother alerts.\nThis alert fires whenever there's a severity=\"info\" alert, and stops firing when another alert with a\nseverity of 'warning' or 'critical' starts firing on the same namespace.\nThis alert should be routed to a null receiver and configured to inhibit alerts with severity=\"info\".\n",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/general/infoinhibitor",
          "summary": "Info-level alert inhibition."
        },
        "expr": "ALERTS{severity = \"info\"} == 1 unless on (namespace) ALERTS{alertname != \"InfoInhibitor\", severity =~ \"warning|critical\", alertstate=\"firing\"} == 1",
        "labels": {
          "severity": "none"
        }
      }
    ]
  }
,
  {
    "name": "k8s.rules.container_cpu_usage_seconds_total",
    "rules": [
      {
        "expr": "sum by (cluster, namespace, pod, container) (\n  irate(container_cpu_usage_seconds_total{job=\"kubelet\", metrics_path=\"/metrics/cadvisor\", image!=\"\"}[5m])\n) * on (cluster, namespace, pod) group_left(node) topk by (cluster, namespace, pod) (\n  1, max by (cluster, namespace, pod, node) (kube_pod_info{node!=\"\"})\n)",
        "record": "node_namespace_pod_container:container_cpu_usage_seconds_total:sum_irate"
      }
    ]
  }
,
  {
    "name": "k8s.rules.container_memory_cache",
    "rules": [
      {
        "expr": "container_memory_cache{job=\"kubelet\", metrics_path=\"/metrics/cadvisor\", image!=\"\"}\n* on (cluster, namespace, pod) group_left(node) topk by (cluster, namespace, pod) (1,\n  max by (cluster, namespace, pod, node) (kube_pod_info{node!=\"\"})\n)",
        "record": "node_namespace_pod_container:container_memory_cache"
      }
    ]
  }
,
  {
    "name": "k8s.rules.container_memory_rss",
    "rules": [
      {
        "expr": "container_memory_rss{job=\"kubelet\", metrics_path=\"/metrics/cadvisor\", image!=\"\"}\n* on (cluster, namespace, pod) group_left(node) topk by (cluster, namespace, pod) (1,\n  max by (cluster, namespace, pod, node) (kube_pod_info{node!=\"\"})\n)",
        "record": "node_namespace_pod_container:container_memory_rss"
      }
    ]
  }
,
  {
    "name": "k8s.rules.container_memory_swap",
    "rules": [
      {
        "expr": "container_memory_swap{job=\"kubelet\", metrics_path=\"/metrics/cadvisor\", image!=\"\"}\n* on (cluster, namespace, pod) group_left(node) topk by (cluster, namespace, pod) (1,\n  max by (cluster, namespace, pod, node) (kube_pod_info{node!=\"\"})\n)",
        "record": "node_namespace_pod_container:container_memory_swap"
      }
    ]
  }
,
  {
    "name": "k8s.rules.container_memory_working_set_bytes",
    "rules": [
      {
        "expr": "container_memory_working_set_bytes{job=\"kubelet\", metrics_path=\"/metrics/cadvisor\", image!=\"\"}\n* on (cluster, namespace, pod) group_left(node) topk by (cluster, namespace, pod) (1,\n  max by (cluster, namespace, pod, node) (kube_pod_info{node!=\"\"})\n)",
        "record": "node_namespace_pod_container:container_memory_working_set_bytes"
      }
    ]
  }
,
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
,
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
,
  {
    "interval": "3m",
    "name": "kube-apiserver-availability.rules",
    "rules": [
      {
        "expr": "avg_over_time(code_verb:apiserver_request_total:increase1h[30d]) * 24 * 30",
        "record": "code_verb:apiserver_request_total:increase30d"
      },
      {
        "expr": "sum by (cluster, code) (code_verb:apiserver_request_total:increase30d{verb=~\"LIST|GET\"})",
        "labels": {
          "verb": "read"
        },
        "record": "code:apiserver_request_total:increase30d"
      },
      {
        "expr": "sum by (cluster, code) (code_verb:apiserver_request_total:increase30d{verb=~\"POST|PUT|PATCH|DELETE\"})",
        "labels": {
          "verb": "write"
        },
        "record": "code:apiserver_request_total:increase30d"
      },
      {
        "expr": "sum by (cluster, verb, scope) (increase(apiserver_request_sli_duration_seconds_count{job=\"apiserver\"}[1h]))",
        "record": "cluster_verb_scope:apiserver_request_sli_duration_seconds_count:increase1h"
      },
      {
        "expr": "sum by (cluster, verb, scope) (avg_over_time(cluster_verb_scope:apiserver_request_sli_duration_seconds_count:increase1h[30d]) * 24 * 30)",
        "record": "cluster_verb_scope:apiserver_request_sli_duration_seconds_count:increase30d"
      },
      {
        "expr": "sum by (cluster, verb, scope, le) (increase(apiserver_request_sli_duration_seconds_bucket[1h]))",
        "record": "cluster_verb_scope_le:apiserver_request_sli_duration_seconds_bucket:increase1h"
      },
      {
        "expr": "sum by (cluster, verb, scope, le) (avg_over_time(cluster_verb_scope_le:apiserver_request_sli_duration_seconds_bucket:increase1h[30d]) * 24 * 30)",
        "record": "cluster_verb_scope_le:apiserver_request_sli_duration_seconds_bucket:increase30d"
      },
      {
        "expr": "1 - (\n  (\n    # write too slow\n    sum by (cluster) (cluster_verb_scope:apiserver_request_sli_duration_seconds_count:increase30d{verb=~\"POST|PUT|PATCH|DELETE\"})\n    -\n    sum by (cluster) (cluster_verb_scope_le:apiserver_request_sli_duration_seconds_bucket:increase30d{verb=~\"POST|PUT|PATCH|DELETE\",le=\"1\"})\n  ) +\n  (\n    # read too slow\n    sum by (cluster) (cluster_verb_scope:apiserver_request_sli_duration_seconds_count:increase30d{verb=~\"LIST|GET\"})\n    -\n    (\n      (\n        sum by (cluster) (cluster_verb_scope_le:apiserver_request_sli_duration_seconds_bucket:increase30d{verb=~\"LIST|GET\",scope=~\"resource|\",le=\"1\"})\n        or\n        vector(0)\n      )\n      +\n      sum by (cluster) (cluster_verb_scope_le:apiserver_request_sli_duration_seconds_bucket:increase30d{verb=~\"LIST|GET\",scope=\"namespace\",le=\"5\"})\n      +\n      sum by (cluster) (cluster_verb_scope_le:apiserver_request_sli_duration_seconds_bucket:increase30d{verb=~\"LIST|GET\",scope=\"cluster\",le=\"30\"})\n    )\n  ) +\n  # errors\n  sum by (cluster) (code:apiserver_request_total:increase30d{code=~\"5..\"} or vector(0))\n)\n/\nsum by (cluster) (code:apiserver_request_total:increase30d)",
        "labels": {
          "verb": "all"
        },
        "record": "apiserver_request:availability30d"
      },
      {
        "expr": "1 - (\n  sum by (cluster) (cluster_verb_scope:apiserver_request_sli_duration_seconds_count:increase30d{verb=~\"LIST|GET\"})\n  -\n  (\n    # too slow\n    (\n      sum by (cluster) (cluster_verb_scope_le:apiserver_request_sli_duration_seconds_bucket:increase30d{verb=~\"LIST|GET\",scope=~\"resource|\",le=\"1\"})\n      or\n      vector(0)\n    )\n    +\n    sum by (cluster) (cluster_verb_scope_le:apiserver_request_sli_duration_seconds_bucket:increase30d{verb=~\"LIST|GET\",scope=\"namespace\",le=\"5\"})\n    +\n    sum by (cluster) (cluster_verb_scope_le:apiserver_request_sli_duration_seconds_bucket:increase30d{verb=~\"LIST|GET\",scope=\"cluster\",le=\"30\"})\n  )\n  +\n  # errors\n  sum by (cluster) (code:apiserver_request_total:increase30d{verb=\"read\",code=~\"5..\"} or vector(0))\n)\n/\nsum by (cluster) (code:apiserver_request_total:increase30d{verb=\"read\"})",
        "labels": {
          "verb": "read"
        },
        "record": "apiserver_request:availability30d"
      },
      {
        "expr": "1 - (\n  (\n    # too slow\n    sum by (cluster) (cluster_verb_scope:apiserver_request_sli_duration_seconds_count:increase30d{verb=~\"POST|PUT|PATCH|DELETE\"})\n    -\n    sum by (cluster) (cluster_verb_scope_le:apiserver_request_sli_duration_seconds_bucket:increase30d{verb=~\"POST|PUT|PATCH|DELETE\",le=\"1\"})\n  )\n  +\n  # errors\n  sum by (cluster) (code:apiserver_request_total:increase30d{verb=\"write\",code=~\"5..\"} or vector(0))\n)\n/\nsum by (cluster) (code:apiserver_request_total:increase30d{verb=\"write\"})",
        "labels": {
          "verb": "write"
        },
        "record": "apiserver_request:availability30d"
      },
      {
        "expr": "sum by (cluster,code,resource) (rate(apiserver_request_total{job=\"apiserver\",verb=~\"LIST|GET\"}[5m]))",
        "labels": {
          "verb": "read"
        },
        "record": "code_resource:apiserver_request_total:rate5m"
      },
      {
        "expr": "sum by (cluster,code,resource) (rate(apiserver_request_total{job=\"apiserver\",verb=~\"POST|PUT|PATCH|DELETE\"}[5m]))",
        "labels": {
          "verb": "write"
        },
        "record": "code_resource:apiserver_request_total:rate5m"
      },
      {
        "expr": "sum by (cluster, code, verb) (increase(apiserver_request_total{job=\"apiserver\",verb=~\"LIST|GET|POST|PUT|PATCH|DELETE\",code=~\"2..\"}[1h]))",
        "record": "code_verb:apiserver_request_total:increase1h"
      },
      {
        "expr": "sum by (cluster, code, verb) (increase(apiserver_request_total{job=\"apiserver\",verb=~\"LIST|GET|POST|PUT|PATCH|DELETE\",code=~\"3..\"}[1h]))",
        "record": "code_verb:apiserver_request_total:increase1h"
      },
      {
        "expr": "sum by (cluster, code, verb) (increase(apiserver_request_total{job=\"apiserver\",verb=~\"LIST|GET|POST|PUT|PATCH|DELETE\",code=~\"4..\"}[1h]))",
        "record": "code_verb:apiserver_request_total:increase1h"
      },
      {
        "expr": "sum by (cluster, code, verb) (increase(apiserver_request_total{job=\"apiserver\",verb=~\"LIST|GET|POST|PUT|PATCH|DELETE\",code=~\"5..\"}[1h]))",
        "record": "code_verb:apiserver_request_total:increase1h"
      }
    ]
  }
,
  {
    "name": "kube-apiserver-burnrate.rules",
    "rules": [
      {
        "expr": "(\n  (\n    # too slow\n    sum by (cluster) (rate(apiserver_request_sli_duration_seconds_count{job=\"apiserver\",verb=~\"LIST|GET\",subresource!~\"proxy|attach|log|exec|portforward\"}[1d]))\n    -\n    (\n      (\n        sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job=\"apiserver\",verb=~\"LIST|GET\",subresource!~\"proxy|attach|log|exec|portforward\",scope=~\"resource|\",le=\"1\"}[1d]))\n        or\n        vector(0)\n      )\n      +\n      sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job=\"apiserver\",verb=~\"LIST|GET\",subresource!~\"proxy|attach|log|exec|portforward\",scope=\"namespace\",le=\"5\"}[1d]))\n      +\n      sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job=\"apiserver\",verb=~\"LIST|GET\",subresource!~\"proxy|attach|log|exec|portforward\",scope=\"cluster\",le=\"30\"}[1d]))\n    )\n  )\n  +\n  # errors\n  sum by (cluster) (rate(apiserver_request_total{job=\"apiserver\",verb=~\"LIST|GET\",code=~\"5..\"}[1d]))\n)\n/\nsum by (cluster) (rate(apiserver_request_total{job=\"apiserver\",verb=~\"LIST|GET\"}[1d]))",
        "labels": {
          "verb": "read"
        },
        "record": "apiserver_request:burnrate1d"
      },
      {
        "expr": "(\n  (\n    # too slow\n    sum by (cluster) (rate(apiserver_request_sli_duration_seconds_count{job=\"apiserver\",verb=~\"LIST|GET\",subresource!~\"proxy|attach|log|exec|portforward\"}[1h]))\n    -\n    (\n      (\n        sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job=\"apiserver\",verb=~\"LIST|GET\",subresource!~\"proxy|attach|log|exec|portforward\",scope=~\"resource|\",le=\"1\"}[1h]))\n        or\n        vector(0)\n      )\n      +\n      sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job=\"apiserver\",verb=~\"LIST|GET\",subresource!~\"proxy|attach|log|exec|portforward\",scope=\"namespace\",le=\"5\"}[1h]))\n      +\n      sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job=\"apiserver\",verb=~\"LIST|GET\",subresource!~\"proxy|attach|log|exec|portforward\",scope=\"cluster\",le=\"30\"}[1h]))\n    )\n  )\n  +\n  # errors\n  sum by (cluster) (rate(apiserver_request_total{job=\"apiserver\",verb=~\"LIST|GET\",code=~\"5..\"}[1h]))\n)\n/\nsum by (cluster) (rate(apiserver_request_total{job=\"apiserver\",verb=~\"LIST|GET\"}[1h]))",
        "labels": {
          "verb": "read"
        },
        "record": "apiserver_request:burnrate1h"
      },
      {
        "expr": "(\n  (\n    # too slow\n    sum by (cluster) (rate(apiserver_request_sli_duration_seconds_count{job=\"apiserver\",verb=~\"LIST|GET\",subresource!~\"proxy|attach|log|exec|portforward\"}[2h]))\n    -\n    (\n      (\n        sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job=\"apiserver\",verb=~\"LIST|GET\",subresource!~\"proxy|attach|log|exec|portforward\",scope=~\"resource|\",le=\"1\"}[2h]))\n        or\n        vector(0)\n      )\n      +\n      sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job=\"apiserver\",verb=~\"LIST|GET\",subresource!~\"proxy|attach|log|exec|portforward\",scope=\"namespace\",le=\"5\"}[2h]))\n      +\n      sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job=\"apiserver\",verb=~\"LIST|GET\",subresource!~\"proxy|attach|log|exec|portforward\",scope=\"cluster\",le=\"30\"}[2h]))\n    )\n  )\n  +\n  # errors\n  sum by (cluster) (rate(apiserver_request_total{job=\"apiserver\",verb=~\"LIST|GET\",code=~\"5..\"}[2h]))\n)\n/\nsum by (cluster) (rate(apiserver_request_total{job=\"apiserver\",verb=~\"LIST|GET\"}[2h]))",
        "labels": {
          "verb": "read"
        },
        "record": "apiserver_request:burnrate2h"
      },
      {
        "expr": "(\n  (\n    # too slow\n    sum by (cluster) (rate(apiserver_request_sli_duration_seconds_count{job=\"apiserver\",verb=~\"LIST|GET\",subresource!~\"proxy|attach|log|exec|portforward\"}[30m]))\n    -\n    (\n      (\n        sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job=\"apiserver\",verb=~\"LIST|GET\",subresource!~\"proxy|attach|log|exec|portforward\",scope=~\"resource|\",le=\"1\"}[30m]))\n        or\n        vector(0)\n      )\n      +\n      sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job=\"apiserver\",verb=~\"LIST|GET\",subresource!~\"proxy|attach|log|exec|portforward\",scope=\"namespace\",le=\"5\"}[30m]))\n      +\n      sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job=\"apiserver\",verb=~\"LIST|GET\",subresource!~\"proxy|attach|log|exec|portforward\",scope=\"cluster\",le=\"30\"}[30m]))\n    )\n  )\n  +\n  # errors\n  sum by (cluster) (rate(apiserver_request_total{job=\"apiserver\",verb=~\"LIST|GET\",code=~\"5..\"}[30m]))\n)\n/\nsum by (cluster) (rate(apiserver_request_total{job=\"apiserver\",verb=~\"LIST|GET\"}[30m]))",
        "labels": {
          "verb": "read"
        },
        "record": "apiserver_request:burnrate30m"
      },
      {
        "expr": "(\n  (\n    # too slow\n    sum by (cluster) (rate(apiserver_request_sli_duration_seconds_count{job=\"apiserver\",verb=~\"LIST|GET\",subresource!~\"proxy|attach|log|exec|portforward\"}[3d]))\n    -\n    (\n      (\n        sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job=\"apiserver\",verb=~\"LIST|GET\",subresource!~\"proxy|attach|log|exec|portforward\",scope=~\"resource|\",le=\"1\"}[3d]))\n        or\n        vector(0)\n      )\n      +\n      sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job=\"apiserver\",verb=~\"LIST|GET\",subresource!~\"proxy|attach|log|exec|portforward\",scope=\"namespace\",le=\"5\"}[3d]))\n      +\n      sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job=\"apiserver\",verb=~\"LIST|GET\",subresource!~\"proxy|attach|log|exec|portforward\",scope=\"cluster\",le=\"30\"}[3d]))\n    )\n  )\n  +\n  # errors\n  sum by (cluster) (rate(apiserver_request_total{job=\"apiserver\",verb=~\"LIST|GET\",code=~\"5..\"}[3d]))\n)\n/\nsum by (cluster) (rate(apiserver_request_total{job=\"apiserver\",verb=~\"LIST|GET\"}[3d]))",
        "labels": {
          "verb": "read"
        },
        "record": "apiserver_request:burnrate3d"
      },
      {
        "expr": "(\n  (\n    # too slow\n    sum by (cluster) (rate(apiserver_request_sli_duration_seconds_count{job=\"apiserver\",verb=~\"LIST|GET\",subresource!~\"proxy|attach|log|exec|portforward\"}[5m]))\n    -\n    (\n      (\n        sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job=\"apiserver\",verb=~\"LIST|GET\",subresource!~\"proxy|attach|log|exec|portforward\",scope=~\"resource|\",le=\"1\"}[5m]))\n        or\n        vector(0)\n      )\n      +\n      sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job=\"apiserver\",verb=~\"LIST|GET\",subresource!~\"proxy|attach|log|exec|portforward\",scope=\"namespace\",le=\"5\"}[5m]))\n      +\n      sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job=\"apiserver\",verb=~\"LIST|GET\",subresource!~\"proxy|attach|log|exec|portforward\",scope=\"cluster\",le=\"30\"}[5m]))\n    )\n  )\n  +\n  # errors\n  sum by (cluster) (rate(apiserver_request_total{job=\"apiserver\",verb=~\"LIST|GET\",code=~\"5..\"}[5m]))\n)\n/\nsum by (cluster) (rate(apiserver_request_total{job=\"apiserver\",verb=~\"LIST|GET\"}[5m]))",
        "labels": {
          "verb": "read"
        },
        "record": "apiserver_request:burnrate5m"
      },
      {
        "expr": "(\n  (\n    # too slow\n    sum by (cluster) (rate(apiserver_request_sli_duration_seconds_count{job=\"apiserver\",verb=~\"LIST|GET\",subresource!~\"proxy|attach|log|exec|portforward\"}[6h]))\n    -\n    (\n      (\n        sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job=\"apiserver\",verb=~\"LIST|GET\",subresource!~\"proxy|attach|log|exec|portforward\",scope=~\"resource|\",le=\"1\"}[6h]))\n        or\n        vector(0)\n      )\n      +\n      sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job=\"apiserver\",verb=~\"LIST|GET\",subresource!~\"proxy|attach|log|exec|portforward\",scope=\"namespace\",le=\"5\"}[6h]))\n      +\n      sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job=\"apiserver\",verb=~\"LIST|GET\",subresource!~\"proxy|attach|log|exec|portforward\",scope=\"cluster\",le=\"30\"}[6h]))\n    )\n  )\n  +\n  # errors\n  sum by (cluster) (rate(apiserver_request_total{job=\"apiserver\",verb=~\"LIST|GET\",code=~\"5..\"}[6h]))\n)\n/\nsum by (cluster) (rate(apiserver_request_total{job=\"apiserver\",verb=~\"LIST|GET\"}[6h]))",
        "labels": {
          "verb": "read"
        },
        "record": "apiserver_request:burnrate6h"
      },
      {
        "expr": "(\n  (\n    # too slow\n    sum by (cluster) (rate(apiserver_request_sli_duration_seconds_count{job=\"apiserver\",verb=~\"POST|PUT|PATCH|DELETE\",subresource!~\"proxy|attach|log|exec|portforward\"}[1d]))\n    -\n    sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job=\"apiserver\",verb=~\"POST|PUT|PATCH|DELETE\",subresource!~\"proxy|attach|log|exec|portforward\",le=\"1\"}[1d]))\n  )\n  +\n  sum by (cluster) (rate(apiserver_request_total{job=\"apiserver\",verb=~\"POST|PUT|PATCH|DELETE\",code=~\"5..\"}[1d]))\n)\n/\nsum by (cluster) (rate(apiserver_request_total{job=\"apiserver\",verb=~\"POST|PUT|PATCH|DELETE\"}[1d]))",
        "labels": {
          "verb": "write"
        },
        "record": "apiserver_request:burnrate1d"
      },
      {
        "expr": "(\n  (\n    # too slow\n    sum by (cluster) (rate(apiserver_request_sli_duration_seconds_count{job=\"apiserver\",verb=~\"POST|PUT|PATCH|DELETE\",subresource!~\"proxy|attach|log|exec|portforward\"}[1h]))\n    -\n    sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job=\"apiserver\",verb=~\"POST|PUT|PATCH|DELETE\",subresource!~\"proxy|attach|log|exec|portforward\",le=\"1\"}[1h]))\n  )\n  +\n  sum by (cluster) (rate(apiserver_request_total{job=\"apiserver\",verb=~\"POST|PUT|PATCH|DELETE\",code=~\"5..\"}[1h]))\n)\n/\nsum by (cluster) (rate(apiserver_request_total{job=\"apiserver\",verb=~\"POST|PUT|PATCH|DELETE\"}[1h]))",
        "labels": {
          "verb": "write"
        },
        "record": "apiserver_request:burnrate1h"
      },
      {
        "expr": "(\n  (\n    # too slow\n    sum by (cluster) (rate(apiserver_request_sli_duration_seconds_count{job=\"apiserver\",verb=~\"POST|PUT|PATCH|DELETE\",subresource!~\"proxy|attach|log|exec|portforward\"}[2h]))\n    -\n    sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job=\"apiserver\",verb=~\"POST|PUT|PATCH|DELETE\",subresource!~\"proxy|attach|log|exec|portforward\",le=\"1\"}[2h]))\n  )\n  +\n  sum by (cluster) (rate(apiserver_request_total{job=\"apiserver\",verb=~\"POST|PUT|PATCH|DELETE\",code=~\"5..\"}[2h]))\n)\n/\nsum by (cluster) (rate(apiserver_request_total{job=\"apiserver\",verb=~\"POST|PUT|PATCH|DELETE\"}[2h]))",
        "labels": {
          "verb": "write"
        },
        "record": "apiserver_request:burnrate2h"
      },
      {
        "expr": "(\n  (\n    # too slow\n    sum by (cluster) (rate(apiserver_request_sli_duration_seconds_count{job=\"apiserver\",verb=~\"POST|PUT|PATCH|DELETE\",subresource!~\"proxy|attach|log|exec|portforward\"}[30m]))\n    -\n    sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job=\"apiserver\",verb=~\"POST|PUT|PATCH|DELETE\",subresource!~\"proxy|attach|log|exec|portforward\",le=\"1\"}[30m]))\n  )\n  +\n  sum by (cluster) (rate(apiserver_request_total{job=\"apiserver\",verb=~\"POST|PUT|PATCH|DELETE\",code=~\"5..\"}[30m]))\n)\n/\nsum by (cluster) (rate(apiserver_request_total{job=\"apiserver\",verb=~\"POST|PUT|PATCH|DELETE\"}[30m]))",
        "labels": {
          "verb": "write"
        },
        "record": "apiserver_request:burnrate30m"
      },
      {
        "expr": "(\n  (\n    # too slow\n    sum by (cluster) (rate(apiserver_request_sli_duration_seconds_count{job=\"apiserver\",verb=~\"POST|PUT|PATCH|DELETE\",subresource!~\"proxy|attach|log|exec|portforward\"}[3d]))\n    -\n    sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job=\"apiserver\",verb=~\"POST|PUT|PATCH|DELETE\",subresource!~\"proxy|attach|log|exec|portforward\",le=\"1\"}[3d]))\n  )\n  +\n  sum by (cluster) (rate(apiserver_request_total{job=\"apiserver\",verb=~\"POST|PUT|PATCH|DELETE\",code=~\"5..\"}[3d]))\n)\n/\nsum by (cluster) (rate(apiserver_request_total{job=\"apiserver\",verb=~\"POST|PUT|PATCH|DELETE\"}[3d]))",
        "labels": {
          "verb": "write"
        },
        "record": "apiserver_request:burnrate3d"
      },
      {
        "expr": "(\n  (\n    # too slow\n    sum by (cluster) (rate(apiserver_request_sli_duration_seconds_count{job=\"apiserver\",verb=~\"POST|PUT|PATCH|DELETE\",subresource!~\"proxy|attach|log|exec|portforward\"}[5m]))\n    -\n    sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job=\"apiserver\",verb=~\"POST|PUT|PATCH|DELETE\",subresource!~\"proxy|attach|log|exec|portforward\",le=\"1\"}[5m]))\n  )\n  +\n  sum by (cluster) (rate(apiserver_request_total{job=\"apiserver\",verb=~\"POST|PUT|PATCH|DELETE\",code=~\"5..\"}[5m]))\n)\n/\nsum by (cluster) (rate(apiserver_request_total{job=\"apiserver\",verb=~\"POST|PUT|PATCH|DELETE\"}[5m]))",
        "labels": {
          "verb": "write"
        },
        "record": "apiserver_request:burnrate5m"
      },
      {
        "expr": "(\n  (\n    # too slow\n    sum by (cluster) (rate(apiserver_request_sli_duration_seconds_count{job=\"apiserver\",verb=~\"POST|PUT|PATCH|DELETE\",subresource!~\"proxy|attach|log|exec|portforward\"}[6h]))\n    -\n    sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job=\"apiserver\",verb=~\"POST|PUT|PATCH|DELETE\",subresource!~\"proxy|attach|log|exec|portforward\",le=\"1\"}[6h]))\n  )\n  +\n  sum by (cluster) (rate(apiserver_request_total{job=\"apiserver\",verb=~\"POST|PUT|PATCH|DELETE\",code=~\"5..\"}[6h]))\n)\n/\nsum by (cluster) (rate(apiserver_request_total{job=\"apiserver\",verb=~\"POST|PUT|PATCH|DELETE\"}[6h]))",
        "labels": {
          "verb": "write"
        },
        "record": "apiserver_request:burnrate6h"
      }
    ]
  }
,
  {
    "name": "kube-apiserver-histogram.rules",
    "rules": [
      {
        "expr": "histogram_quantile(0.99, sum by (cluster, le, resource) (rate(apiserver_request_sli_duration_seconds_bucket{job=\"apiserver\",verb=~\"LIST|GET\",subresource!~\"proxy|attach|log|exec|portforward\"}[5m]))) > 0",
        "labels": {
          "quantile": "0.99",
          "verb": "read"
        },
        "record": "cluster_quantile:apiserver_request_sli_duration_seconds:histogram_quantile"
      },
      {
        "expr": "histogram_quantile(0.99, sum by (cluster, le, resource) (rate(apiserver_request_sli_duration_seconds_bucket{job=\"apiserver\",verb=~\"POST|PUT|PATCH|DELETE\",subresource!~\"proxy|attach|log|exec|portforward\"}[5m]))) > 0",
        "labels": {
          "quantile": "0.99",
          "verb": "write"
        },
        "record": "cluster_quantile:apiserver_request_sli_duration_seconds:histogram_quantile"
      }
    ]
  }
,
  {
    "name": "kube-apiserver-slos",
    "rules": [
      {
        "alert": "KubeAPIErrorBudgetBurn",
        "annotations": {
          "description": "The API server is burning too much error budget.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeapierrorbudgetburn",
          "summary": "The API server is burning too much error budget."
        },
        "expr": "sum(apiserver_request:burnrate1h) > (14.40 * 0.01000)\nand\nsum(apiserver_request:burnrate5m) > (14.40 * 0.01000)",
        "for": "2m",
        "labels": {
          "long": "1h",
          "severity": "critical",
          "short": "5m"
        }
      },
      {
        "alert": "KubeAPIErrorBudgetBurn",
        "annotations": {
          "description": "The API server is burning too much error budget.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeapierrorbudgetburn",
          "summary": "The API server is burning too much error budget."
        },
        "expr": "sum(apiserver_request:burnrate6h) > (6.00 * 0.01000)\nand\nsum(apiserver_request:burnrate30m) > (6.00 * 0.01000)",
        "for": "15m",
        "labels": {
          "long": "6h",
          "severity": "critical",
          "short": "30m"
        }
      },
      {
        "alert": "KubeAPIErrorBudgetBurn",
        "annotations": {
          "description": "The API server is burning too much error budget.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeapierrorbudgetburn",
          "summary": "The API server is burning too much error budget."
        },
        "expr": "sum(apiserver_request:burnrate1d) > (3.00 * 0.01000)\nand\nsum(apiserver_request:burnrate2h) > (3.00 * 0.01000)",
        "for": "1h",
        "labels": {
          "long": "1d",
          "severity": "warning",
          "short": "2h"
        }
      },
      {
        "alert": "KubeAPIErrorBudgetBurn",
        "annotations": {
          "description": "The API server is burning too much error budget.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeapierrorbudgetburn",
          "summary": "The API server is burning too much error budget."
        },
        "expr": "sum(apiserver_request:burnrate3d) > (1.00 * 0.01000)\nand\nsum(apiserver_request:burnrate6h) > (1.00 * 0.01000)",
        "for": "3h",
        "labels": {
          "long": "3d",
          "severity": "warning",
          "short": "6h"
        }
      }
    ]
  }
,
  {
    "name": "kube-prometheus-general.rules",
    "rules": [
      {
        "expr": "count without(instance, pod, node) (up == 1)",
        "record": "count:up1"
      },
      {
        "expr": "count without(instance, pod, node) (up == 0)",
        "record": "count:up0"
      }
    ]
  }
,
  {
    "name": "kube-prometheus-node-recording.rules",
    "rules": [
      {
        "expr": "sum(rate(node_cpu_seconds_total{mode!=\"idle\",mode!=\"iowait\",mode!=\"steal\"}[3m])) BY (instance)",
        "record": "instance:node_cpu:rate:sum"
      },
      {
        "expr": "sum(rate(node_network_receive_bytes_total[3m])) BY (instance)",
        "record": "instance:node_network_receive_bytes:rate:sum"
      },
      {
        "expr": "sum(rate(node_network_transmit_bytes_total[3m])) BY (instance)",
        "record": "instance:node_network_transmit_bytes:rate:sum"
      },
      {
        "expr": "sum(rate(node_cpu_seconds_total{mode!=\"idle\",mode!=\"iowait\",mode!=\"steal\"}[5m])) WITHOUT (cpu, mode) / ON (instance) GROUP_LEFT() count(sum(node_cpu_seconds_total) BY (instance, cpu)) BY (instance)",
        "record": "instance:node_cpu:ratio"
      },
      {
        "expr": "sum(rate(node_cpu_seconds_total{mode!=\"idle\",mode!=\"iowait\",mode!=\"steal\"}[5m]))",
        "record": "cluster:node_cpu:sum_rate5m"
      },
      {
        "expr": "cluster:node_cpu:sum_rate5m / count(sum(node_cpu_seconds_total) BY (instance, cpu))",
        "record": "cluster:node_cpu:ratio"
      }
    ]
  }
,
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
,
  {
    "name": "kube-state-metrics",
    "rules": [
      {
        "alert": "KubeStateMetricsListErrors",
        "annotations": {
          "description": "kube-state-metrics is experiencing errors at an elevated rate in list operations. This is likely causing it to not be able to expose metrics about Kubernetes objects correctly or at all.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kube-state-metrics/kubestatemetricslisterrors",
          "summary": "kube-state-metrics is experiencing errors in list operations."
        },
        "expr": "(sum(rate(kube_state_metrics_list_total{job=\"kube-state-metrics\",result=\"error\"}[5m])) by (cluster)\n  /\nsum(rate(kube_state_metrics_list_total{job=\"kube-state-metrics\"}[5m])) by (cluster))\n> 0.01",
        "for": "15m",
        "labels": {
          "severity": "critical"
        }
      },
      {
        "alert": "KubeStateMetricsWatchErrors",
        "annotations": {
          "description": "kube-state-metrics is experiencing errors at an elevated rate in watch operations. This is likely causing it to not be able to expose metrics about Kubernetes objects correctly or at all.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kube-state-metrics/kubestatemetricswatcherrors",
          "summary": "kube-state-metrics is experiencing errors in watch operations."
        },
        "expr": "(sum(rate(kube_state_metrics_watch_total{job=\"kube-state-metrics\",result=\"error\"}[5m])) by (cluster)\n  /\nsum(rate(kube_state_metrics_watch_total{job=\"kube-state-metrics\"}[5m])) by (cluster))\n> 0.01",
        "for": "15m",
        "labels": {
          "severity": "critical"
        }
      },
      {
        "alert": "KubeStateMetricsShardingMismatch",
        "annotations": {
          "description": "kube-state-metrics pods are running with different --total-shards configuration, some Kubernetes objects may be exposed multiple times or not exposed at all.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kube-state-metrics/kubestatemetricsshardingmismatch",
          "summary": "kube-state-metrics sharding is misconfigured."
        },
        "expr": "stdvar (kube_state_metrics_total_shards{job=\"kube-state-metrics\"}) by (cluster) != 0",
        "for": "15m",
        "labels": {
          "severity": "critical"
        }
      },
      {
        "alert": "KubeStateMetricsShardsMissing",
        "annotations": {
          "description": "kube-state-metrics shards are missing, some Kubernetes objects are not being exposed.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kube-state-metrics/kubestatemetricsshardsmissing",
          "summary": "kube-state-metrics shards are missing."
        },
        "expr": "2^max(kube_state_metrics_total_shards{job=\"kube-state-metrics\"}) by (cluster) - 1\n  -\nsum( 2 ^ max by (cluster, shard_ordinal) (kube_state_metrics_shard_ordinal{job=\"kube-state-metrics\"}) ) by (cluster)\n!= 0",
        "for": "15m",
        "labels": {
          "severity": "critical"
        }
      }
    ]
  }
,
  {
    "name": "kubelet.rules",
    "rules": [
      {
        "expr": "histogram_quantile(0.99, sum(rate(kubelet_pleg_relist_duration_seconds_bucket{job=\"kubelet\", metrics_path=\"/metrics\"}[5m])) by (cluster, instance, le) * on (cluster, instance) group_left(node) kubelet_node_name{job=\"kubelet\", metrics_path=\"/metrics\"})",
        "labels": {
          "quantile": "0.99"
        },
        "record": "node_quantile:kubelet_pleg_relist_duration_seconds:histogram_quantile"
      },
      {
        "expr": "histogram_quantile(0.9, sum(rate(kubelet_pleg_relist_duration_seconds_bucket{job=\"kubelet\", metrics_path=\"/metrics\"}[5m])) by (cluster, instance, le) * on (cluster, instance) group_left(node) kubelet_node_name{job=\"kubelet\", metrics_path=\"/metrics\"})",
        "labels": {
          "quantile": "0.9"
        },
        "record": "node_quantile:kubelet_pleg_relist_duration_seconds:histogram_quantile"
      },
      {
        "expr": "histogram_quantile(0.5, sum(rate(kubelet_pleg_relist_duration_seconds_bucket{job=\"kubelet\", metrics_path=\"/metrics\"}[5m])) by (cluster, instance, le) * on (cluster, instance) group_left(node) kubelet_node_name{job=\"kubelet\", metrics_path=\"/metrics\"})",
        "labels": {
          "quantile": "0.5"
        },
        "record": "node_quantile:kubelet_pleg_relist_duration_seconds:histogram_quantile"
      }
    ]
  }
,
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
          "severity": "warning"
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
          "severity": "warning"
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
          "severity": "warning"
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
          "severity": "warning"
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
          "severity": "warning"
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
          "severity": "warning"
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
          "severity": "warning"
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
          "severity": "warning"
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
          "severity": "warning"
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
          "severity": "warning"
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
          "severity": "warning"
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
          "severity": "warning"
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
          "severity": "warning"
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
          "severity": "warning"
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
          "severity": "warning"
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
          "severity": "warning"
        }
      }
    ]
  }
,
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
          "severity": "warning"
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
          "severity": "warning"
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
          "severity": "warning"
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
          "severity": "warning"
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
          "severity": "info"
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
          "severity": "info"
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
          "severity": "warning"
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
          "severity": "info"
        }
      }
    ]
  }
,
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
          "severity": "critical"
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
          "severity": "warning"
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
          "severity": "critical"
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
          "severity": "warning"
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
          "severity": "critical"
        }
      }
    ]
  }
,
  {
    "name": "kubernetes-system",
    "rules": [
      {
        "alert": "KubeVersionMismatch",
        "annotations": {
          "description": "There are {{ $value }} different semantic versions of Kubernetes components running.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeversionmismatch",
          "summary": "Different semantic versions of Kubernetes components running."
        },
        "expr": "count by (cluster) (count by (git_version, cluster) (label_replace(kubernetes_build_info{job!~\"kube-dns|coredns\"},\"git_version\",\"$1\",\"git_version\",\"(v[0-9]*.[0-9]*).*\"))) > 1",
        "for": "15m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "KubeClientErrors",
        "annotations": {
          "description": "Kubernetes API server client '{{ $labels.job }}/{{ $labels.instance }}' is experiencing {{ $value | humanizePercentage }} errors.'",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeclienterrors",
          "summary": "Kubernetes API server client is experiencing errors."
        },
        "expr": "(sum(rate(rest_client_requests_total{job=\"apiserver\",code=~\"5..\"}[5m])) by (cluster, instance, job, namespace)\n  /\nsum(rate(rest_client_requests_total{job=\"apiserver\"}[5m])) by (cluster, instance, job, namespace))\n> 0.01",
        "for": "15m",
        "labels": {
          "severity": "warning"
        }
      }
    ]
  }
,
  {
    "name": "kubernetes-system-apiserver",
    "rules": [
      {
        "alert": "KubeClientCertificateExpiration",
        "annotations": {
          "description": "A client certificate used to authenticate to kubernetes apiserver is expiring in less than 7.0 days.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeclientcertificateexpiration",
          "summary": "Client certificate is about to expire."
        },
        "expr": "apiserver_client_certificate_expiration_seconds_count{job=\"apiserver\"} > 0 and on (job) histogram_quantile(0.01, sum by (job, le) (rate(apiserver_client_certificate_expiration_seconds_bucket{job=\"apiserver\"}[5m]))) < 604800",
        "for": "5m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "KubeClientCertificateExpiration",
        "annotations": {
          "description": "A client certificate used to authenticate to kubernetes apiserver is expiring in less than 24.0 hours.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeclientcertificateexpiration",
          "summary": "Client certificate is about to expire."
        },
        "expr": "apiserver_client_certificate_expiration_seconds_count{job=\"apiserver\"} > 0 and on (job) histogram_quantile(0.01, sum by (job, le) (rate(apiserver_client_certificate_expiration_seconds_bucket{job=\"apiserver\"}[5m]))) < 86400",
        "for": "5m",
        "labels": {
          "severity": "critical"
        }
      },
      {
        "alert": "KubeAggregatedAPIErrors",
        "annotations": {
          "description": "Kubernetes aggregated API {{ $labels.name }}/{{ $labels.namespace }} has reported errors. It has appeared unavailable {{ $value | humanize }} times averaged over the past 10m.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeaggregatedapierrors",
          "summary": "Kubernetes aggregated API has reported errors."
        },
        "expr": "sum by (name, namespace, cluster)(increase(aggregator_unavailable_apiservice_total{job=\"apiserver\"}[10m])) > 4",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "KubeAggregatedAPIDown",
        "annotations": {
          "description": "Kubernetes aggregated API {{ $labels.name }}/{{ $labels.namespace }} has been only {{ $value | humanize }}% available over the last 10m.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeaggregatedapidown",
          "summary": "Kubernetes aggregated API is down."
        },
        "expr": "(1 - max by (name, namespace, cluster)(avg_over_time(aggregator_unavailable_apiservice{job=\"apiserver\"}[10m]))) * 100 < 85",
        "for": "5m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "KubeAPIDown",
        "annotations": {
          "description": "KubeAPI has disappeared from Prometheus target discovery.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeapidown",
          "summary": "Target disappeared from Prometheus target discovery."
        },
        "expr": "absent(up{job=\"apiserver\"} == 1)",
        "for": "15m",
        "labels": {
          "severity": "critical"
        }
      },
      {
        "alert": "KubeAPITerminatedRequests",
        "annotations": {
          "description": "The kubernetes apiserver has terminated {{ $value | humanizePercentage }} of its incoming requests.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeapiterminatedrequests",
          "summary": "The kubernetes apiserver has terminated {{ $value | humanizePercentage }} of its incoming requests."
        },
        "expr": "sum(rate(apiserver_request_terminations_total{job=\"apiserver\"}[10m]))  / (  sum(rate(apiserver_request_total{job=\"apiserver\"}[10m])) + sum(rate(apiserver_request_terminations_total{job=\"apiserver\"}[10m])) ) > 0.20",
        "for": "5m",
        "labels": {
          "severity": "warning"
        }
      }
    ]
  }
,
  {
    "name": "kubernetes-system-controller-manager",
    "rules": [
      {
        "alert": "KubeControllerManagerDown",
        "annotations": {
          "description": "KubeControllerManager has disappeared from Prometheus target discovery.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubecontrollermanagerdown",
          "summary": "Target disappeared from Prometheus target discovery."
        },
        "expr": "absent(up{job=\"kube-controller-manager\"} == 1)",
        "for": "15m",
        "labels": {
          "severity": "critical"
        }
      }
    ]
  }
,
  {
    "name": "kubernetes-system-kube-proxy",
    "rules": [
      {
        "alert": "KubeProxyDown",
        "annotations": {
          "description": "KubeProxy has disappeared from Prometheus target discovery.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeproxydown",
          "summary": "Target disappeared from Prometheus target discovery."
        },
        "expr": "absent(up{job=\"kube-proxy\"} == 1)",
        "for": "15m",
        "labels": {
          "severity": "critical"
        }
      }
    ]
  }
,
  {
    "name": "kubernetes-system-kubelet",
    "rules": [
      {
        "alert": "KubeNodeNotReady",
        "annotations": {
          "description": "{{ $labels.node }} has been unready for more than 15 minutes.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubenodenotready",
          "summary": "Node is not ready."
        },
        "expr": "kube_node_status_condition{job=\"kube-state-metrics\",condition=\"Ready\",status=\"true\"} == 0",
        "for": "15m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "KubeNodeUnreachable",
        "annotations": {
          "description": "{{ $labels.node }} is unreachable and some workloads may be rescheduled.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubenodeunreachable",
          "summary": "Node is unreachable."
        },
        "expr": "(kube_node_spec_taint{job=\"kube-state-metrics\",key=\"node.kubernetes.io/unreachable\",effect=\"NoSchedule\"} unless ignoring(key,value) kube_node_spec_taint{job=\"kube-state-metrics\",key=~\"ToBeDeletedByClusterAutoscaler|cloud.google.com/impending-node-termination|aws-node-termination-handler/spot-itn\"}) == 1",
        "for": "15m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "KubeletTooManyPods",
        "annotations": {
          "description": "Kubelet '{{ $labels.node }}' is running at {{ $value | humanizePercentage }} of its Pod capacity.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubelettoomanypods",
          "summary": "Kubelet is running at capacity."
        },
        "expr": "count by (cluster, node) (\n  (kube_pod_status_phase{job=\"kube-state-metrics\",phase=\"Running\"} == 1) * on (instance,pod,namespace,cluster) group_left(node) topk by (instance,pod,namespace,cluster) (1, kube_pod_info{job=\"kube-state-metrics\"})\n)\n/\nmax by (cluster, node) (\n  kube_node_status_capacity{job=\"kube-state-metrics\",resource=\"pods\"} != 1\n) > 0.95",
        "for": "15m",
        "labels": {
          "severity": "info"
        }
      },
      {
        "alert": "KubeNodeReadinessFlapping",
        "annotations": {
          "description": "The readiness status of node {{ $labels.node }} has changed {{ $value }} times in the last 15 minutes.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubenodereadinessflapping",
          "summary": "Node readiness status is flapping."
        },
        "expr": "sum(changes(kube_node_status_condition{job=\"kube-state-metrics\",status=\"true\",condition=\"Ready\"}[15m])) by (cluster, node) > 2",
        "for": "15m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "KubeletPlegDurationHigh",
        "annotations": {
          "description": "The Kubelet Pod Lifecycle Event Generator has a 99th percentile duration of {{ $value }} seconds on node {{ $labels.node }}.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeletplegdurationhigh",
          "summary": "Kubelet Pod Lifecycle Event Generator is taking too long to relist."
        },
        "expr": "node_quantile:kubelet_pleg_relist_duration_seconds:histogram_quantile{quantile=\"0.99\"} >= 10",
        "for": "5m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "KubeletPodStartUpLatencyHigh",
        "annotations": {
          "description": "Kubelet Pod startup 99th percentile latency is {{ $value }} seconds on node {{ $labels.node }}.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeletpodstartuplatencyhigh",
          "summary": "Kubelet Pod startup latency is too high."
        },
        "expr": "histogram_quantile(0.99, sum(rate(kubelet_pod_worker_duration_seconds_bucket{job=\"kubelet\", metrics_path=\"/metrics\"}[5m])) by (cluster, instance, le)) * on (cluster, instance) group_left(node) kubelet_node_name{job=\"kubelet\", metrics_path=\"/metrics\"} > 60",
        "for": "15m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "KubeletClientCertificateExpiration",
        "annotations": {
          "description": "Client certificate for Kubelet on node {{ $labels.node }} expires in {{ $value | humanizeDuration }}.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeletclientcertificateexpiration",
          "summary": "Kubelet client certificate is about to expire."
        },
        "expr": "kubelet_certificate_manager_client_ttl_seconds < 604800",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "KubeletClientCertificateExpiration",
        "annotations": {
          "description": "Client certificate for Kubelet on node {{ $labels.node }} expires in {{ $value | humanizeDuration }}.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeletclientcertificateexpiration",
          "summary": "Kubelet client certificate is about to expire."
        },
        "expr": "kubelet_certificate_manager_client_ttl_seconds < 86400",
        "labels": {
          "severity": "critical"
        }
      },
      {
        "alert": "KubeletServerCertificateExpiration",
        "annotations": {
          "description": "Server certificate for Kubelet on node {{ $labels.node }} expires in {{ $value | humanizeDuration }}.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeletservercertificateexpiration",
          "summary": "Kubelet server certificate is about to expire."
        },
        "expr": "kubelet_certificate_manager_server_ttl_seconds < 604800",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "KubeletServerCertificateExpiration",
        "annotations": {
          "description": "Server certificate for Kubelet on node {{ $labels.node }} expires in {{ $value | humanizeDuration }}.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeletservercertificateexpiration",
          "summary": "Kubelet server certificate is about to expire."
        },
        "expr": "kubelet_certificate_manager_server_ttl_seconds < 86400",
        "labels": {
          "severity": "critical"
        }
      },
      {
        "alert": "KubeletClientCertificateRenewalErrors",
        "annotations": {
          "description": "Kubelet on node {{ $labels.node }} has failed to renew its client certificate ({{ $value | humanize }} errors in the last 5 minutes).",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeletclientcertificaterenewalerrors",
          "summary": "Kubelet has failed to renew its client certificate."
        },
        "expr": "increase(kubelet_certificate_manager_client_expiration_renew_errors[5m]) > 0",
        "for": "15m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "KubeletServerCertificateRenewalErrors",
        "annotations": {
          "description": "Kubelet on node {{ $labels.node }} has failed to renew its server certificate ({{ $value | humanize }} errors in the last 5 minutes).",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeletservercertificaterenewalerrors",
          "summary": "Kubelet has failed to renew its server certificate."
        },
        "expr": "increase(kubelet_server_expiration_renew_errors[5m]) > 0",
        "for": "15m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "KubeletDown",
        "annotations": {
          "description": "Kubelet has disappeared from Prometheus target discovery.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeletdown",
          "summary": "Target disappeared from Prometheus target discovery."
        },
        "expr": "absent(up{job=\"kubelet\", metrics_path=\"/metrics\"} == 1)",
        "for": "15m",
        "labels": {
          "severity": "critical"
        }
      }
    ]
  }
,
  {
    "name": "kubernetes-system-scheduler",
    "rules": [
      {
        "alert": "KubeSchedulerDown",
        "annotations": {
          "description": "KubeScheduler has disappeared from Prometheus target discovery.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeschedulerdown",
          "summary": "Target disappeared from Prometheus target discovery."
        },
        "expr": "absent(up{job=\"kube-scheduler\"} == 1)",
        "for": "15m",
        "labels": {
          "severity": "critical"
        }
      }
    ]
  }
,
  {
    "name": "node-exporter",
    "rules": [
      {
        "alert": "NodeFilesystemSpaceFillingUp",
        "annotations": {
          "description": "Filesystem on {{ $labels.device }}, mounted on {{ $labels.mountpoint }}, at {{ $labels.instance }} has only {{ printf \"%.2f\" $value }}% available space left and is filling up.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodefilesystemspacefillingup",
          "summary": "Filesystem is predicted to run out of space within the next 24 hours."
        },
        "expr": "(\n  node_filesystem_avail_bytes{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} / node_filesystem_size_bytes{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} * 100 < 15\nand\n  predict_linear(node_filesystem_avail_bytes{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"}[6h], 24*60*60) < 0\nand\n  node_filesystem_readonly{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} == 0\n)",
        "for": "1h",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "NodeFilesystemSpaceFillingUp",
        "annotations": {
          "description": "Filesystem on {{ $labels.device }}, mounted on {{ $labels.mountpoint }}, at {{ $labels.instance }} has only {{ printf \"%.2f\" $value }}% available space left and is filling up fast.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodefilesystemspacefillingup",
          "summary": "Filesystem is predicted to run out of space within the next 4 hours."
        },
        "expr": "(\n  node_filesystem_avail_bytes{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} / node_filesystem_size_bytes{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} * 100 < 10\nand\n  predict_linear(node_filesystem_avail_bytes{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"}[6h], 4*60*60) < 0\nand\n  node_filesystem_readonly{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} == 0\n)",
        "for": "1h",
        "labels": {
          "severity": "critical"
        }
      },
      {
        "alert": "NodeFilesystemAlmostOutOfSpace",
        "annotations": {
          "description": "Filesystem on {{ $labels.device }}, mounted on {{ $labels.mountpoint }}, at {{ $labels.instance }} has only {{ printf \"%.2f\" $value }}% available space left.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodefilesystemalmostoutofspace",
          "summary": "Filesystem has less than 5% space left."
        },
        "expr": "(\n  node_filesystem_avail_bytes{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} / node_filesystem_size_bytes{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} * 100 < 5\nand\n  node_filesystem_readonly{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} == 0\n)",
        "for": "30m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "NodeFilesystemAlmostOutOfSpace",
        "annotations": {
          "description": "Filesystem on {{ $labels.device }}, mounted on {{ $labels.mountpoint }}, at {{ $labels.instance }} has only {{ printf \"%.2f\" $value }}% available space left.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodefilesystemalmostoutofspace",
          "summary": "Filesystem has less than 3% space left."
        },
        "expr": "(\n  node_filesystem_avail_bytes{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} / node_filesystem_size_bytes{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} * 100 < 3\nand\n  node_filesystem_readonly{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} == 0\n)",
        "for": "30m",
        "labels": {
          "severity": "critical"
        }
      },
      {
        "alert": "NodeFilesystemFilesFillingUp",
        "annotations": {
          "description": "Filesystem on {{ $labels.device }}, mounted on {{ $labels.mountpoint }}, at {{ $labels.instance }} has only {{ printf \"%.2f\" $value }}% available inodes left and is filling up.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodefilesystemfilesfillingup",
          "summary": "Filesystem is predicted to run out of inodes within the next 24 hours."
        },
        "expr": "(\n  node_filesystem_files_free{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} / node_filesystem_files{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} * 100 < 40\nand\n  predict_linear(node_filesystem_files_free{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"}[6h], 24*60*60) < 0\nand\n  node_filesystem_readonly{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} == 0\n)",
        "for": "1h",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "NodeFilesystemFilesFillingUp",
        "annotations": {
          "description": "Filesystem on {{ $labels.device }}, mounted on {{ $labels.mountpoint }}, at {{ $labels.instance }} has only {{ printf \"%.2f\" $value }}% available inodes left and is filling up fast.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodefilesystemfilesfillingup",
          "summary": "Filesystem is predicted to run out of inodes within the next 4 hours."
        },
        "expr": "(\n  node_filesystem_files_free{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} / node_filesystem_files{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} * 100 < 20\nand\n  predict_linear(node_filesystem_files_free{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"}[6h], 4*60*60) < 0\nand\n  node_filesystem_readonly{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} == 0\n)",
        "for": "1h",
        "labels": {
          "severity": "critical"
        }
      },
      {
        "alert": "NodeFilesystemAlmostOutOfFiles",
        "annotations": {
          "description": "Filesystem on {{ $labels.device }}, mounted on {{ $labels.mountpoint }}, at {{ $labels.instance }} has only {{ printf \"%.2f\" $value }}% available inodes left.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodefilesystemalmostoutoffiles",
          "summary": "Filesystem has less than 5% inodes left."
        },
        "expr": "(\n  node_filesystem_files_free{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} / node_filesystem_files{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} * 100 < 5\nand\n  node_filesystem_readonly{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} == 0\n)",
        "for": "1h",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "NodeFilesystemAlmostOutOfFiles",
        "annotations": {
          "description": "Filesystem on {{ $labels.device }}, mounted on {{ $labels.mountpoint }}, at {{ $labels.instance }} has only {{ printf \"%.2f\" $value }}% available inodes left.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodefilesystemalmostoutoffiles",
          "summary": "Filesystem has less than 3% inodes left."
        },
        "expr": "(\n  node_filesystem_files_free{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} / node_filesystem_files{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} * 100 < 3\nand\n  node_filesystem_readonly{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} == 0\n)",
        "for": "1h",
        "labels": {
          "severity": "critical"
        }
      },
      {
        "alert": "NodeNetworkReceiveErrs",
        "annotations": {
          "description": "{{ $labels.instance }} interface {{ $labels.device }} has encountered {{ printf \"%.0f\" $value }} receive errors in the last two minutes.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodenetworkreceiveerrs",
          "summary": "Network interface is reporting many receive errors."
        },
        "expr": "rate(node_network_receive_errs_total{job=\"node-exporter\"}[2m]) / rate(node_network_receive_packets_total{job=\"node-exporter\"}[2m]) > 0.01",
        "for": "1h",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "NodeNetworkTransmitErrs",
        "annotations": {
          "description": "{{ $labels.instance }} interface {{ $labels.device }} has encountered {{ printf \"%.0f\" $value }} transmit errors in the last two minutes.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodenetworktransmiterrs",
          "summary": "Network interface is reporting many transmit errors."
        },
        "expr": "rate(node_network_transmit_errs_total{job=\"node-exporter\"}[2m]) / rate(node_network_transmit_packets_total{job=\"node-exporter\"}[2m]) > 0.01",
        "for": "1h",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "NodeHighNumberConntrackEntriesUsed",
        "annotations": {
          "description": "{{ $value | humanizePercentage }} of conntrack entries are used.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodehighnumberconntrackentriesused",
          "summary": "Number of conntrack are getting close to the limit."
        },
        "expr": "(node_nf_conntrack_entries{job=\"node-exporter\"} / node_nf_conntrack_entries_limit) > 0.75",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "NodeTextFileCollectorScrapeError",
        "annotations": {
          "description": "Node Exporter text file collector on {{ $labels.instance }} failed to scrape.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodetextfilecollectorscrapeerror",
          "summary": "Node Exporter text file collector failed to scrape."
        },
        "expr": "node_textfile_scrape_error{job=\"node-exporter\"} == 1",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "NodeClockSkewDetected",
        "annotations": {
          "description": "Clock at {{ $labels.instance }} is out of sync by more than 0.05s. Ensure NTP is configured correctly on this host.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodeclockskewdetected",
          "summary": "Clock skew detected."
        },
        "expr": "(\n  node_timex_offset_seconds{job=\"node-exporter\"} > 0.05\nand\n  deriv(node_timex_offset_seconds{job=\"node-exporter\"}[5m]) >= 0\n)\nor\n(\n  node_timex_offset_seconds{job=\"node-exporter\"} < -0.05\nand\n  deriv(node_timex_offset_seconds{job=\"node-exporter\"}[5m]) <= 0\n)",
        "for": "10m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "NodeClockNotSynchronising",
        "annotations": {
          "description": "Clock at {{ $labels.instance }} is not synchronising. Ensure NTP is configured on this host.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodeclocknotsynchronising",
          "summary": "Clock not synchronising."
        },
        "expr": "min_over_time(node_timex_sync_status{job=\"node-exporter\"}[5m]) == 0\nand\nnode_timex_maxerror_seconds{job=\"node-exporter\"} >= 16",
        "for": "10m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "NodeRAIDDegraded",
        "annotations": {
          "description": "RAID array '{{ $labels.device }}' at {{ $labels.instance }} is in degraded state due to one or more disks failures. Number of spare drives is insufficient to fix issue automatically.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/noderaiddegraded",
          "summary": "RAID Array is degraded."
        },
        "expr": "node_md_disks_required{job=\"node-exporter\",device=~\"(/dev/)?(mmcblk.p.+|nvme.+|rbd.+|sd.+|vd.+|xvd.+|dm-.+|md.+|dasd.+)\"} - ignoring (state) (node_md_disks{state=\"active\",job=\"node-exporter\",device=~\"(/dev/)?(mmcblk.p.+|nvme.+|rbd.+|sd.+|vd.+|xvd.+|dm-.+|md.+|dasd.+)\"}) > 0",
        "for": "15m",
        "labels": {
          "severity": "critical"
        }
      },
      {
        "alert": "NodeRAIDDiskFailure",
        "annotations": {
          "description": "At least one device in RAID array at {{ $labels.instance }} failed. Array '{{ $labels.device }}' needs attention and possibly a disk swap.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/noderaiddiskfailure",
          "summary": "Failed device in RAID array."
        },
        "expr": "node_md_disks{state=\"failed\",job=\"node-exporter\",device=~\"(/dev/)?(mmcblk.p.+|nvme.+|rbd.+|sd.+|vd.+|xvd.+|dm-.+|md.+|dasd.+)\"} > 0",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "NodeFileDescriptorLimit",
        "annotations": {
          "description": "File descriptors limit at {{ $labels.instance }} is currently at {{ printf \"%.2f\" $value }}%.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodefiledescriptorlimit",
          "summary": "Kernel is predicted to exhaust file descriptors limit soon."
        },
        "expr": "(\n  node_filefd_allocated{job=\"node-exporter\"} * 100 / node_filefd_maximum{job=\"node-exporter\"} > 70\n)",
        "for": "15m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "NodeFileDescriptorLimit",
        "annotations": {
          "description": "File descriptors limit at {{ $labels.instance }} is currently at {{ printf \"%.2f\" $value }}%.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodefiledescriptorlimit",
          "summary": "Kernel is predicted to exhaust file descriptors limit soon."
        },
        "expr": "(\n  node_filefd_allocated{job=\"node-exporter\"} * 100 / node_filefd_maximum{job=\"node-exporter\"} > 90\n)",
        "for": "15m",
        "labels": {
          "severity": "critical"
        }
      },
      {
        "alert": "NodeCPUHighUsage",
        "annotations": {
          "description": "CPU usage at {{ $labels.instance }} has been above 90% for the last 15 minutes, is currently at {{ printf \"%.2f\" $value }}%.\n",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodecpuhighusage",
          "summary": "High CPU usage."
        },
        "expr": "sum without(mode) (avg without (cpu) (rate(node_cpu_seconds_total{job=\"node-exporter\", mode!=\"idle\"}[2m]))) * 100 > 90",
        "for": "15m",
        "labels": {
          "severity": "info"
        }
      },
      {
        "alert": "NodeSystemSaturation",
        "annotations": {
          "description": "System load per core at {{ $labels.instance }} has been above 2 for the last 15 minutes, is currently at {{ printf \"%.2f\" $value }}.\nThis might indicate this instance resources saturation and can cause it becoming unresponsive.\n",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodesystemsaturation",
          "summary": "System saturated, load per core is very high."
        },
        "expr": "node_load1{job=\"node-exporter\"}\n/ count without (cpu, mode) (node_cpu_seconds_total{job=\"node-exporter\", mode=\"idle\"}) > 2",
        "for": "15m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "NodeMemoryMajorPagesFaults",
        "annotations": {
          "description": "Memory major pages are occurring at very high rate at {{ $labels.instance }}, 500 major page faults per second for the last 15 minutes, is currently at {{ printf \"%.2f\" $value }}.\nPlease check that there is enough memory available at this instance.\n",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodememorymajorpagesfaults",
          "summary": "Memory major page faults are occurring at very high rate."
        },
        "expr": "rate(node_vmstat_pgmajfault{job=\"node-exporter\"}[5m]) > 500",
        "for": "15m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "NodeMemoryHighUtilization",
        "annotations": {
          "description": "Memory is filling up at {{ $labels.instance }}, has been above 90% for the last 15 minutes, is currently at {{ printf \"%.2f\" $value }}%.\n",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodememoryhighutilization",
          "summary": "Host is running out of memory."
        },
        "expr": "100 - (node_memory_MemAvailable_bytes{job=\"node-exporter\"} / node_memory_MemTotal_bytes{job=\"node-exporter\"} * 100) > 90",
        "for": "15m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "NodeDiskIOSaturation",
        "annotations": {
          "description": "Disk IO queue (aqu-sq) is high on {{ $labels.device }} at {{ $labels.instance }}, has been above 10 for the last 30 minutes, is currently at {{ printf \"%.2f\" $value }}.\nThis symptom might indicate disk saturation.\n",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodediskiosaturation",
          "summary": "Disk IO queue is high."
        },
        "expr": "rate(node_disk_io_time_weighted_seconds_total{job=\"node-exporter\", device=~\"(/dev/)?(mmcblk.p.+|nvme.+|rbd.+|sd.+|vd.+|xvd.+|dm-.+|md.+|dasd.+)\"}[5m]) > 10",
        "for": "30m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "NodeSystemdServiceFailed",
        "annotations": {
          "description": "Systemd service {{ $labels.name }} has entered failed state at {{ $labels.instance }}",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodesystemdservicefailed",
          "summary": "Systemd service has entered failed state."
        },
        "expr": "node_systemd_unit_state{job=\"node-exporter\", state=\"failed\"} == 1",
        "for": "5m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "NodeBondingDegraded",
        "annotations": {
          "description": "Bonding interface {{ $labels.master }} on {{ $labels.instance }} is in degraded state due to one or more slave failures.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodebondingdegraded",
          "summary": "Bonding interface is degraded"
        },
        "expr": "(node_bonding_slaves - node_bonding_active) != 0",
        "for": "5m",
        "labels": {
          "severity": "warning"
        }
      }
    ]
  }
,
  {
    "name": "node-exporter.rules",
    "rules": [
      {
        "expr": "count without (cpu, mode) (\n  node_cpu_seconds_total{job=\"node-exporter\",mode=\"idle\"}\n)",
        "record": "instance:node_num_cpu:sum"
      },
      {
        "expr": "1 - avg without (cpu) (\n  sum without (mode) (rate(node_cpu_seconds_total{job=\"node-exporter\", mode=~\"idle|iowait|steal\"}[5m]))\n)",
        "record": "instance:node_cpu_utilisation:rate5m"
      },
      {
        "expr": "(\n  node_load1{job=\"node-exporter\"}\n/\n  instance:node_num_cpu:sum{job=\"node-exporter\"}\n)",
        "record": "instance:node_load1_per_cpu:ratio"
      },
      {
        "expr": "1 - (\n  (\n    node_memory_MemAvailable_bytes{job=\"node-exporter\"}\n    or\n    (\n      node_memory_Buffers_bytes{job=\"node-exporter\"}\n      +\n      node_memory_Cached_bytes{job=\"node-exporter\"}\n      +\n      node_memory_MemFree_bytes{job=\"node-exporter\"}\n      +\n      node_memory_Slab_bytes{job=\"node-exporter\"}\n    )\n  )\n/\n  node_memory_MemTotal_bytes{job=\"node-exporter\"}\n)",
        "record": "instance:node_memory_utilisation:ratio"
      },
      {
        "expr": "rate(node_vmstat_pgmajfault{job=\"node-exporter\"}[5m])",
        "record": "instance:node_vmstat_pgmajfault:rate5m"
      },
      {
        "expr": "rate(node_disk_io_time_seconds_total{job=\"node-exporter\", device=~\"(/dev/)?(mmcblk.p.+|nvme.+|rbd.+|sd.+|vd.+|xvd.+|dm-.+|md.+|dasd.+)\"}[5m])",
        "record": "instance_device:node_disk_io_time_seconds:rate5m"
      },
      {
        "expr": "rate(node_disk_io_time_weighted_seconds_total{job=\"node-exporter\", device=~\"(/dev/)?(mmcblk.p.+|nvme.+|rbd.+|sd.+|vd.+|xvd.+|dm-.+|md.+|dasd.+)\"}[5m])",
        "record": "instance_device:node_disk_io_time_weighted_seconds:rate5m"
      },
      {
        "expr": "sum without (device) (\n  rate(node_network_receive_bytes_total{job=\"node-exporter\", device!=\"lo\"}[5m])\n)",
        "record": "instance:node_network_receive_bytes_excluding_lo:rate5m"
      },
      {
        "expr": "sum without (device) (\n  rate(node_network_transmit_bytes_total{job=\"node-exporter\", device!=\"lo\"}[5m])\n)",
        "record": "instance:node_network_transmit_bytes_excluding_lo:rate5m"
      },
      {
        "expr": "sum without (device) (\n  rate(node_network_receive_drop_total{job=\"node-exporter\", device!=\"lo\"}[5m])\n)",
        "record": "instance:node_network_receive_drop_excluding_lo:rate5m"
      },
      {
        "expr": "sum without (device) (\n  rate(node_network_transmit_drop_total{job=\"node-exporter\", device!=\"lo\"}[5m])\n)",
        "record": "instance:node_network_transmit_drop_excluding_lo:rate5m"
      }
    ]
  }
,
  {
    "name": "node-network",
    "rules": [
      {
        "alert": "NodeNetworkInterfaceFlapping",
        "annotations": {
          "description": "Network interface \"{{ $labels.device }}\" changing its up status often on node-exporter {{ $labels.namespace }}/{{ $labels.pod }}",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/general/nodenetworkinterfaceflapping",
          "summary": "Network interface is often changing its status"
        },
        "expr": "changes(node_network_up{job=\"node-exporter\",device!~\"veth.+\"}[2m]) > 2",
        "for": "2m",
        "labels": {
          "severity": "warning"
        }
      }
    ]
  }
,
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
,
  {
    "name": "prometheus",
    "rules": [
      {
        "alert": "PrometheusBadConfig",
        "annotations": {
          "description": "Prometheus {{$labels.namespace}}/{{$labels.pod}} has failed to reload its configuration.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusbadconfig",
          "summary": "Failed Prometheus configuration reload."
        },
        "expr": "# Without max_over_time, failed scrapes could create false negatives, see\n# https://www.robustperception.io/alerting-on-gauges-in-prometheus-2-0 for details.\nmax_over_time(prometheus_config_last_reload_successful{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}[5m]) == 0",
        "for": "10m",
        "labels": {
          "severity": "critical"
        }
      },
      {
        "alert": "PrometheusSDRefreshFailure",
        "annotations": {
          "description": "Prometheus {{$labels.namespace}}/{{$labels.pod}} has failed to refresh SD with mechanism {{$labels.mechanism}}.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheussdrefreshfailure",
          "summary": "Failed Prometheus SD refresh."
        },
        "expr": "increase(prometheus_sd_refresh_failures_total{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}[10m]) > 0",
        "for": "20m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "PrometheusKubernetesListWatchFailures",
        "annotations": {
          "description": "Kubernetes service discovery of Prometheus {{$labels.namespace}}/{{$labels.pod}} is experiencing {{ printf \"%.0f\" $value }} failures with LIST/WATCH requests to the Kubernetes API in the last 5 minutes.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheuskuberneteslistwatchfailures",
          "summary": "Requests in Kubernetes SD are failing."
        },
        "expr": "increase(prometheus_sd_kubernetes_failures_total{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}[5m]) > 0",
        "for": "15m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "PrometheusNotificationQueueRunningFull",
        "annotations": {
          "description": "Alert notification queue of Prometheus {{$labels.namespace}}/{{$labels.pod}} is running full.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusnotificationqueuerunningfull",
          "summary": "Prometheus alert notification queue predicted to run full in less than 30m."
        },
        "expr": "# Without min_over_time, failed scrapes could create false negatives, see\n# https://www.robustperception.io/alerting-on-gauges-in-prometheus-2-0 for details.\n(\n  predict_linear(prometheus_notifications_queue_length{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}[5m], 60 * 30)\n>\n  min_over_time(prometheus_notifications_queue_capacity{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}[5m])\n)",
        "for": "15m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "PrometheusErrorSendingAlertsToSomeAlertmanagers",
        "annotations": {
          "description": "{{ printf \"%.1f\" $value }}% errors while sending alerts from Prometheus {{$labels.namespace}}/{{$labels.pod}} to Alertmanager {{$labels.alertmanager}}.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheuserrorsendingalertstosomealertmanagers",
          "summary": "Prometheus has encountered more than 1% errors sending alerts to a specific Alertmanager."
        },
        "expr": "(\n  rate(prometheus_notifications_errors_total{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}[5m])\n/\n  rate(prometheus_notifications_sent_total{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}[5m])\n)\n* 100\n> 1",
        "for": "15m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "PrometheusNotConnectedToAlertmanagers",
        "annotations": {
          "description": "Prometheus {{$labels.namespace}}/{{$labels.pod}} is not connected to any Alertmanagers.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusnotconnectedtoalertmanagers",
          "summary": "Prometheus is not connected to any Alertmanagers."
        },
        "expr": "# Without max_over_time, failed scrapes could create false negatives, see\n# https://www.robustperception.io/alerting-on-gauges-in-prometheus-2-0 for details.\nmax_over_time(prometheus_notifications_alertmanagers_discovered{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}[5m]) < 1",
        "for": "10m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "PrometheusTSDBReloadsFailing",
        "annotations": {
          "description": "Prometheus {{$labels.namespace}}/{{$labels.pod}} has detected {{$value | humanize}} reload failures over the last 3h.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheustsdbreloadsfailing",
          "summary": "Prometheus has issues reloading blocks from disk."
        },
        "expr": "increase(prometheus_tsdb_reloads_failures_total{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}[3h]) > 0",
        "for": "4h",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "PrometheusTSDBCompactionsFailing",
        "annotations": {
          "description": "Prometheus {{$labels.namespace}}/{{$labels.pod}} has detected {{$value | humanize}} compaction failures over the last 3h.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheustsdbcompactionsfailing",
          "summary": "Prometheus has issues compacting blocks."
        },
        "expr": "increase(prometheus_tsdb_compactions_failed_total{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}[3h]) > 0",
        "for": "4h",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "PrometheusNotIngestingSamples",
        "annotations": {
          "description": "Prometheus {{$labels.namespace}}/{{$labels.pod}} is not ingesting samples.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusnotingestingsamples",
          "summary": "Prometheus is not ingesting samples."
        },
        "expr": "(\n  sum without(type) (rate(prometheus_tsdb_head_samples_appended_total{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}[5m])) <= 0\nand\n  (\n    sum without(scrape_job) (prometheus_target_metadata_cache_entries{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}) > 0\n  or\n    sum without(rule_group) (prometheus_rule_group_rules{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}) > 0\n  )\n)",
        "for": "10m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "PrometheusDuplicateTimestamps",
        "annotations": {
          "description": "Prometheus {{$labels.namespace}}/{{$labels.pod}} is dropping {{ printf \"%.4g\" $value  }} samples/s with different values but duplicated timestamp.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusduplicatetimestamps",
          "summary": "Prometheus is dropping samples with duplicate timestamps."
        },
        "expr": "rate(prometheus_target_scrapes_sample_duplicate_timestamp_total{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}[5m]) > 0",
        "for": "10m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "PrometheusOutOfOrderTimestamps",
        "annotations": {
          "description": "Prometheus {{$labels.namespace}}/{{$labels.pod}} is dropping {{ printf \"%.4g\" $value  }} samples/s with timestamps arriving out of order.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusoutofordertimestamps",
          "summary": "Prometheus drops samples with out-of-order timestamps."
        },
        "expr": "rate(prometheus_target_scrapes_sample_out_of_order_total{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}[5m]) > 0",
        "for": "10m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "PrometheusRemoteStorageFailures",
        "annotations": {
          "description": "Prometheus {{$labels.namespace}}/{{$labels.pod}} failed to send {{ printf \"%.1f\" $value }}% of the samples to {{ $labels.remote_name}}:{{ $labels.url }}",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusremotestoragefailures",
          "summary": "Prometheus fails to send samples to remote storage."
        },
        "expr": "(\n  (rate(prometheus_remote_storage_failed_samples_total{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}[5m]) or rate(prometheus_remote_storage_samples_failed_total{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}[5m]))\n/\n  (\n    (rate(prometheus_remote_storage_failed_samples_total{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}[5m]) or rate(prometheus_remote_storage_samples_failed_total{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}[5m]))\n  +\n    (rate(prometheus_remote_storage_succeeded_samples_total{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}[5m]) or rate(prometheus_remote_storage_samples_total{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}[5m]))\n  )\n)\n* 100\n> 1",
        "for": "15m",
        "labels": {
          "severity": "critical"
        }
      },
      {
        "alert": "PrometheusRemoteWriteBehind",
        "annotations": {
          "description": "Prometheus {{$labels.namespace}}/{{$labels.pod}} remote write is {{ printf \"%.1f\" $value }}s behind for {{ $labels.remote_name}}:{{ $labels.url }}.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusremotewritebehind",
          "summary": "Prometheus remote write is behind."
        },
        "expr": "# Without max_over_time, failed scrapes could create false negatives, see\n# https://www.robustperception.io/alerting-on-gauges-in-prometheus-2-0 for details.\n(\n  max_over_time(prometheus_remote_storage_highest_timestamp_in_seconds{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}[5m])\n- ignoring(remote_name, url) group_right\n  max_over_time(prometheus_remote_storage_queue_highest_sent_timestamp_seconds{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}[5m])\n)\n> 120",
        "for": "15m",
        "labels": {
          "severity": "critical"
        }
      },
      {
        "alert": "PrometheusRemoteWriteDesiredShards",
        "annotations": {
          "description": "Prometheus {{$labels.namespace}}/{{$labels.pod}} remote write desired shards calculation wants to run {{ $value }} shards for queue {{ $labels.remote_name}}:{{ $labels.url }}, which is more than the max of {{ printf `prometheus_remote_storage_shards_max{instance=\"%s\",job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}` $labels.instance | query | first | value }}.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusremotewritedesiredshards",
          "summary": "Prometheus remote write desired shards calculation wants to run more than configured max shards."
        },
        "expr": "# Without max_over_time, failed scrapes could create false negatives, see\n# https://www.robustperception.io/alerting-on-gauges-in-prometheus-2-0 for details.\n(\n  max_over_time(prometheus_remote_storage_shards_desired{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}[5m])\n>\n  max_over_time(prometheus_remote_storage_shards_max{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}[5m])\n)",
        "for": "15m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "PrometheusRuleFailures",
        "annotations": {
          "description": "Prometheus {{$labels.namespace}}/{{$labels.pod}} has failed to evaluate {{ printf \"%.0f\" $value }} rules in the last 5m.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusrulefailures",
          "summary": "Prometheus is failing rule evaluations."
        },
        "expr": "increase(prometheus_rule_evaluation_failures_total{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}[5m]) > 0",
        "for": "15m",
        "labels": {
          "severity": "critical"
        }
      },
      {
        "alert": "PrometheusMissingRuleEvaluations",
        "annotations": {
          "description": "Prometheus {{$labels.namespace}}/{{$labels.pod}} has missed {{ printf \"%.0f\" $value }} rule group evaluations in the last 5m.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusmissingruleevaluations",
          "summary": "Prometheus is missing rule evaluations due to slow rule group evaluation."
        },
        "expr": "increase(prometheus_rule_group_iterations_missed_total{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}[5m]) > 0",
        "for": "15m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "PrometheusTargetLimitHit",
        "annotations": {
          "description": "Prometheus {{$labels.namespace}}/{{$labels.pod}} has dropped {{ printf \"%.0f\" $value }} targets because the number of targets exceeded the configured target_limit.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheustargetlimithit",
          "summary": "Prometheus has dropped targets because some scrape configs have exceeded the targets limit."
        },
        "expr": "increase(prometheus_target_scrape_pool_exceeded_target_limit_total{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}[5m]) > 0",
        "for": "15m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "PrometheusLabelLimitHit",
        "annotations": {
          "description": "Prometheus {{$labels.namespace}}/{{$labels.pod}} has dropped {{ printf \"%.0f\" $value }} targets because some samples exceeded the configured label_limit, label_name_length_limit or label_value_length_limit.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheuslabellimithit",
          "summary": "Prometheus has dropped targets because some scrape configs have exceeded the labels limit."
        },
        "expr": "increase(prometheus_target_scrape_pool_exceeded_label_limits_total{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}[5m]) > 0",
        "for": "15m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "PrometheusScrapeBodySizeLimitHit",
        "annotations": {
          "description": "Prometheus {{$labels.namespace}}/{{$labels.pod}} has failed {{ printf \"%.0f\" $value }} scrapes in the last 5m because some targets exceeded the configured body_size_limit.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusscrapebodysizelimithit",
          "summary": "Prometheus has dropped some targets that exceeded body size limit."
        },
        "expr": "increase(prometheus_target_scrapes_exceeded_body_size_limit_total{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}[5m]) > 0",
        "for": "15m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "PrometheusScrapeSampleLimitHit",
        "annotations": {
          "description": "Prometheus {{$labels.namespace}}/{{$labels.pod}} has failed {{ printf \"%.0f\" $value }} scrapes in the last 5m because some targets exceeded the configured sample_limit.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusscrapesamplelimithit",
          "summary": "Prometheus has failed scrapes that have exceeded the configured sample limit."
        },
        "expr": "increase(prometheus_target_scrapes_exceeded_sample_limit_total{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}[5m]) > 0",
        "for": "15m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "PrometheusTargetSyncFailure",
        "annotations": {
          "description": "{{ printf \"%.0f\" $value }} targets in Prometheus {{$labels.namespace}}/{{$labels.pod}} have failed to sync because invalid configuration was supplied.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheustargetsyncfailure",
          "summary": "Prometheus has failed to sync targets."
        },
        "expr": "increase(prometheus_target_sync_failed_total{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}[30m]) > 0",
        "for": "5m",
        "labels": {
          "severity": "critical"
        }
      },
      {
        "alert": "PrometheusHighQueryLoad",
        "annotations": {
          "description": "Prometheus {{$labels.namespace}}/{{$labels.pod}} query API has less than 20% available capacity in its query engine for the last 15 minutes.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheushighqueryload",
          "summary": "Prometheus is reaching its maximum capacity serving concurrent requests."
        },
        "expr": "avg_over_time(prometheus_engine_queries{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}[5m]) / max_over_time(prometheus_engine_queries_concurrent_max{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}[5m]) > 0.8",
        "for": "15m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "PrometheusErrorSendingAlertsToAnyAlertmanager",
        "annotations": {
          "description": "{{ printf \"%.1f\" $value }}% minimum errors while sending alerts from Prometheus {{$labels.namespace}}/{{$labels.pod}} to any Alertmanager.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheuserrorsendingalertstoanyalertmanager",
          "summary": "Prometheus encounters more than 3% errors sending alerts to any Alertmanager."
        },
        "expr": "min without (alertmanager) (\n  rate(prometheus_notifications_errors_total{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\",alertmanager!~``}[5m])\n/\n  rate(prometheus_notifications_sent_total{job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\",alertmanager!~``}[5m])\n)\n* 100\n> 3",
        "for": "15m",
        "labels": {
          "severity": "critical"
        }
      }
    ]
  }
,
  {
    "name": "prometheus-operator",
    "rules": [
      {
        "alert": "PrometheusOperatorListErrors",
        "annotations": {
          "description": "Errors while performing List operations in controller {{$labels.controller}} in {{$labels.namespace}} namespace.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/prometheus-operator/prometheusoperatorlisterrors",
          "summary": "Errors while performing list operations in controller."
        },
        "expr": "(sum by (cluster,controller,namespace) (rate(prometheus_operator_list_operations_failed_total{job=\"prometheus-kube-prometheus-operator\",namespace=\"monitoring\"}[10m])) / sum by (cluster,controller,namespace) (rate(prometheus_operator_list_operations_total{job=\"prometheus-kube-prometheus-operator\",namespace=\"monitoring\"}[10m]))) > 0.4",
        "for": "15m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "PrometheusOperatorWatchErrors",
        "annotations": {
          "description": "Errors while performing watch operations in controller {{$labels.controller}} in {{$labels.namespace}} namespace.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/prometheus-operator/prometheusoperatorwatcherrors",
          "summary": "Errors while performing watch operations in controller."
        },
        "expr": "(sum by (cluster,controller,namespace) (rate(prometheus_operator_watch_operations_failed_total{job=\"prometheus-kube-prometheus-operator\",namespace=\"monitoring\"}[5m])) / sum by (cluster,controller,namespace) (rate(prometheus_operator_watch_operations_total{job=\"prometheus-kube-prometheus-operator\",namespace=\"monitoring\"}[5m]))) > 0.4",
        "for": "15m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "PrometheusOperatorSyncFailed",
        "annotations": {
          "description": "Controller {{ $labels.controller }} in {{ $labels.namespace }} namespace fails to reconcile {{ $value }} objects.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/prometheus-operator/prometheusoperatorsyncfailed",
          "summary": "Last controller reconciliation failed"
        },
        "expr": "min_over_time(prometheus_operator_syncs{status=\"failed\",job=\"prometheus-kube-prometheus-operator\",namespace=\"monitoring\"}[5m]) > 0",
        "for": "10m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "PrometheusOperatorReconcileErrors",
        "annotations": {
          "description": "{{ $value | humanizePercentage }} of reconciling operations failed for {{ $labels.controller }} controller in {{ $labels.namespace }} namespace.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/prometheus-operator/prometheusoperatorreconcileerrors",
          "summary": "Errors while reconciling objects."
        },
        "expr": "(sum by (cluster,controller,namespace) (rate(prometheus_operator_reconcile_errors_total{job=\"prometheus-kube-prometheus-operator\",namespace=\"monitoring\"}[5m]))) / (sum by (cluster,controller,namespace) (rate(prometheus_operator_reconcile_operations_total{job=\"prometheus-kube-prometheus-operator\",namespace=\"monitoring\"}[5m]))) > 0.1",
        "for": "10m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "PrometheusOperatorStatusUpdateErrors",
        "annotations": {
          "description": "{{ $value | humanizePercentage }} of status update operations failed for {{ $labels.controller }} controller in {{ $labels.namespace }} namespace.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/prometheus-operator/prometheusoperatorstatusupdateerrors",
          "summary": "Errors while updating objects status."
        },
        "expr": "(sum by (cluster,controller,namespace) (rate(prometheus_operator_status_update_errors_total{job=\"prometheus-kube-prometheus-operator\",namespace=\"monitoring\"}[5m]))) / (sum by (cluster,controller,namespace) (rate(prometheus_operator_status_update_operations_total{job=\"prometheus-kube-prometheus-operator\",namespace=\"monitoring\"}[5m]))) > 0.1",
        "for": "10m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "PrometheusOperatorNodeLookupErrors",
        "annotations": {
          "description": "Errors while reconciling Prometheus in {{ $labels.namespace }} Namespace.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/prometheus-operator/prometheusoperatornodelookuperrors",
          "summary": "Errors while reconciling Prometheus."
        },
        "expr": "rate(prometheus_operator_node_address_lookup_errors_total{job=\"prometheus-kube-prometheus-operator\",namespace=\"monitoring\"}[5m]) > 0.1",
        "for": "10m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "PrometheusOperatorNotReady",
        "annotations": {
          "description": "Prometheus operator in {{ $labels.namespace }} namespace isn't ready to reconcile {{ $labels.controller }} resources.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/prometheus-operator/prometheusoperatornotready",
          "summary": "Prometheus operator not ready"
        },
        "expr": "min by (cluster,controller,namespace) (max_over_time(prometheus_operator_ready{job=\"prometheus-kube-prometheus-operator\",namespace=\"monitoring\"}[5m]) == 0)",
        "for": "5m",
        "labels": {
          "severity": "warning"
        }
      },
      {
        "alert": "PrometheusOperatorRejectedResources",
        "annotations": {
          "description": "Prometheus operator in {{ $labels.namespace }} namespace rejected {{ printf \"%0.0f\" $value }} {{ $labels.controller }}/{{ $labels.resource }} resources.",
          "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/prometheus-operator/prometheusoperatorrejectedresources",
          "summary": "Resources rejected by Prometheus operator"
        },
        "expr": "min_over_time(prometheus_operator_managed_resources{state=\"rejected\",job=\"prometheus-kube-prometheus-operator\",namespace=\"monitoring\"}[5m]) > 0",
        "for": "5m",
        "labels": {
          "severity": "warning"
        }
      }
    ]
  }
]
