{
  namespace: "jenkins",
  image: "jenkins/jenkins",
  image_tag: "2.403-jdk11",

  replicas: 1,
  requests_cpu: "100m",
  requests_memory: "128Mi",
  limits_cpu: "4000m",
  limits_memory: "8192Mi",

  container_ports: [
    {name: "http", containerPort: 8080},
    {name: "agent", containerPort: 5000},
    {name: "metrics", containerPort: 60030},
  ],
}