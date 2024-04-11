resource "helm_release" "elasticsearch" {
  name       = "elasticsearch"
  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"
  version    = "7.17.3"
  namespace  = "kube-system"
  values = [
    file("./values/elasticsearch/value.yaml")
  ]
  # set {
  #   name  = "replicas"
  #   value = "1"
  # }

  # # set {
  # #   name = "clusterHealthCheckParams"
  # #   value = "wait_for_status=yellow&timeout=1s"
  # # }

  # set {
  #   name = "minimumMasterNodes"
  #   value = "1"
  # }

#   set {
#     name  = "extraEnvs"
#     value = <<-EOT
#   - name: discovery.type
#     value: single-node
#   - name: node.roles
#     value: master,data,data_content,data_hot,data_warm,data_cold,ingest,ml,remote_cluster_client,transform
# EOT
#   }

  # set {
  #   name = "createCert"
  #   value = false
  # }
}



resource "helm_release" "kibana" {
  name       = "kibana"
  repository = "https://helm.elastic.co"
  chart      = "kibana"
  version    = "7.17.3"
  namespace  = "kube-system"

  depends_on = [
    helm_release.elasticsearch
  ]

}


resource "helm_release" "aws_cloudwatch_logs_for_fluent_bit" {
  name       = "aws-cloudwatch-logs"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-for-fluent-bit"
  version    = "0.1.26"
  namespace  = "kube-system"

  values = [
    file("./values/fluentbit/value.yaml")
  ]

  set {
    name  = "rbac.pspEnabled"
    value = "false"
  }
  set {
    name  = "firehose.enabled"
    value = "false"
  }
  set {
    name  = "kinesis.enabled"
    value = "false"
  }
  set {
    name  = "additionalFilters"
    value = <<-EOT

[FILTER]
    Name grep
    Match kube.*
    Regex log 404

EOT
  }

 
  set {
    name  = "additionalOutputs"
    value = <<-EOT

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
EOT
  }

      
  depends_on = [
    helm_release.kibana
  ]
}


# # input cloudwatch, output elasticsearch
# resource "helm_release" "logstash" {
#   name       = "logstash"
#   repository = "https://helm.elastic.co"
#   chart      = "logstash"
#   version    = "7.17.3"
#   namespace  = "kube-system"

#   values = [
#     file("./values/logstash/value.yaml")
#   ]

#   depends_on = [
#     helm_release.kibana
#   ]
# }

# input cloudwatch, output elasticsearch
resource "helm_release" "log-generator" {
  name       = "log-generator"
  repository = "https://kubernetes-charts.banzaicloud.com"
  chart      = "log-generator"
  version    = "0.1.20"

  depends_on = [
    helm_release.aws_cloudwatch_logs_for_fluent_bit
  ]
}

