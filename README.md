# argocd manifests规划

## 前言
argocd manifests的这些文件必须要让运维管理，因为运维才会知悉kubernetes集群状态，如cpu/mem资源，负载均衡信息，ingress入口地址，  
域名解析，storageclass所用的到存储后端 ......


## 目标
- 通用性强，独立出特定环境，可以在另一个环境中，做简单的修改即可使用。
- 灵活性强，编写模板时，不要使用硬编码，变量声明文件只允许存在模板下的vars.libsonnet文件中。


# 文档
- https://argo-cd.readthedocs.io/en/stable/user-guide/application-specification/


## 目录规划
- 目录规划
  ```
  _indexes/
    - index.jsonnet
  _templates/
      - redis/
        - vars.libsonnet
        - .......
        - .......
      - mysql/
        - vars.libsonnet
        - .......
        - .......
      - .......
      - .......
      - .......
  plain_manifests/
  redis/
  appIndex.libsonnet
  clusterParams.libsonnet
  ......
  ......
  ......
  ```

- 目录文件说明
  - _indexes：本目录保存了所有的`ArgoCD Application`声明文件，作为索引。
    - index.jsonnet，负责生成自定义`ArgoCD Application`声明文件，作为索引。

  - _templates：模板目录，所有的角色均在此目录。
    - redis，redis模板目录，目录下与redis相关的文件都放在此目录中。
      - index.libsonnet，整合所有资源的索引文件。
  
  - plain_manifests：声明式资源文件，支持文件格式有yaml和json。用于存放非argocd项目的文件清单目录。

  - redis：实际的应用目录，创建出一个相对应的namespace，目录下的文件可以引用任何模板，配置相对应的参数即可。

  - appIndex.libsonnet：指定生成哪些application的清单，一个名称对应一个目录，如redis。
  
  - clusterParams.libsonnet：集群全局变量。



## jsonnet变量名规范
- 小驼峰命名法 (lowerCamelCase)：第一个单词的首字母小写，其余单词的首字母大写。例子：`firstName`, `lastName`, `currentPage`。

- 下划线命名法 (Snake Case)：全大写，单词之间用下划线分隔。适用于常量和枚举值。例子：`MAX_VALUE`, `ERROR_CODE`。