# `tinydevcrm-infra`: infrastructure definition for TinyDevCRM

## Quick Start

1.  Install your AWS profile, and make sure env variable `AWS_PROFILE` is loaded
    properly:

    ```bash
    export AWS_PROFILE=$SOME_AWS_PROFILE
    ```

2.  Create the CloudFormation stack:

    ```bash
    make create-stack
    ```

3.  Export the CloudFormation env variables:

    ```bash
    ./get-outputs.sh rexray-demo us-east-1 && source <(./get-outputs.sh rexray-demo us-east-1)
    ```

4.  Create the PostgreSQL ECS task definition:

    ```bash
    ./postgres-taskdef.sh
    ```

5.  Provision an EBS volume:

    ```bash
    aws ec2 create-volume --size 1 --volume-type gp2 --availability-zone $AvailabilityZone --tag-specifications 'ResourceType=volume,Tags=[{Key=Name,Value=rexray-vol}]'
    ```

6.  Register the task definition:

    ```bash
    export TaskDefinitionArn=$(aws ecs register-task-definition --cli-input-json 'file://postgres-taskdef.json' | jq -r .taskDefinition.taskDefinitionArn)
    ```

7.  Create a service definition:

    ```bash
    ./postgres-svcdef.sh
    ```

8.  Register the service definition:

    ```bash
    export SvcDefinitionArn=$(aws ecs create-service --cli-input-json file://postgres-svcdef.json | jq -r .service.serviceArn)
    ```

9.  Install `pgadmin4`, and open a process. Right click on the "Servers"
    top-level tree item, and click on "Create Server". For parameters, enter:

    - **General/Name**: `rexray-demo`
    - **Connection/hostname**: $NLBFullyQualifiedName
    - **Connection/Username**: postgres
    - **Connection/Password**: Value of `POSTGRES_PASSWORD` in
      `postgres-taskdef.json`.

    You should see a server `rexray-demo` with expandable database `postgres` up
    and running.

10. Manually create a database `rexraydb`, and using the `pgadmin` Query Tool
    and a connection to `rexraydb/postgres@rexray-demo`, and run the following
    command:

    ```sql
    CREATE TABLE pets (name VARCHAR(20), breed VARCHAR(20));
    INSERT INTO pets VALUES ('Fluffy', 'Poodle');
    SELECT * FROM pets;
    ```

    Check that the data exists in the "Data Output" panel.

11. Create `drain-instance.sh`:

    ```bash
    ./create-drain-instance.sh
    ```

12. Record the task definition ID in the ECS console for the PostgreSQL
    instance.

    For example, mine is currently `a7944fda-8dfd-4ed5-ad6b-9ecb49495cb3`.

13. Drain the ECS instance.

    ```bash
    ./drain-instance.sh
    ```

    Because there's an underlying service definition registered with the ECS
    cluster, the task definition will automatically restart.

    You may need to cut and paste parts of `drain-instance.sh` into the console
    in order to get the script to work properly.

    Double check that the task definition is different. For example, mine is
    currently `a0043f26-fd2d-4656-bd15-528c47b96132`.

14. Reconnect `pgadmin4` to server `rexray-demo` and database `rexraydb`, and
    verify that table `pets` is still there. For me, it is.

    This concludes functionality testing.

15. Delete the resources:

    ```bash
    # Delete ECS task definition and service definition
    aws ecs update-service --cluster $ECSClusterName --service $SvcDefinitionArn \ --desired-count 0
    aws ecs delete-service --cluster $ECSClusterName --service $SvcDefinitionArn

    # Delete the EBS volume; may require deleting the task definition if draining takes too long.
    rexrayVolumeID=$(aws ec2 describe-volumes --filter Name="tag:Name",Values=rexray-vol --query "Volumes[].VolumeId" --output text)
    aws ec2 delete-volume --volume-id $rexrayVolumeID

    # Delete the CloudFormation stack.
    aws cloudformation delete-stack --stack rexray-demo
    ```

    This concludes this exercise.

## Overview

This repository defines the infrastructure I'm using for TinyDevCRM deployed on
Amazon Web Services.

I believe investing in great operational infrastructure will help me better
monetize my variable costs (e.g. software development man-hours) into possible
revenue generation schemes, ship high quality product with greater confidence,
and better decide product direction, among other benefits.

## System Requirements

-   [**`awscli`**](https://github.com/aws/aws-cli) v1.18 or higher. I am using:

    ```bash
    $ aws --version
    aws-cli/1.18.35 Python/3.7.7 Linux/5.3.0-46-generic botocore/1.15.35
    ```

-   [**`docker`**](https://www.docker.com/) v19 or higher. I am using:

    ```bash
    $ docker --version
    Docker version 19.03.6, build 369ce74a3c
    ```

-   [**`docker-compose`**](https://github.com/docker/compose) v1.23 or higher. I
    am using:

    ```bash
    $ docker-compose --version
    docker-compose version 1.23.2, build 1110ad01
    ```

## Checklist

-   [:heavy_check_mark:] Reproduce prior week's success with PostgreSQL
    installation on ECS, EC2 + EBS, and CloudFormation

-   [:question:] Create a CloudFormation IAM + Key Management + Secrets
    Management definition to see whether IAM user setup from Chapter 3 of
    *Docker on AWS* can be automated, and secrets management for app secret
    keys, app superuser, and database passwords can be pre-created and hooked in
    beforehand

-   [:question:] Copy over the `docker-compose` setup I used for
    `tinydevcrm-api`, and load up Django + `gunicorn` + NGINX + PostgreSQL +
    static files
-   [:question:] Create CloudFormation templates for ECR repositories, and get
    the PostgreSQL + `pg_cron` image pushed up to ECR as part of that effort
-   [:question:] Set up a CloudFormation EBS volume to scale out the data layer
-   [:question:] Set up a CloudFormation EFS volume for static files to be
    served
-   [:question:] Set up a CloudFormation EC2 definition for the compute layer,
    with NAT traversal, autoscaling groups, and load balancing
-   [:question:] Set up a CloudFormation ECS definition for the container
    orchestration layer, with service / task / cluster definitions, and
    auto-pulling from ECR
-   [:question:] Set up CI/CD pipelines for test and production deploys with AWS
    CodeBuild and AWS CodePipeline
-   [:question:] Template the template standup process with dynamically loaded
    environment variables and Makefiles
-   [:question:] Document each step (esp. CloudFormation resources and quirks
    encountered) in the YAML templates and the README
