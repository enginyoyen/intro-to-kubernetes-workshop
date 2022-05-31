# Persistent Volume Claims
Create a persistent volume claim and attach to a pod.

PS: This lab assumes you have a AKS with CSI Driver.

# Create a namespace
```
kubectl create namespace [MY-NAMESPACE]
```


# Create Persistent Volume Claim

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/azuredisk-csi-driver/master/deploy/example/pvc-azuredisk-csi.yaml --namespace=[MY-NAMESPACE]
```



```
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-azuredisk
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
  storageClassName: managed-csi
```


# Create a pod that declares persistent volume claim


```
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/azuredisk-csi-driver/master/deploy/example/nginx-pod-azuredisk.yaml --namespace=[MY-NAMESPACE]
```

```
---
kind: Pod
apiVersion: v1
metadata:
  name: nginx-azuredisk
spec:
  nodeSelector:
    kubernetes.io/os: linux
  containers:
    - image: mcr.microsoft.com/oss/nginx/nginx:1.17.3-alpine
      name: nginx-azuredisk
      command:
        - "/bin/sh"
        - "-c"
        - while true; do echo $(date) >> /mnt/azuredisk/outfile; sleep 1; done
      volumeMounts:
        - name: azuredisk01
          mountPath: "/mnt/azuredisk"
  volumes:
    - name: azuredisk01
      persistentVolumeClaim:
        claimName: pvc-azuredisk
```

## Check the pod content and add some data
```
kubectl exec -it nginx-azuredisk --namespace=[MY-NAMESPACE] -- /bin/sh  -- /bin/bash
```


# Delete the pod
```
kubectl delete pod  nginx-azuredisk  --namespace=[MY-NAMESPACE] --force
```

or

```
kubectl delete -f https://raw.githubusercontent.com/kubernetes-sigs/azuredisk-csi-driver/master/deploy/example/nginx-pod-azuredisk.yaml --namespace=[MY-NAMESPACE] --force
```


## Check the PVC
```
kubectl get pvc --namespace=eng
```



## Clean Up
```
kubectl delete pod aks-helloworld --namespace=[MY-NAMESPACE] --force
kubectl delete secretproviderclass.secrets-store.csi.x-k8s.io/azure-kvname-system-msi --namespace=[MY-NAMESPACE]
```

or


```
kubectl delete -f https://raw.githubusercontent.com/enginyoyen/intro-to-kubernetes-workshop/main/definitions/pod-with-keyvault-csi-driver-sync.yaml \
  --namespace=[MY-NAMESPACE]

kubectl delete -f https://raw.githubusercontent.com/enginyoyen/intro-to-kubernetes-workshop/main/definitions/secret-provider-class.yml --namespace=[MY-NAMESPACE]
```


# Check the Secrets again
Secrets should also be removed, as the pods that are using the secret are gone.
```
kubectl get secrets --namespace=[MY-NAMESPACE]
```
