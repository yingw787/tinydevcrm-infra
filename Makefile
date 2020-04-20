.PHONY: create-stack

export APP_VERSION ?= $(shell git rev-parse --short HEAD)

create-stack:
	aws cloudformation create-stack --stack-name rexray-demo --capabilities CAPABILITY_NAMED_IAM --template-body file://rexray-demo-psql.json --parameters ParameterKey=KeyName,ParameterKey=admin
