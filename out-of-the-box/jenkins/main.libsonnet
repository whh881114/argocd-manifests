local func_namespace = import 'namespace.libsonnet';
local func_service_clusterip = import './service_clusterip.libsonnet';
local func_service_nodeport = import './service_nodeport.libsonnet';
local func_pvc = import './pvc.libsonnet';
local func_statefulset = import './statefulset.libsonnet';
local func_ingress = import './ingress.libsonnet';
local func_service_monitor = import './service_monitor.libsonnet';

function(instance)
  local namespace = func_namespace(instance);
  local service_clusterip = func_service_clusterip(instance);
  local service_nodeport = func_service_nodeport(instance);
  local pvc = func_pvc(instance);
  local statefulset = func_statefulset(instance);
  local ingress = func_ingress(instance);
  local service_monitor = func_service_monitor(instance);

  [namespace, service_clusterip, service_nodeport, pvc, statefulset, ingress, service_monitor]


// 调试验证变量函数化功能
// local vars = import './vars.libsonnet';
// function(instance)
//     local item = vars(instance);
//     [item]