{
  route: {
    receiver: 'null',
    group_by: ['namespace'],
    continue: false,
    group_wait: '30s',
    group_interval: '5m',
    repeat_interval: '12h',
    routes: [
      {
        receiver: 'null',
        continue: false,
        matchers: ['alertname="Watchdog"'],
      },
    ],
  }
}