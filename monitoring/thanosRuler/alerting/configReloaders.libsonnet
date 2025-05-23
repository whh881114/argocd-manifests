local categroy = "config-reloaders";


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
        "severity": "warning",
        "category": categroy,
      }
    }
  ]
}
