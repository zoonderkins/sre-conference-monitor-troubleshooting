1. Logs 沒有出現在 Kibana
2. checkpoint - Logs 出現在 Kibana，且只要 logs 有含 404 資訊


## kibana
```
kubectl -n kube-system port-forward <kibana pod name> 8080:5601
```

open http://localhost:8080/