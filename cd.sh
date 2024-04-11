aws eks update-kubeconfig --name monitor-troubleshooting --profile backyard
cd helm-template/busybox
# helm upgrade --install redis bitnami/redis -f values.yaml
helm install log-generator .
