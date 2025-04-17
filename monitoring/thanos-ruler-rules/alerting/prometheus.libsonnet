local categroy = "prometheus";


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
        "severity": "critical",
        "category": categroy,
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
        "severity": "warning",
        "category": categroy,
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
        "severity": "warning",
        "category": categroy,
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
        "severity": "warning",
        "category": categroy,
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
        "severity": "warning",
        "category": categroy,
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
        "severity": "warning",
        "category": categroy,
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
        "severity": "warning",
        "category": categroy,
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
        "severity": "warning",
        "category": categroy,
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
        "severity": "warning",
        "category": categroy,
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
        "severity": "warning",
        "category": categroy,
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
        "severity": "warning",
        "category": categroy,
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
        "severity": "critical",
        "category": categroy,
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
        "severity": "critical",
        "category": categroy,
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
        "severity": "warning",
        "category": categroy,
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
        "severity": "critical",
        "category": categroy,
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
        "severity": "warning",
        "category": categroy,
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
        "severity": "warning",
        "category": categroy,
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
        "severity": "warning",
        "category": categroy,
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
        "severity": "warning",
        "category": categroy,
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
        "severity": "warning",
        "category": categroy,
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
        "severity": "critical",
        "category": categroy,
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
        "severity": "warning",
        "category": categroy,
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
        "severity": "critical",
        "category": categroy,
      }
    }
  ]
}
