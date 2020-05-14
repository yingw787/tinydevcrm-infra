.PHONY: create-stack

export AWS_PROFILE=tinydevcrm-user

create-stack:
	aws cloudformation create-stack --stack-name rexray-demo-efs --capabilities CAPABILITY_NAMED_IAM --template-body file://rexray-demo-efs.yaml --parameters 'ParameterKey=KeyName,ParameterValue=admin'

get-outputs:
	bash create-get-outputs.sh
	bash get-outputs.sh rexray-demo-efs us-east-1
	# source <(./get-outputs.sh rexray-demo-efs us-east-1)
