# Mount ConfigMaps

# Config Maps
* Create a config-map and mount to a pod 


# Create a namespace
```
kubectl create namespace [MY-NAMESPACE]
```

## Create Config Map
```
kubectl create configmap my-config  \
  --from-literal=PageTitle=MyNewTitle  \
  --namespace=[MY-NAMESPACE]
```

## Check config maps
```
kubectl get configmaps my-config  \
  --namespace=[MY-NAMESPACE] -o yaml
```

## Create pod 

Either by using this content 
```
---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: aks-helloworld
  name: aks-helloworld
spec:
  containers:
  - image: mcr.microsoft.com/azuredocs/aks-helloworld:v1
    name: aks-helloworld
    ports:
    - containerPort: 80
    env:
     - name: TITLE
       value: "Welcome to Azure Kubernetes Service (AKS)"
    resources: {}
    volumeMounts:
      - name: config-volume
        mountPath: /etc/config
  volumes:
    - name: config-volume
      configMap:
        name: my-config
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

```

or 

```
kubectl apply -f https://raw.githubusercontent.com/enginyoyen/intro-to-kubernetes-workshop/main/definitions/mount-configmaps.yaml --namespace=[MY-NAMESPACE]
```

## Check the pod content 

```
kubectl exec -it aks-helloworld --namespace=[MY-NAMESPACE] -- /bin/bash
```


## Clean Up
```
kubectl delete pod aks-helloworld --namespace=[MY-NAMESPACE]
kubectl delete configmap my-config  \
  --namespace=[MY-NAMESPACE]
```
or


```
kubectl delete -f https://raw.githubusercontent.com/enginyoyen/intro-to-kubernetes-workshop/main/definitions/mount-configmaps.yaml \
  --namespace=[MY-NAMESPACE]
```