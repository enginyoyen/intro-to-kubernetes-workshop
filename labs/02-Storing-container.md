# 02 - Storing Container

## Adding Github actions
1. Go to Actions
2. Select "Set up a workflow yourself"
3. Edit Github Action  as described below
4. Paste to the editor
5. Change image name (lower-case)
6. Commit
7. Go to settings
8. Go to secrets
9. New repository secret
10. Add following secrets:

```
AZURE_CREDENTIALS : See below how to create credentials, use whole JSON
REGISTRY_USERNAME : Use clientId from the credentials that was created
REGISTRY_PASSWORD : Use clientSecret from the credentials that was created
REPOSITORY        : Repository URL(e.g: buildstoragexn4.azurecr.io)
```
11. Go to Actions > Trigger new build


## Creating Credentials
To use any credentials like Azure Service Principal,add them as secrets in the GitHub repository and then use them in the workflow.

Follow the steps to configure the secret:

* Define a new secret under your repository settings, Add secret menu
* Store the output of the below az cli command as the value of secret variable 'AZURE_CREDENTIALS'

```
az ad sp create-for-rbac --name "engyy-acr-storagex2" --role contributor --scopes /subscriptions/{subscription-id}/resourceGroups/{resource-group}

# The command should output a JSON object similar to this:

{
    "clientId": "<GUID>",
    "clientSecret": "<GUID>",
    "subscriptionId": "<GUID>",
    "tenantId": "<GUID>",
    (...)
}
```


## Github Actions File
````

on: [push]
name: Build and store container

env:
  IMAGE_NAME: youralias
  
jobs:
    build-and-deploy:
        runs-on: ubuntu-latest
        steps:
        # checkout the repo
        - name: 'Checkout GitHub Action'
          uses: actions/checkout@main
          
        - name: 'Login via Azure CLI'
          uses: azure/login@v1
          with:
            creds: ${{ secrets.AZURE_CREDENTIALS }}
        
        - name: 'Build and push image'
          uses: azure/docker-login@v1
          with:
            login-server: ${{ secrets.REPOSITORY }}
            username: ${{ secrets.REGISTRY_USERNAME }}
            password: ${{ secrets.REGISTRY_PASSWORD }}
        - run: |
            docker build . -t ${{ secrets.REPOSITORY }}/${{ env.IMAGE_NAME}}:latest  -f ./Dockerfile
            docker push ${{ secrets.REPOSITORY }}/${{ env.IMAGE_NAME}}:latest

````