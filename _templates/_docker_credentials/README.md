# 创建dockerconfigjson

## 步骤
- 使用`kubectl`命令创建`secret`。
```shell
kubectl create secret docker-registry my-docker-secret \
    --docker-server=<REGISTRY_URL> \
    --docker-username=<USERNAME> \
    --docker-password=<PASSWORD>
```

- 查看`secret`中的`.dockerconfigjson`，然后更新到文件`harbor_idc_roywong_work.libsonnet`相对应的位置。
```shell
kubectl edit secret my-docker-secret 
```