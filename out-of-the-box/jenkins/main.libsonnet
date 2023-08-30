local global_vars = import '../global_vars.libsonnet';

local namespace = import 'namespace.libsonnet';
local service_clusterip = import './service_clusterip.libsonnet';
local service_nodeport = import './service_nodeport.libsonnet';
local pvc = import './pvc.libsonnet';

function(instance)
    local namespace_item = namespace(instance);
    local service_clusterip_item = service_clusterip(instance);
    local service_nodeport_item = service_nodeport(instance);
    #local pvc_item = pvc(instance);

    [namespace_item, service_clusterip_item, service_nodeport_item]
    #[namespace_item, service_clusterip_item, service_nodeport_item, pvc_item]
