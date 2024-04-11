# How to init the lab
```
AWS_PROFILE=backyard ./init.sh
```

# End the lab
```
AWS_PROFILE=backyard ./destroy.sh
```

# elasticSearch rebuild error
```
 Error: context deadline exceeded
│ 
│   with helm_release.elasticsearch
```
```
./resource-management/remove.sh
```


# sre-conference-monitor-troubleshooting
```
aws eks update-kubeconfig --name  monitor-troubleshooting --profile backyard
```


