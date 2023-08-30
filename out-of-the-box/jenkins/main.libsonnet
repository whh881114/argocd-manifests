local global_vars = import '../global_vars.libsonnet';

local namespace = import 'namespace.libsonnet';
local service_clusterip = import './service_clusterip.libsonnet';
local service_nodeport = import './service_nodeport.libsonnet';

function(instance)
    local namespace_item = namespace(instance);
    local service_clusterip_item = service_clusterip(instance);
    local service_nodeport_item = service_nodeport(instance);

    [namespace_item, service_clusterip_item, service_nodeport_item]
