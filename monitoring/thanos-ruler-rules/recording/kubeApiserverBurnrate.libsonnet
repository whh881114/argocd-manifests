[
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
]