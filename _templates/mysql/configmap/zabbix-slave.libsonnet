local conf = |||
  [mysqld]
  skip-host-cache
  skip-name-resolve
  datadir=/var/lib/mysql
  socket=/var/run/mysqld/mysqld.sock
  secure-file-priv=/var/lib/mysql-files
  user=mysql
  pid-file=/var/run/mysqld/mysqld.pid
  #GTID
  gtid_mode=on
  enforce_gtid_consistency=on
  server_id=2
  log-bin=slave-binlog
  log-slave-updates=true
  binlog_format=row
  skip_slave_start=1
  [client]
  socket=/var/run/mysqld/mysqld.sock
  !includedir /etc/mysql/conf.d/
|||;

conf