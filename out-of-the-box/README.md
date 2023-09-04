# out-of-the-box

## 说明
- `out-of-the-box`，开箱即用，这一类的应用针对于中间件，可视为基础设施。
- `out-of-the-box`下的各个目录，表示各个中间件默认名称，以`jenkins`目录说明。 
  -`default_vars.libsonnet`，默认变量文件。
  - `instances/bundle.jsonnet`，渲染入口文件。
  - `instances/instances.jsonnet`，定义实例清单文件，实例中的变量名，均可以重新定义，参考默认变量文件`default_vars.libsonnet`。