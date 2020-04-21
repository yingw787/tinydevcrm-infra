.PHONY: create-iam

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
