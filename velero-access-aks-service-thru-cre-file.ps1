# 1. Define your Azure variables
$AZURE_SUBSCRIPTION_ID="074224e5-1185-47a9-958d-3c25c1df9ebc"
$AZURE_TENANT_ID="621daa10-ac93-4381-aeec-7d7491b91670"
$AZURE_CLIENT_ID="6c994d84-679c-48c1-98fa-c1013875b047"
$AZURE_CLIENT_SECRET="z8l8Q~NFhEHHeVUH0Ew.HguPPjykY.gciARddcw9"
$AZURE_RESOURCE_GROUP="RG-AKS-Enterprise-Backup"
$AZURE_CLOUD_NAME="AzurePublicCloud"

# 2. Create the file with ASCII encoding (required by Velero)
@"
AZURE_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID
AZURE_TENANT_ID=$AZURE_TENANT_ID
AZURE_CLIENT_ID=$AZURE_CLIENT_ID
AZURE_CLIENT_SECRET=$AZURE_CLIENT_SECRET
AZURE_RESOURCE_GROUP=$AZURE_RESOURCE_GROUP
AZURE_CLOUD_NAME=$AZURE_CLOUD_NAME
"@ | Out-File -FilePath credentials-velero -Encoding ascii

# 3. Create the missing Kubernetes secret
kubectl create secret generic cloud-credentials `
    --namespace velero `
    --from-file cloud=credentials-velero

# 4. Verify the secret was created
kubectl get secret cloud-credentials -n velero

#5.  Force Velero to Re-validate
#After creating the secret, restart the Velero pod to make it "see" the new credentials immediately:

kubectl rollout restart deployment velero -n velero
Start-Sleep -s 30
velero backup-location get
