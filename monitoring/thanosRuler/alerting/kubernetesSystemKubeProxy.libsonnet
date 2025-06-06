local categroy = "kubernetes-system-kube-proxy";


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
        "severity": "critical",
        "category": categroy,
      }
    }
  ]
}
