# Pods

## Listing Pods
```
kubectl get pods
```

## Create a namespace
Create a namespace with the specified name.
```
kubectl create namespace [MY-NAMESPACE]
```


# Creating Pod
```
kubectl run mypod  \
  --image=mcr.microsoft.com/azuredocs/aks-helloworld:v1  \
  --port=80  \
  --restart=Never   \
  --namespace=[MY-NAMESPACE]
``` 

## Watch for status

```
kubectl get pods --namespace=[MY-NAMESPACE] --watch
```

## Check pods

```
kubectl get pods --namespace=[MY-NAMESPACE] -o wide
```

## Print a detailed description

```
kubectl describe pods [POD-NAME] --namespace=[MY-NAMESPACE] 
```

## Temporary container to test it
Create a new temporary container to test it
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
