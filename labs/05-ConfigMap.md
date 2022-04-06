# Config Maps

* Create a config-map and assign as an environment variable

## Create a deployment 
This creates a deployment and deployment definition already has environment variable assigned
```
kubectl apply -f https://github.com/enginyoyen/intro-to-kubernetes-workshop/blob/main/definitions/simple-deployment.yaml \
  --namespace=[MY-NAMESPACE]
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


## Edit deployment and change the load the environment variable from config-map

```
kubectl edit deployments --namespace=[MY-NAMESPACE]
```

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

