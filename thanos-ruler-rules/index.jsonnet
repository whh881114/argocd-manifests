// 自动生成，不要手动修改

local allAlerting = [
  import 'alerting/alertmanager.libsonnet',
  import 'alerting/configReloaders.libsonnet',
  import 'alerting/etcd.libsonnet',
  import 'alerting/general.libsonnet',
  import 'alerting/kubeApiserverSlos.libsonnet',
  import 'alerting/kubernetesApps.libsonnet',
  import 'alerting/kubernetesResources.libsonnet',
  import 'alerting/kubernetesStorage.libsonnet',
  import 'alerting/kubernetesSystem.libsonnet',
  import 'alerting/kubernetesSystemControllerManager.libsonnet',
  import 'alerting/kubernetesSystemKubelet.libsonnet',
  import 'alerting/kubernetesSystemKubeProxy.libsonnet',
  import 'alerting/kubernetesSystemScheduler.libsonnet',
  import 'alerting/kubeStateMetrics.libsonnet',
  import 'alerting/minioBucketCapacity.libsonnet',
  import 'alerting/nodeExporter.libsonnet',
  import 'alerting/nodeNetwork.libsonnet',
  import 'alerting/prometheus.libsonnet',
  import 'alerting/prometheusOperator.libsonnet',
];

local allRecording = [
  import 'recording/container.libsonnet',
  import 'recording/kubeApiserverAvailability.libsonnet',
  import 'recording/kubeApiserverBurnrate.libsonnet',
  import 'recording/kubeApiserverHistogram.libsonnet',
  import 'recording/kubelet.libsonnet',
  import 'recording/kubePrometheusGeneral.libsonnet',
  import 'recording/kubePrometheusNode.libsonnet',
  import 'recording/kubeScheduler.libsonnet',
  import 'recording/node.libsonnet',
  import 'recording/nodeExporter.libsonnet',
  import 'recording/pod.libsonnet',
];

local prometheusRules = allAlerting + allRecording;
local groups = { 'groups': prometheusRules };

{
  apiVersion: 'v1',
  kind: 'ConfigMap',
  metadata: {
    name: 'thanos-ruler-rules',
  },
  data: {
    'ruler.yml': std.manifestYamlDoc(groups)
  }
}
