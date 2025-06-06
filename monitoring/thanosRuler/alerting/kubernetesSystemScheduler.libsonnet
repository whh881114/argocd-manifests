local categroy = "kubernetes-system-scheduler";


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
        "severity": "critical",
        "category": categroy,
      }
    }
  ]
}
