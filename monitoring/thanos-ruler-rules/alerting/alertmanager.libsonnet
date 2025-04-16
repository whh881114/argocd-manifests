local categroy = "alertmanager";

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
          "severity": "critical",
          "category": categroy,
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
          "severity": "critical",
          "category": categroy,
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
          "severity": "warning",
          "category": categroy,
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
          "severity": "critical",
          "category": categroy,
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
          "severity": "warning",
          "category": categroy,
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
          "severity": "critical",
          "category": categroy,
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
          "severity": "critical",
          "category": categroy,
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
          "severity": "critical",
          "category": categroy,
        }
      }
    ]
  }
]