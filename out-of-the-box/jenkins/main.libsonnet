local func_namespace = import 'namespace.libsonnet';
local func_service_clusterip = import './service_clusterip.libsonnet';
local func_service_nodeport = import './service_nodeport.libsonnet';
// local pvc = import './pvc.libsonnet';
// local statefulset = import './statefulset.libsonnet';
// local ingress = import './ingress.libsonnet';
// local service_monitor = import './service_monitor.libsonnet';

function(instance)
  local namespace = func_namespace(instance);
  local service_clusterip = func_service_clusterip(instance);
  local service_nodeport = func_service_nodeport(instance);
  // local pvc_item = pvc(instance);
  // local statefulset_item = statefulset(instance);
  // local ingress_item = ingress(instance);
  // local service_monitor_item = service_monitor(instance);

  // [namespace_item, service_clusterip_item, service_nodeport_item, pvc_item, statefulset_item, ingress_item, service_monitor_item]
  [namespace, service_clusterip, service_nodeport,]


// 调试验证变量函数化功能
// local vars = import './vars.libsonnet';
// function(instance)
//     local item = vars(instance);
//     [item]