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
                "subnet-018a2fe7a19f2911e"
            ],
            "securityGroups": [
                "sg-05c728d2c78443220"
            ],
            "assignPublicIp": "DISABLED"
        }
    }
}
EOF
