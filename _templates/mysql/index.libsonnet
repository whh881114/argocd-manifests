local dockerCredential = import '../_docker_credentials/index.libsonnet';

local Configmap = import './configmap.libsonnet';
local Pvc = import './pvc.libsonnet';
local Service = import './service.libsonnet';
local Statefulset = import './statefulset.libsonnet';
local ServiceMonitor = import './serviceMonitor.libsonnet';


function(app)
	local configmap = Configmap(app);
	local pvc = Pvc(app);
	local service = Service(app);
	local statefulset = Statefulset(app);
	local serviceMonitor = ServiceMonitor(app);

	dockerCredential + service + [configmap, pvc, statefulset, serviceMonitor]
