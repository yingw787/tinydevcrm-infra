.PHONY: create-iam deploy-iam delete-iam create-secrets create-ec2-networking

# This operation implies you already have a set of root account credentials on
# your local compute instance, or a set of credentials with administrator
# access. If you don't, download the credentials from AWS and save using 'aws
# configure'. Then, be sure to export AWS_PROFILE env variable so that
# '--profile' doesn't need to be passed.
#
# NOTE: Copy over file://aws-iam.example.json to file://aws-iam.json and replace
# parameters in order for this command to work properly.
create-iam:
	aws cloudformation create-stack --stack-name tinydevcrm-iam --template-body file://aws-iam.yaml --parameters file://aws-iam.json --capabilities CAPABILITY_NAMED_IAM

deploy-iam:
	# Don't apply parameter overrides via '--parameter-overrides', parameters
	# should be passed during stack creation
	aws cloudformation deploy --stack-name tinydevcrm-iam --template-file aws-iam.yaml --capabilities CAPABILITY_NAMED_IAM

delete-iam:
	aws cloudformation delete-stack --stack-name tinydevcrm-iam

create-secrets:
	aws cloudformation create-stack --stack-name tinydevcrm-secrets --template-body file://aws-secrets.yaml --capabilities CAPABILITY_NAMED_IAM

deploy-secrets:
	aws cloudformation deploy --stack-name tinydevcrm-secrets --template-file aws-secrets.yaml --capabilities CAPABILITY_NAMED_IAM

delete-secrets:
	aws cloudformation delete-stack --stack-name tinydevcrm-secrets

create-ec2-networking:
	aws cloudformation create-stack --stack-name tinydevcrm-ec2-networking --template-body file://aws-ec2-networking.yaml --capabilities CAPABILITY_NAMED_IAM

deploy-ec2-networking:
	aws cloudformation deploy --stack-name tinydevcrm-ec2-networking --template-file aws-ec2-networking.yaml --capabilities CAPABILITY_NAMED_IAM

delete-ec2-networking:
	aws cloudformation delete-stack --stack-name tinydevcrm-ec2-networking

create-ec2-compute:
	aws cloudformation create-stack --stack-name tinydevcrm-ec2-compute --template-body file://aws-ec2-compute.yaml --parameters file://aws-ec2-compute.json --capabilities CAPABILITY_NAMED_IAM

deploy-ec2-compute:
	aws cloudformation deploy --stack-name tinydevcrm-ec2-compute --template-file aws-ec2-compute.yaml --capabilities CAPABILITY_NAMED_IAM

delete-ec2-compute:
	aws cloudformation delete-stack --stack-name tinydevcrm-ec2-compute
