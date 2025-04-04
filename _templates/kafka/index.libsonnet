local dockerCredential = import '../_docker_credentials/index.libsonnet';

local Configmap = import './configmap.libsonnet';
local Pvc = import './pvc.libsonnet';
local Service = import './service.libsonnet';
local Statefulset = import './statefulset.libsonnet';
local Deployment = import './deployment.libsonnet';
local Ingress = import './ingress.libsonnet';
local BasicAuth = import './basicAuth.libsonnet';


function(app)
	local pvc = Pvc(app);
	local service = Service(app);
	local statefulset = Statefulset(app);
	local deployment = Deployment(app);
	local ingress = Ingress(app);
	local basicAuth = BasicAuth(app);

	dockerCredential + service + pvc + statefulset + deployment + ingress + basicAuth
