# JMeter Test Rig Helm Chart

This chart will deploy a JMeter test rig, InfluxDb and Redis cache.  

## Custom Chart Settings

The following settings can be customized for your deployment

### JMeter Master Settings

jmeterMasterImage: shadowpic/jmeter-master:latest
- Docker image used for the JMeter master pod

jmeterMasterMemory: 4Gi
- Maximum memory allowed

jmeterMasterCpu: 2
- Maximum CPUs allowed

### JMeter Slave Settings

jmeterSlaveImage: shadowpic/jmeter-slave:latest
- Docker image used for the JMeter slave pods

replicaCount: 2
- The default number of jmeter slaves

jmeterSlaveMemory: 2Gi
- Maximum memory per slave pod

jmeterSlaveCpu: 2
- Default number of JMeter slaves

### Supporting Services

jmeterInfluxDbImage: influxdb:1.8
- Influx DB docker image

jmeterInfluxDbStorageClass:  # Allow specifying alternate StorageClass
- Allows for an alternate storage class

redis:
  usePassword: false
- Whether or not to require a password for Redis Cache
  cluster:
    enabled: false
- Whether or not to create a Redis cluster or just a single pod