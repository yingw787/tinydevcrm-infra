.PHONY: create-stack

export AWS_PROFILE=tinydevcrm-user

create-stack:
	aws cloudformation create-stack --stack-name rexray-demo-efs --capabilities CAPABILITY_NAMED_IAM --template-body file://rexray-demo-efs.yaml --parameters 'ParameterKey=KeyName,ParameterValue=admin'

get-outputs:
	create-get-outputs.sh
	./get-outputs.sh && source <(./get-outputs.sh)
