# Filter Config
```
[FILTER]
    Name grep
    Match kube.*
    Regex log 404
```


# Output Config
```
[OUTPUT]
    Name                  cloudwatch
    Match                 *
    region                ap-northeast-1
    log_group_name        /aws/containerinsights/${local.project_name}/application
    log_stream_prefix     fluentbit-
    log_retention_days    ${var.cloudwatch_log_retention_days}
    auto_create_group     true

[OUTPUT]
    Name                  cloudwatch_logs
    Match                 *
    region                ap-northeast-1
    log_group_name        /aws/eks/fluentbit-cloudwatch/logs
    log_group_template    /aws/eks/fluentbit-cloudwatch/workload/$kubernetes['namespace_name']
    log_stream_prefix     fluentbit-
    log_stream_template   $kubernetes['pod_name'].$kubernetes['container_name']
    auto_create_group     true

[OUTPUT]
    Name            es
    Match           kube.*
    Host            elasticsearch-master.kube-system.svc.cluster.local
    Port            9200
    AWS_Auth        Off
    TLS             On
    tls.verify     On
    Retry_Limit     6
    HTTP_User       elastic
    HTTP_Passwd     ul8x5B01s5kf3sk
    Index           ${local.project_name}-application-logs-%Y.%W
    Suppress_Type_Name On
    tls.ca_file /fluentd/elastic/ca.crt
    tls.crt_file /fluentd/elastic/tls.crt
    tls.key_file /fluentd/elastic/tls.key 
```


check endpoint
```
k -n kube-system describe configmap aws-cloudwatch-logs-aws-for-fluent-bit
```