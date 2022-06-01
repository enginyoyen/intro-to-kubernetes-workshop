# Config Maps
* Create a config-map and assign as an environment variable to a container

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


## Edit pod and change the load the environment variable from config-map


Replace env section:
```
    spec:
      containers:
      - image: mcr.microsoft.com/azuredocs/aks-helloworld:v1
        name: aks-helloworld
        ports:
        - containerPort: 80
        env:
        - name: TITLE
          value: "Welcome to Azure Kubernetes Service (AKS)"
```

with this:

```
    spec:
      containers:
      - image: mcr.microsoft.com/azuredocs/aks-helloworld:v1
        name: aks-helloworld
        ports:
        - containerPort: 80
        env:
        - name: TITLE
          valueFrom:
            configMapKeyRef:
              name: my-config
              key: PageTitle
```

or create the pod from definition file

```
kubectl apply -f https://raw.githubusercontent.com/enginyoyen/intro-to-kubernetes-workshop/main/definitions/pod-with-config-maps.yaml \
  --namespace=[MY-NAMESPACE]
``` 


## Get the IP address of an Pod
```
kubectl get pods --namespace=[MY-NAMESPACE] -o wide
```

## Temporary container to test it
```
kubectl run temp-pod   \
  --image=busybox   \
  --namespace=[MY-NAMESPACE]  \
  --rm  --restart=Never   \
  -it -- /bin/sh
```

Check the title:
```
wget -O - IP:80
```

## Clean Up
```
kubectl delete pod aks-helloworld --namespace=[MY-NAMESPACE]
kubectl delete configmap my-config  \
  --namespace=[MY-NAMESPACE]
```
or


```
kubectl delete -f https://raw.githubusercontent.com/enginyoyen/intro-to-kubernetes-workshop/main/definitions/pod-with-config-maps.yaml \
  --namespace=[MY-NAMESPACE]
```