local global_vars = import '../global_vars.libsonnet';

local namespace = import 'namespace.libsonnet';
local service_clusterip = import './service_clusterip.libsonnet';
local service_nodeport = import './service_nodeport.libsonnet';
local pvc = import './pvc.libsonnet';
local statefulset = import './statefulset.libsonnet';
local ingress = import './ingress.libsonnet';

function(instance)
    local namespace_item = namespace(instance);
    local service_clusterip_item = service_clusterip(instance);
    local service_nodeport_item = service_nodeport(instance);
    local pvc_item = pvc(instance);
    local statefulset_item = statefulset(instance);
    local ingress_item = ingress(instance);

    [namespace_item, service_clusterip_item, service_nodeport_item, pvc_item, statefulset_item, ingress_item]
