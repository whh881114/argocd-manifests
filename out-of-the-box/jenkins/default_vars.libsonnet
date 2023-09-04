{
  namespace: "jenkins",
  image: "harbor.freedom.org/freedom/jenkins:2.405-centos7",
  image_pull_policy: "IfNotPresent",

  replicas: 1,
  requests_cpu: "100m",
  requests_memory: "128Mi",
  limits_cpu: "4000m",
  limits_memory: "8192Mi",

  container_ports: [
    {name: "http", containerPort: 8080},
    {name: "agent", containerPort: 50000},
    {name: "metrics", containerPort: 60030},
  ],

  storageclass_name: "nfs-infra",
  storageclass_capacity: "50Gi",
}