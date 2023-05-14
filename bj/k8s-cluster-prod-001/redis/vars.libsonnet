{
  namespace: "redis",
  image: "harbor.freedom.org/docker.io/redis",
  image_tag: "5.0.7",
  image_pull_policy: "IfNotPresent",

  replicas: 1,
  requests_cpu: "100m",
  requests_memory: "128Mi",
  limits_cpu: "1000m",
  limits_memory: "2048Mi",

  storage_class: "nfs-redis",
  storage_class_capacity: "10Gi",
}