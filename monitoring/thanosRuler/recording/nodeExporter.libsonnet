
{
  "name": "node-exporter.rules",
  "rules": [
    {
      "expr": "count without (cpu, mode) (\n  node_cpu_seconds_total{job=\"node-exporter\",mode=\"idle\"}\n)",
      "record": "instance:node_num_cpu:sum"
    },
    {
      "expr": "1 - avg without (cpu) (\n  sum without (mode) (rate(node_cpu_seconds_total{job=\"node-exporter\", mode=~\"idle|iowait|steal\"}[5m]))\n)",
      "record": "instance:node_cpu_utilisation:rate5m"
    },
    {
      "expr": "(\n  node_load1{job=\"node-exporter\"}\n/\n  instance:node_num_cpu:sum{job=\"node-exporter\"}\n)",
      "record": "instance:node_load1_per_cpu:ratio"
    },
    {
      "expr": "1 - (\n  (\n    node_memory_MemAvailable_bytes{job=\"node-exporter\"}\n    or\n    (\n      node_memory_Buffers_bytes{job=\"node-exporter\"}\n      +\n      node_memory_Cached_bytes{job=\"node-exporter\"}\n      +\n      node_memory_MemFree_bytes{job=\"node-exporter\"}\n      +\n      node_memory_Slab_bytes{job=\"node-exporter\"}\n    )\n  )\n/\n  node_memory_MemTotal_bytes{job=\"node-exporter\"}\n)",
      "record": "instance:node_memory_utilisation:ratio"
    },
    {
      "expr": "rate(node_vmstat_pgmajfault{job=\"node-exporter\"}[5m])",
      "record": "instance:node_vmstat_pgmajfault:rate5m"
    },
    {
      "expr": "rate(node_disk_io_time_seconds_total{job=\"node-exporter\", device=~\"(/dev/)?(mmcblk.p.+|nvme.+|rbd.+|sd.+|vd.+|xvd.+|dm-.+|md.+|dasd.+)\"}[5m])",
      "record": "instance_device:node_disk_io_time_seconds:rate5m"
    },
    {
      "expr": "rate(node_disk_io_time_weighted_seconds_total{job=\"node-exporter\", device=~\"(/dev/)?(mmcblk.p.+|nvme.+|rbd.+|sd.+|vd.+|xvd.+|dm-.+|md.+|dasd.+)\"}[5m])",
      "record": "instance_device:node_disk_io_time_weighted_seconds:rate5m"
    },
    {
      "expr": "sum without (device) (\n  rate(node_network_receive_bytes_total{job=\"node-exporter\", device!=\"lo\"}[5m])\n)",
      "record": "instance:node_network_receive_bytes_excluding_lo:rate5m"
    },
    {
      "expr": "sum without (device) (\n  rate(node_network_transmit_bytes_total{job=\"node-exporter\", device!=\"lo\"}[5m])\n)",
      "record": "instance:node_network_transmit_bytes_excluding_lo:rate5m"
    },
    {
      "expr": "sum without (device) (\n  rate(node_network_receive_drop_total{job=\"node-exporter\", device!=\"lo\"}[5m])\n)",
      "record": "instance:node_network_receive_drop_excluding_lo:rate5m"
    },
    {
      "expr": "sum without (device) (\n  rate(node_network_transmit_drop_total{job=\"node-exporter\", device!=\"lo\"}[5m])\n)",
      "record": "instance:node_network_transmit_drop_excluding_lo:rate5m"
    }
  ]
}
