#!/bin/bash

if [[ $# -eq 0 ]]; then
    echo 'No arguments passed, expecting 9' >&2
    exit 1
fi

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

echo "*** SES_TOKEN_PRV_KEY ***" > info_for_github.txt
echo $SES_TOKEN_PRV_KEY  >> info_for_github.txt
echo "*** SES_TOKEN ***"  >> info_for_github.txt
echo $SES_TOKEN          >> info_for_github.txt
echo "*** FINGERPRINT ***" >> info_for_github.txt
echo $FINGERPRINT >> info_for_github.txt
echo "*** TENANCY_OCID ***" >> info_for_github.txt
echo $TENANCY_OCID >> info_for_github.txt
echo "*** TF_VAR_REGION ***" >> info_for_github.txt
echo $TF_VAR_REGION >> info_for_github.txt
echo "*** GITHUBREPO ***" >> info_for_github.txt
echo $GITHUBREPO >> info_for_github.txt
echo "*** TF_ACTION ***" >> info_for_github.txt
echo $TF_ACTION >> info_for_github.txt
echo "*** TF_VAR_BUCKET ***" >> info_for_github.txt
echo $TF_VAR_BUCKET >> info_for_github.txt
echo "*** TF_VAR_COMPARTMENT_ID ***" >> info_for_github.txt
echo $TF_VAR_COMPARTMENT_ID >> info_for_github.txt
echo "*** TF_VAR_KEY ***" >> info_for_github.txt
echo $TF_VAR_KEY >> info_for_github.txt
echo "*** TF_VAR_NAMESPACE ***">> info_for_github.txt
echo $TF_VAR_NAMESPACE >> info_for_github.txt


