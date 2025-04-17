local categroy = "node-exporter";


{
  "name": "node-exporter",
  "rules": [
    {
      "alert": "NodeFilesystemSpaceFillingUp",
      "annotations": {
        "description": "Filesystem on {{ $labels.device }}, mounted on {{ $labels.mountpoint }}, at {{ $labels.instance }} has only {{ printf \"%.2f\" $value }}% available space left and is filling up.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodefilesystemspacefillingup",
        "summary": "Filesystem is predicted to run out of space within the next 24 hours."
      },
      "expr": "(\n  node_filesystem_avail_bytes{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} / node_filesystem_size_bytes{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} * 100 < 15\nand\n  predict_linear(node_filesystem_avail_bytes{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"}[6h], 24*60*60) < 0\nand\n  node_filesystem_readonly{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} == 0\n)",
      "for": "1h",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "NodeFilesystemSpaceFillingUp",
      "annotations": {
        "description": "Filesystem on {{ $labels.device }}, mounted on {{ $labels.mountpoint }}, at {{ $labels.instance }} has only {{ printf \"%.2f\" $value }}% available space left and is filling up fast.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodefilesystemspacefillingup",
        "summary": "Filesystem is predicted to run out of space within the next 4 hours."
      },
      "expr": "(\n  node_filesystem_avail_bytes{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} / node_filesystem_size_bytes{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} * 100 < 10\nand\n  predict_linear(node_filesystem_avail_bytes{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"}[6h], 4*60*60) < 0\nand\n  node_filesystem_readonly{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} == 0\n)",
      "for": "1h",
      "labels": {
        "severity": "critical",
        "category": categroy,
      }
    },
    {
      "alert": "NodeFilesystemAlmostOutOfSpace",
      "annotations": {
        "description": "Filesystem on {{ $labels.device }}, mounted on {{ $labels.mountpoint }}, at {{ $labels.instance }} has only {{ printf \"%.2f\" $value }}% available space left.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodefilesystemalmostoutofspace",
        "summary": "Filesystem has less than 5% space left."
      },
      "expr": "(\n  node_filesystem_avail_bytes{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} / node_filesystem_size_bytes{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} * 100 < 5\nand\n  node_filesystem_readonly{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} == 0\n)",
      "for": "30m",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "NodeFilesystemAlmostOutOfSpace",
      "annotations": {
        "description": "Filesystem on {{ $labels.device }}, mounted on {{ $labels.mountpoint }}, at {{ $labels.instance }} has only {{ printf \"%.2f\" $value }}% available space left.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodefilesystemalmostoutofspace",
        "summary": "Filesystem has less than 3% space left."
      },
      "expr": "(\n  node_filesystem_avail_bytes{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} / node_filesystem_size_bytes{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} * 100 < 3\nand\n  node_filesystem_readonly{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} == 0\n)",
      "for": "30m",
      "labels": {
        "severity": "critical",
        "category": categroy,
      }
    },
    {
      "alert": "NodeFilesystemFilesFillingUp",
      "annotations": {
        "description": "Filesystem on {{ $labels.device }}, mounted on {{ $labels.mountpoint }}, at {{ $labels.instance }} has only {{ printf \"%.2f\" $value }}% available inodes left and is filling up.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodefilesystemfilesfillingup",
        "summary": "Filesystem is predicted to run out of inodes within the next 24 hours."
      },
      "expr": "(\n  node_filesystem_files_free{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} / node_filesystem_files{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} * 100 < 40\nand\n  predict_linear(node_filesystem_files_free{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"}[6h], 24*60*60) < 0\nand\n  node_filesystem_readonly{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} == 0\n)",
      "for": "1h",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "NodeFilesystemFilesFillingUp",
      "annotations": {
        "description": "Filesystem on {{ $labels.device }}, mounted on {{ $labels.mountpoint }}, at {{ $labels.instance }} has only {{ printf \"%.2f\" $value }}% available inodes left and is filling up fast.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodefilesystemfilesfillingup",
        "summary": "Filesystem is predicted to run out of inodes within the next 4 hours."
      },
      "expr": "(\n  node_filesystem_files_free{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} / node_filesystem_files{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} * 100 < 20\nand\n  predict_linear(node_filesystem_files_free{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"}[6h], 4*60*60) < 0\nand\n  node_filesystem_readonly{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} == 0\n)",
      "for": "1h",
      "labels": {
        "severity": "critical",
        "category": categroy,
      }
    },
    {
      "alert": "NodeFilesystemAlmostOutOfFiles",
      "annotations": {
        "description": "Filesystem on {{ $labels.device }}, mounted on {{ $labels.mountpoint }}, at {{ $labels.instance }} has only {{ printf \"%.2f\" $value }}% available inodes left.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodefilesystemalmostoutoffiles",
        "summary": "Filesystem has less than 5% inodes left."
      },
      "expr": "(\n  node_filesystem_files_free{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} / node_filesystem_files{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} * 100 < 5\nand\n  node_filesystem_readonly{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} == 0\n)",
      "for": "1h",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "NodeFilesystemAlmostOutOfFiles",
      "annotations": {
        "description": "Filesystem on {{ $labels.device }}, mounted on {{ $labels.mountpoint }}, at {{ $labels.instance }} has only {{ printf \"%.2f\" $value }}% available inodes left.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodefilesystemalmostoutoffiles",
        "summary": "Filesystem has less than 3% inodes left."
      },
      "expr": "(\n  node_filesystem_files_free{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} / node_filesystem_files{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} * 100 < 3\nand\n  node_filesystem_readonly{job=\"node-exporter\",fstype!=\"\",mountpoint!=\"\"} == 0\n)",
      "for": "1h",
      "labels": {
        "severity": "critical",
        "category": categroy,
      }
    },
    {
      "alert": "NodeNetworkReceiveErrs",
      "annotations": {
        "description": "{{ $labels.instance }} interface {{ $labels.device }} has encountered {{ printf \"%.0f\" $value }} receive errors in the last two minutes.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodenetworkreceiveerrs",
        "summary": "Network interface is reporting many receive errors."
      },
      "expr": "rate(node_network_receive_errs_total{job=\"node-exporter\"}[2m]) / rate(node_network_receive_packets_total{job=\"node-exporter\"}[2m]) > 0.01",
      "for": "1h",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "NodeNetworkTransmitErrs",
      "annotations": {
        "description": "{{ $labels.instance }} interface {{ $labels.device }} has encountered {{ printf \"%.0f\" $value }} transmit errors in the last two minutes.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodenetworktransmiterrs",
        "summary": "Network interface is reporting many transmit errors."
      },
      "expr": "rate(node_network_transmit_errs_total{job=\"node-exporter\"}[2m]) / rate(node_network_transmit_packets_total{job=\"node-exporter\"}[2m]) > 0.01",
      "for": "1h",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "NodeHighNumberConntrackEntriesUsed",
      "annotations": {
        "description": "{{ $value | humanizePercentage }} of conntrack entries are used.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodehighnumberconntrackentriesused",
        "summary": "Number of conntrack are getting close to the limit."
      },
      "expr": "(node_nf_conntrack_entries{job=\"node-exporter\"} / node_nf_conntrack_entries_limit) > 0.75",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "NodeTextFileCollectorScrapeError",
      "annotations": {
        "description": "Node Exporter text file collector on {{ $labels.instance }} failed to scrape.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodetextfilecollectorscrapeerror",
        "summary": "Node Exporter text file collector failed to scrape."
      },
      "expr": "node_textfile_scrape_error{job=\"node-exporter\"} == 1",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "NodeClockSkewDetected",
      "annotations": {
        "description": "Clock at {{ $labels.instance }} is out of sync by more than 0.05s. Ensure NTP is configured correctly on this host.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodeclockskewdetected",
        "summary": "Clock skew detected."
      },
      "expr": "(\n  node_timex_offset_seconds{job=\"node-exporter\"} > 0.05\nand\n  deriv(node_timex_offset_seconds{job=\"node-exporter\"}[5m]) >= 0\n)\nor\n(\n  node_timex_offset_seconds{job=\"node-exporter\"} < -0.05\nand\n  deriv(node_timex_offset_seconds{job=\"node-exporter\"}[5m]) <= 0\n)",
      "for": "10m",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "NodeClockNotSynchronising",
      "annotations": {
        "description": "Clock at {{ $labels.instance }} is not synchronising. Ensure NTP is configured on this host.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodeclocknotsynchronising",
        "summary": "Clock not synchronising."
      },
      "expr": "min_over_time(node_timex_sync_status{job=\"node-exporter\"}[5m]) == 0\nand\nnode_timex_maxerror_seconds{job=\"node-exporter\"} >= 16",
      "for": "10m",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "NodeRAIDDegraded",
      "annotations": {
        "description": "RAID array '{{ $labels.device }}' at {{ $labels.instance }} is in degraded state due to one or more disks failures. Number of spare drives is insufficient to fix issue automatically.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/noderaiddegraded",
        "summary": "RAID Array is degraded."
      },
      "expr": "node_md_disks_required{job=\"node-exporter\",device=~\"(/dev/)?(mmcblk.p.+|nvme.+|rbd.+|sd.+|vd.+|xvd.+|dm-.+|md.+|dasd.+)\"} - ignoring (state) (node_md_disks{state=\"active\",job=\"node-exporter\",device=~\"(/dev/)?(mmcblk.p.+|nvme.+|rbd.+|sd.+|vd.+|xvd.+|dm-.+|md.+|dasd.+)\"}) > 0",
      "for": "15m",
      "labels": {
        "severity": "critical",
        "category": categroy,
      }
    },
    {
      "alert": "NodeRAIDDiskFailure",
      "annotations": {
        "description": "At least one device in RAID array at {{ $labels.instance }} failed. Array '{{ $labels.device }}' needs attention and possibly a disk swap.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/noderaiddiskfailure",
        "summary": "Failed device in RAID array."
      },
      "expr": "node_md_disks{state=\"failed\",job=\"node-exporter\",device=~\"(/dev/)?(mmcblk.p.+|nvme.+|rbd.+|sd.+|vd.+|xvd.+|dm-.+|md.+|dasd.+)\"} > 0",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "NodeFileDescriptorLimit",
      "annotations": {
        "description": "File descriptors limit at {{ $labels.instance }} is currently at {{ printf \"%.2f\" $value }}%.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodefiledescriptorlimit",
        "summary": "Kernel is predicted to exhaust file descriptors limit soon."
      },
      "expr": "(\n  node_filefd_allocated{job=\"node-exporter\"} * 100 / node_filefd_maximum{job=\"node-exporter\"} > 70\n)",
      "for": "15m",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "NodeFileDescriptorLimit",
      "annotations": {
        "description": "File descriptors limit at {{ $labels.instance }} is currently at {{ printf \"%.2f\" $value }}%.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodefiledescriptorlimit",
        "summary": "Kernel is predicted to exhaust file descriptors limit soon."
      },
      "expr": "(\n  node_filefd_allocated{job=\"node-exporter\"} * 100 / node_filefd_maximum{job=\"node-exporter\"} > 90\n)",
      "for": "15m",
      "labels": {
        "severity": "critical",
        "category": categroy,
      }
    },
    {
      "alert": "NodeCPUHighUsage",
      "annotations": {
        "description": "CPU usage at {{ $labels.instance }} has been above 90% for the last 15 minutes, is currently at {{ printf \"%.2f\" $value }}%.\n",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodecpuhighusage",
        "summary": "High CPU usage."
      },
      "expr": "sum without(mode) (avg without (cpu) (rate(node_cpu_seconds_total{job=\"node-exporter\", mode!=\"idle\"}[2m]))) * 100 > 90",
      "for": "15m",
      "labels": {
        "severity": "info",
        "category": categroy,
      }
    },
    {
      "alert": "NodeSystemSaturation",
      "annotations": {
        "description": "System load per core at {{ $labels.instance }} has been above 2 for the last 15 minutes, is currently at {{ printf \"%.2f\" $value }}.\nThis might indicate this instance resources saturation and can cause it becoming unresponsive.\n",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodesystemsaturation",
        "summary": "System saturated, load per core is very high."
      },
      "expr": "node_load1{job=\"node-exporter\"}\n/ count without (cpu, mode) (node_cpu_seconds_total{job=\"node-exporter\", mode=\"idle\"}) > 2",
      "for": "15m",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "NodeMemoryMajorPagesFaults",
      "annotations": {
        "description": "Memory major pages are occurring at very high rate at {{ $labels.instance }}, 500 major page faults per second for the last 15 minutes, is currently at {{ printf \"%.2f\" $value }}.\nPlease check that there is enough memory available at this instance.\n",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodememorymajorpagesfaults",
        "summary": "Memory major page faults are occurring at very high rate."
      },
      "expr": "rate(node_vmstat_pgmajfault{job=\"node-exporter\"}[5m]) > 500",
      "for": "15m",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "NodeMemoryHighUtilization",
      "annotations": {
        "description": "Memory is filling up at {{ $labels.instance }}, has been above 90% for the last 15 minutes, is currently at {{ printf \"%.2f\" $value }}%.\n",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodememoryhighutilization",
        "summary": "Host is running out of memory."
      },
      "expr": "100 - (node_memory_MemAvailable_bytes{job=\"node-exporter\"} / node_memory_MemTotal_bytes{job=\"node-exporter\"} * 100) > 90",
      "for": "15m",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "NodeDiskIOSaturation",
      "annotations": {
        "description": "Disk IO queue (aqu-sq) is high on {{ $labels.device }} at {{ $labels.instance }}, has been above 10 for the last 30 minutes, is currently at {{ printf \"%.2f\" $value }}.\nThis symptom might indicate disk saturation.\n",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodediskiosaturation",
        "summary": "Disk IO queue is high."
      },
      "expr": "rate(node_disk_io_time_weighted_seconds_total{job=\"node-exporter\", device=~\"(/dev/)?(mmcblk.p.+|nvme.+|rbd.+|sd.+|vd.+|xvd.+|dm-.+|md.+|dasd.+)\"}[5m]) > 10",
      "for": "30m",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "NodeSystemdServiceFailed",
      "annotations": {
        "description": "Systemd service {{ $labels.name }} has entered failed state at {{ $labels.instance }}",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodesystemdservicefailed",
        "summary": "Systemd service has entered failed state."
      },
      "expr": "node_systemd_unit_state{job=\"node-exporter\", state=\"failed\"} == 1",
      "for": "5m",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    },
    {
      "alert": "NodeBondingDegraded",
      "annotations": {
        "description": "Bonding interface {{ $labels.master }} on {{ $labels.instance }} is in degraded state due to one or more slave failures.",
        "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/node/nodebondingdegraded",
        "summary": "Bonding interface is degraded"
      },
      "expr": "(node_bonding_slaves - node_bonding_active) != 0",
      "for": "5m",
      "labels": {
        "severity": "warning",
        "category": categroy,
      }
    }
  ]
}
