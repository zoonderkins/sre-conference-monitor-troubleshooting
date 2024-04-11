# How to init the lab
1. rewrite the variable tag: Owner
2. Run script
```
AWS_PROFILE=<profile> ./init.sh
```

# End the lab
```
AWS_PROFILE=<profile> ./destroy.sh
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

# set config
```
aws eks update-kubeconfig --name  monitor-troubleshooting --profile <profile>
```


