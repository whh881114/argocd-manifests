#!/bin/bash

OUTPUT_FILE="index.jsonnet"

echo "// 自动生成，不要手动修改" > "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# 生成 alerting 内容
echo "local allAlerting = [" >> "$OUTPUT_FILE"
for file in alerting/*.libsonnet; do
  echo "  import '$file'," >> "$OUTPUT_FILE"
done
echo "];" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# 生成 recording 内容
echo "local allRecording = [" >> "$OUTPUT_FILE"
for file in recording/*.libsonnet; do
  echo "  import '$file'," >> "$OUTPUT_FILE"
done
echo "];" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# 合并并生成 ConfigMap 内容
cat <<EOF >> "$OUTPUT_FILE"
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
EOF

echo "✅ index.jsonnet 已生成完成，包含静态 import 路径。"
