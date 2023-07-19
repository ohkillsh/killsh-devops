VAULT_NAME="kv-aks-app"
#create an example secret
SECRET_NAME="test"
SECRET_VAlUE="Congratulations! You have got a secret via External-Secret-Store. "
az keyvault secret set --name $SECRET_NAME --vault-name $VAULT_NAME --value "$SECRET_VAlUE"