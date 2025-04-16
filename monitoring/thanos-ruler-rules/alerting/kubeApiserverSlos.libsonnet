local categroy = "kube-apiserver-slos";

[
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
          "category": categroy,
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
          "category": categroy,
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
          "category": categroy,
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
          "category": categroy,
          "short": "6h"
        }
      }
    ]
  }
]