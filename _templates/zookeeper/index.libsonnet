local dockerCredential = import '../_docker_credentials/index.libsonnet';

local Configmap = import './configmap.libsonnet';
local Service = import './service.libsonnet';
local Statefulset = import './statefulset.libsonnet';


function(app)
	local configmap = Configmap(app);
	local service = Service(app);
	local statefulset = Statefulset(app);

	dockerCredential + service + configmap + statefulset