local vars = import './vars.libsonnet';


function(instance)
  local namespace = if 'namespace' in instance then instance.namespace else vars.namespace;
  local mysql_root_password = if 'root_password' in instance then instance.root_password else vars.root_password;
  local mysql_conf = if 'conf' in instance then instance.conf else vars.conf;
  local mysqld_exporter_data_source_name = if 'mysqld_exporter_data_source_name' in instance then instance.mysqld_exporter_data_source_name else vars.mysqld_exporter_data_source_name;

  local item = {
    apiVersion: 'v1',
    kind: 'ConfigMap',
    metadata: {
      name: instance.name,
      namespace: namespace,
    },
    data: {
      'MYSQL_ROOT_PASSWORD': mysql_root_password,
      'DATA_SOURCE_NAME': mysqld_exporter_data_source_name,
      'my.cnf': mysql_conf,
    }
  };

  item

// 配置mysqld_exporter用户监控
// CREATE USER 'exporter'@'localhost' IDENTIFIED BY 'pJwtdho13jLipiyquxldnqialgrpkvl~';
// GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'localhost';
// FLUSH PRIVILEGES;
// EXIT