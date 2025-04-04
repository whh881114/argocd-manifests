local conf = |||
  [mysqld]
  skip-host-cache
  skip-name-resolve
  datadir=/var/lib/mysql
  socket=/var/run/mysqld/mysqld.sock
  secure-file-priv=/var/lib/mysql-files
  user=mysql
  pid-file=/var/run/mysqld/mysqld.pid
  [client]
  socket=/var/run/mysqld/mysqld.sock
  !includedir /etc/mysql/conf.d/
|||;

conf