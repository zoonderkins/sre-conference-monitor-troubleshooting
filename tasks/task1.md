# 目標
1. fluent bit 加上 filter 及 output 設定
2. checkpoint - 部署後 config 出現對應的值

## Filter Config
```
[FILTER]
    Name grep
    Match kube.*
    Regex message 404
```


## Output Config
```
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


## check endpoint
```
k -n kube-system describe configmap aws-cloudwatch-logs-aws-for-fluent-bit
```