resource "helm_release" "elasticsearch" {
  name       = "elasticsearch"
  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"
  version    = "7.17.3"
  namespace  = "kube-system"
  values = [
    file("./values/elasticsearch/value.yaml")
  ]
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

resource "helm_release" "log-generator" {
  name       = "log-generator"
  repository = "https://kubernetes-charts.banzaicloud.com"
  chart      = "log-generator"
  version    = "0.1.20"

  depends_on = [
    helm_release.aws_cloudwatch_logs_for_fluent_bit
  ]
}

