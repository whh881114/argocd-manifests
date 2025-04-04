{
  inhibit_rules: [
    {
      source_matchers: ['severity="critical"'],
      target_matchers: ['severity=~"warning|info"'],
      equal: ['namespace','alertname'],
    },
    {
      source_matchers: ['severity="warning"'],
      target_matchers: ['severity="info"'],
      equal: ['namespace','alertname'],
    },
    {
      source_matchers: ['alertname="InfoInhibitor"'],
      target_matchers: ['severity="info"'],
      equal: ['namespace'],
    },
    {
      target_matchers: ['alertname="InfoInhibitor"'],
    },
  ]
}