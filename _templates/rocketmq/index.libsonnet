local dockerCredential = import '../_docker_credentials/index.libsonnet';

local Configmap = import './configmap.libsonnet';
local Pvc = import './pvc.libsonnet';
local Service = import './service.libsonnet';
local Statefulset = import './statefulset.libsonnet';
local ServiceMonitor = import './serviceMonitor.libsonnet';
local Deployment = import './deployment.libsonnet';
local Ingress = import '../_ingress_nginx/index.libsonnet';


function(app)
	local configmap = Configmap(app);
	local pvc = Pvc(app);
	local service = Service(app);
	local statefulset = Statefulset(app);
	local serviceMonitor = ServiceMonitor(app);
	local deployment = Deployment(app);
	local ingress = Ingress(app);

  configmap + dockerCredential + service + pvc + statefulset + serviceMonitor + deployment + ingress
