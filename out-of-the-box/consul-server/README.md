# 说明

- k8s集群中部署了consul-agent，它使用到了主机网络，所以consul-server则不能使用nodeport暴露服务。