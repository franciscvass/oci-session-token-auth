#!/bin/bash

while [[ "$#" -gt 0 ]]; do  
    case $1 in
        --region) region="$2"; shift ;;   
        --exp_time) exp_time="$2"; shift ;;
        --profile) profile="$2"; shift ;;
    	--githubrepo) githubrepo="$2"; shift ;;
    	--tf_action) tf_action="$2"; shift ;;
    	--tf_var_bucket) tf_var_bucket="$2"; shift ;;
    	--tf_var_compartment_id) tf_var_compartment_id="$2"; shift ;;
    	--tf_var_key) tf_var_key="$2"; shift ;;
    	--tf_var_namespace) tf_var_namespace="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

oci session authenticate --region $region --session-expiration-in-minutes $exp_time --profile-name $profile

echo "export VARS"

#export GITHUBREPO="franciscvass/deploy_vcn_in_oci"
#export TF_ACTION="apply"
#export TF_VAR_BUCKET="tfstate_bucket"
#export TF_VAR_COMPARTMENT_ID="ocid1.compartment.oc1..aaaaaaaars7ft6qwfjeft6c2yo35copu7plbgvjyzooqcgqqb2l2negsww4q"
#export TF_VAR_KEY="tfstate_4"
#export TF_VAR_NAMESPACE="idjuatm1d4mr"

export GITHUBREPO=$githubrepo
export TF_ACTION=$tf_action
export TF_VAR_BUCKET=$tf_var_bucket
export TF_VAR_COMPARTMENT_ID=$tf_var_compartment_id
export TF_VAR_KEY=$tf_var_key
export TF_VAR_NAMESPACE=$tf_var_namespace

env | grep TF_

echo "call get_token.py"
python3 get_token.py $profile
chmod 700 set_token.sh
echo "run set_token.sh"
. set_token.sh


echo "Set GH secrets"

gh secret set SES_TOKEN_PRV_KEY --repo "$GITHUBREPO" --body "$SES_TOKEN_PRV_KEY"
gh secret set SES_TOKEN --repo "$GITHUBREPO" --body "$SES_TOKEN"
gh secret set FINGERPRINT --repo "$GITHUBREPO" --body "$FINGERPRINT"
gh secret set TENANCY_OCID --repo "$GITHUBREPO" --body "$TENANCY_OCID"

echo "set GH VARS"

gh variable set TF_VAR_KEY --repo "$GITHUBREPO" --body "$TF_VAR_KEY"
gh variable set TF_VAR_BUCKET --repo "$GITHUBREPO" --body "$TF_VAR_BUCKET"
gh variable set TF_VAR_COMPARTMENT_ID --repo "$GITHUBREPO" --body "$TF_VAR_COMPARTMENT_ID"
gh variable set TF_VAR_NAMESPACE --repo "$GITHUBREPO" --body "$TF_VAR_NAMESPACE"
gh variable set TF_VAR_REGION --repo "$GITHUBREPO" --body "$TF_VAR_REGION"
gh variable set TF_ACTION --repo "$GITHUBREPO" --body "$TF_ACTION"

gh variable list --repo "$GITHUBREPO"
