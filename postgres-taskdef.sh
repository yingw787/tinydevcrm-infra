cat > postgres-taskdef.json << EOF
{
    "containerDefinitions": [
        {
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "${CWLogGroupName}",
                    "awslogs-region": "${AWSRegion}",,
                    "awslogs-stream-prefix": "ecs"
                }
            },
            "portMappings": [
                {
                    "containerPort": 5432,
                    "protocol": "tcp"
                }
            ],
            "environment": [
                {
                    "name": "POSTGRES_PASSWORD",
                    "value": "my-secret-pw"
                }
            ],
            "mountPoints": [
                {
                    "containerPath": "/var/lib/postgresql/data",
                    "sourceVolume": "rexray-vol"
                }
            ],
            "image": "postgres",
            "essential": true,
            "name": "postgres"
        }
    ],
    "placementConstraints": [
        {
            "type": "memberOf",
            "expression": "attribute:ecs.availability-zone==${AvailabilityZone}"
        }
    ],
    "memory": "512",
    "family": "postgres",
    "networkMode": "awsvpc",
    "requiresCompatibilities": [
        "EC2"
    ],
    "cpu": "512",
    "volumes": [
        {
            "name": "rexray-vol",
            "dockerVolumeConfiguration": {
                "autoprovision": true,
                "scope": "shared",
                "driver": "rexray/ebs",
                "driverOpts": {
                    "volumetype": "gp2",
                    "size": "5"
                }
            }
        }
    ]
}
EOF
