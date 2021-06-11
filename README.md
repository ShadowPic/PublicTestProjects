# PublicTestProjects 

This is dedicated to sharing solutions that I come across working with customers world wide.  

## Sections

- JMeter example scripts for various scenarios: [JMeter Scripts](./jmeter)
- Docker based JMeter load testing rig: [Docker Test Rig](./jmeter/docker)
- Unit tests that are used to verify that a JMeter load test passed or failed from the [azure-pipelines.yml](/azure-pipelines.yml) buidl: [JMeter load test verify project](./source/JmeterPipelineValidationTests)
- SQL Server [SSIS Unit Tests](./SSIS Unit Testing)
- Dynamics 365 [FinOps test automation](./DynamicsFinOps)

## Azure Pipeline Yaml

The [azure-pipeline.yml](/azure-pipeline.yml) is an Azure DevOps pipeline script which has the following features:
- Creates a Kubernetes JMeter test rig targeted for Azure Kubernetes Services
- Executes a JMeter test script and then attaches the [JMeter Dashboard](https://jmeter.apache.org/usermanual/generating-dashboard.html) report as an artifact
- Executes the test cases contained in the [JMeter load test verify project](./source/JmeterPipelineValidationTests)
  - Compares the [% of KO](http://www.apdex.org/) against a configurable target
  - Checks if the JMeter [AutoStop Listener](https://jmeter-plugins.org/wiki/AutoStop/?utm_source=jmeter&utm_medium=helplink&utm_campaign=AutoStop) fired
  - Adds an _example_ custom section to the Azure Build Summary which will later contain load test metrics.

## References

- https://github.com/microsoft/azure-pipelines-tasks/blob/master/docs/authoring/commands.md

