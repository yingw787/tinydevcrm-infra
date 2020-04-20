# `tinydevcrm-infra`: infrastructure definition for TinyDevCRM

## Quick Start

TODO

## Overview

This repository defines the infrastructure I'm using for TinyDevCRM deployed on
Amazon Web Services.

I believe investing in great operational infrastructure will help me better
monetize my variable costs (e.g. software development man-hours) into possible
revenue generation schemes, ship high quality product with greater confidence,
and better decide product direction, among other benefits.

## Checklist

-   [:question_mark:] Reproduce prior week's success with PostgreSQL
    installation on ECS, EC2 + EBS, and CloudFormation
-   [:question_mark:] Copy over the `docker-compose` setup I used for
    `tinydevcrm-api`, and load up Django + `gunicorn` + NGINX + PostgreSQL +
    static files
-   [:question_mark:] Create a CloudFormation IAM + Secrets Management
    definition to see whether IAM user setup from Chapter 3 of *Docker on AWS*
    can be automated, and secrets management for app secret keys, app superuser,
    and database passwords can be pre-created and hooked in beforehand
-   [:question_mark:] Create CloudFormation templates for ECR repositories, and
    get the PostgreSQL + `pg_cron` image pushed up to ECR as part of that effort
-   [:question_mark:] Set up a CloudFormation EBS volume to scale out the data
    layer
-   [:question_mark:] Set up a CloudFormation EFS volume for static files to be
    served
-   [:question_mark:] Set up a CloudFormation EC2 definition for the compute
    layer, with NAT traversal, autoscaling groups, and load balancing
-   [:question_mark:] Set up a CloudFormation ECS definition for the container
    orchestration layer, with service / task / cluster definitions, and
    auto-pulling from ECR
-   [:question_mark:] Set up CI/CD pipelines for test and production deploys
    with AWS CodeBuild and AWS CodePipeline
-   [:question_mark:] Template the template standup process with dynamically
    loaded environment variables and Makefiles
-   [:question_mark:] Document each step (esp. CloudFormation resources and
    quirks encountered) in the YAML templates and the README
