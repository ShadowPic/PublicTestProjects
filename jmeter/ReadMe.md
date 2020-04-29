#JMeter Scripts

I create JMeter demo scripts several times a week.  Examples that may provide some value to others will be posted here.

| JMX File  | Summary | Additional Notes |
| --- | --- | --- |
|DRParts.jmx|Most of my JMeter demos use this as the primary demo file.  It is also the JMX file referenced by the Azure Pipeline script|Leverages the [Backend Listener](https://jmeter.apache.org/usermanual/component_reference.html#Backend_Listener) to provide realtime monitoring during tests.|
|CallAzureFunction.jmx|Provides one method to call .NET Core code from JMeter via K8S hosted Azure Functions|Usaes a sample [Azure Function project](../source/DarrenFunctionPlayground)| 
