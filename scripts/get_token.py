import oci
import sys

config = oci.config.from_file(profile_name=sys.argv[1])
with open ('set_token.sh',"w") as f:
	f.write(f"export SES_TOKEN_PRV_KEY=`base64 -i {config['key_file']}`\n")
	f.write(f"export SES_TOKEN=`base64 -i {config['security_token_file']}`\n")
	f.write(f"export FINGERPRINT=\"{config['fingerprint']}\"\n")
	f.write(f"export TENANCY_OCID=\"{config['tenancy']}\"\n")
	f.write(f"export TF_VAR_REGION=\"{config['region']}\"\n")
