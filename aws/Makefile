.PHONY: create-iam

# This operation implies you already have a set of root account credentials on
# your local compute instance.
create-iam:
	aws cloudformation create-stack --stack-name tinydevcrm-iam --template-body file://aws-iam.yaml --parameters file://aws-iam.json --capabilities CAPABILITY_NAMED_IAM

deploy-iam:
	# Don't apply parameter overrides via '--parameter-overrides', parameters
	# should be passed during stack creation
	aws cloudformation deploy --stack-name tinydevcrm-iam --template-file file://aws-iam.yaml --capabilities CAPABILITY_NAMED_IAM
