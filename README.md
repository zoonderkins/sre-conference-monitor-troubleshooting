# sre-conference-monitor-troubleshooting
```
aws eks update-kubeconfig --name  monitor-troubleshooting --profile backyard
```

```
helm repo add fluent https://fluent.github.io/helm-charts
helm pull fluent/fluentd
helm install fluentd .

# https://www.elastic.co/guide/en/cloud-on-k8s/master/k8s-install-helm.html
helm install -n elastic-system --create-namespace eck-operator .
```

```
helm install eck-elasticsearch .
```
cd helm-template/log-generator
helm install log-generator .

```



# How to init the lab
```
AWS_PROFILE=backyard ./init.sh
```

# End the lab
```
AWS_PROFILE=backyard ./destroy.sh
```