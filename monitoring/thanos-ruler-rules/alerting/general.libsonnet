local categroy = "general";

[
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
          "severity": "warning",
          "category": categroy,
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
          "severity": "none",
          "category": categroy,
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
          "severity": "none",
          "category": categroy,
        }
      }
    ]
  }
]