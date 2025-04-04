# kafka

## 配置说明
- 集群模式部署，[参考官方docker-compose文档](https://github.com/apache/kafka/blob/trunk/docker/examples/docker-compose-files/cluster/combined/plaintext/docker-compose.yml)。
- KAFKA_LOG_DIRS，环境变量用于指定Kafka存储日志文件的目录，实质上是kafka的数据目录，避免引起歧义，使用kafkaDataDir变量指定其值。