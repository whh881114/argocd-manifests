[
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
]