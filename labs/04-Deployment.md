# Run a Pod

# Create a namespace
```
kubectl create namespace [MY-NAMESPACE]
```


# Create a deployment - Dry run
```
kubectl create deployment myservice  \
  --image=mcr.microsoft.com/azuredocs/aks-helloworld:v1
  --port=80 \
  --namespace=[MY-NAMESPACE]  \
  --replicas=3
``` 

# Get deployments
```
kubectl get deployments --namespace=[MY-NAMESPACE]
```

# Check pods
```
kubectl get pods --namespace=[MY-NAMESPACE] -o wide -w
```

# Delete a pod
Delete a pod from deployment and watch it, a new instance should start immediately

```
kubectl delete  pod [name] --namespace=[MY-NAMESPACE]
```

## Temporary container to test it
```
kubectl run temp-pod   \
  --image=busybox   \
  --namespace=[MY-NAMESPACE]  \
  --rm  --restart=Never   \
  -it -- /bin/sh
```

```
wget -O - IP:80 > /dev/null
```
