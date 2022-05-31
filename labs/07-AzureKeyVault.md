# Using Azure Key Vault with AKS
Create a secret in Azure Key Vault and expose via CSI Driver. 

PS: This lab assumes you have a AKS with Secrets Store CSI Driver and KeyVault is already set up, if not see the: https://docs.microsoft.com/en-us/azure/aks/csi-secrets-store-driver

# Create a namespace
```
kubectl create namespace [MY-NAMESPACE]
```


# Create SecretProviderClass

```
cat <<EOF | kubectl apply -f -
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: azure-kvname
  namespace: "${MY-NAMESPACE}"
spec:
  provider: azure
  parameters:
    usePodIdentity: "false"
    useVMManagedIdentity: "true"
    userAssignedIdentityID: "{$CLIENT_ID}"
    keyvaultName: "${KEYVAULT_NAME}"
    objects: |
      array:
        - |
          objectName: mysecret              
          objectType: secret
          objectVersion: ""
    tenantId: "${TENANT_ID}"
EOF
```

or use the following definition(PS: Functional only for the test environment)


```
kubectl apply -f https://raw.githubusercontent.com/enginyoyen/intro-to-kubernetes-workshop/main/definitions/secret-provider-class.yml --namespace=[MY-NAMESPACE]
```



# Create a pod uses secret store csi

```
kubectl apply -f https://raw.githubusercontent.com/enginyoyen/intro-to-kubernetes-workshop/main/definitions/pod-with-keyvault-csi-driver-sync.yaml --namespace=[MY-NAMESPACE]
```


## Check the pod content 

```
kubectl exec -it aks-helloworld --namespace=[MY-NAMESPACE] -- /bin/bash
```


# Check the Secrets

```
kubectl get secrets --namespace=[MY-NAMESPACE]
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
