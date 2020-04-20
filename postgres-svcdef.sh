cat > postgres-svcdef.json << EOF
{
    "cluster": "${ECSClusterName}",
    "serviceName": "postgres-svc",
    "taskDefinition": "${TaskDefinitionArn}",
    "loadBalancers": [
        {
            "targetGroupArn": "${MySQLTargetGroupArn}",
            "containerName": "postgres",
            "containerPort": 5432
        }
    ],
    "desiredCount": 1,
    "launchType": "EC2",
    "healthCheckGracePeriodSeconds": 60,
    "deploymentConfiguration": {
        "maximumPercent": 100,
        "minimumHealthyPercent": 0
    },
    "networkConfiguration": {
        "awsvpcConfiguration": {
            "subnets": [
                "${SubnetId}"
            ],
            "securityGroups": [
                "${SecurityGroupId}"
            ],
            "assignPublicIp": "DISABLED"
        }
    }
}
EOF
