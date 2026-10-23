# set the subscription
export ARM_SUBSCRIPTION_ID="<Subscription ID>"

# set the application / environment
export TF_VAR_application_name="vpn"
export TF_VAR_environment_name="dev"

# set the backend
export BACKEND_RESOURCE_GROUP="rg-tfstate-dev"
export BACKEND_STORAGE_ACCOUNT="<storage account name>"
export BACKEND_STORAGE_CONTAINER="maincont"
export BACKEND_KEY=$TF_VAR_application_name-$TF_VAR_environment_name

 # run terraform
terraform init \
    -backend-config="resource_group_name=${BACKEND_RESOURCE_GROUP}" \
    -backend-config="storage_account_name=${BACKEND_STORAGE_ACCOUNT}" \
    -backend-config="container_name=${BACKEND_STORAGE_CONTAINER}" \
    -backend-config="key=${BACKEND_KEY}"           

terraform $* -var-file ../env/$TF_VAR_environment_name.tfvars

# clean up the local environment
rm -rf .terraform
