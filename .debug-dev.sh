export ARM_SUBSCRIPTION_ID="281a2917-86c2-45c9-983d-1c08c7c43bab"

export TF_VAR_application_name="vpn"
export TF_VAR_environment_name="dev"

export BACKEND_RESOURCE_GROUP="rg-tfstate-dev"
export BACKEND_STORAGE_ACCOUNT="sttfstatedev59i"
export BACKEND_STORAGE_CONTAINER="maincont"
export BACKEND_KEY=$TF_VAR_application_name-$TF_VAR_environment_name
  
terraform init \
    -backend-config="resource_group_name=${BACKEND_RESOURCE_GROUP}" \
    -backend-config="storage_account_name=${BACKEND_STORAGE_ACCOUNT}" \
    -backend-config="container_name=${BACKEND_STORAGE_CONTAINER}" \
    -backend-config="key=${BACKEND_KEY}"           

terraform $*

rm -rf .terraform
