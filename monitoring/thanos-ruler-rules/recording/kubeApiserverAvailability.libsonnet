[
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
]