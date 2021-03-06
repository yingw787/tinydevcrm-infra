# Setup

I don't feel comfortable with just self-documenting YAML templates, considering
`cfn-format` limitations in stripping YAML comments. So this document describes
the setup process for TinyDevCRM infrastructure.

Follow these steps one after another, and you should have working TinyDevCRM
infrastructure deployed on AWS.

## `aws-iam`: IAM layer setup

1.  Make sure to have `awscli` and GNU make `make` installed on your local
    compute instance. Also would be nice to have `cfn-format` installed as well.

    Make sure to have a set of root credentials or otherwise credentials
    installed on your local compute instance via `aws configure`, and that
    `$AWS_PROFILE` is exported to the current shell environment.

2.  Copy over `aws-iam.example.json` as `aws-iam.json`, and configure all
    parameter values. The IAM user password must pass the default AWS password
    policy. Note that the password can be changed after IAM user creation.

2.  Run `make create-iam` in order to stand up IAM resources.

3.  In the AWS console, take your root account ID, your newly created IAM user
    `tinydevcrm-user`, and your password `MyIAMUserPassword`, and log into a
    session of AWS console.

4.  Open `Services | IAM`, and in `Users | tinydecrm-user | Security
    Credentials`, add an MFA device in `Assigned MFA Device`. Register an MFA
    device (I'm using Authy on Ubuntu), then log out and log back in as the same
    user. It should prompt you for an MFA code. Enter the code from your
    authenticator app and login.

5.  On the right-hand side of the top navbar, click on "Switch Role", just above
    "Sign Out. Switch role to role 'tinydevcrm-admin', using account ID
    'RootAWSAccountID' and role 'tinydevcrm-admin'.

    You should now have access to all AWS resources after switching to this
    role.

6.  Create a set of access credentials for this user. In `Services | IAM`, and
    in `Users | tinydevcrm-user | Security Credentials`, click on "Create Access
    Key". Then, create a new IAM user using command `aws configure --profile
    tinydevcrm-user`. This properly configures `~/.aws/credentials`.

    At this point, you need to configure `~/.aws/config`. Take the section:

    ```text
    [profile tinydevcrm-user]
    region = us-east-1
    output = json
    ```

    And turn it into this to properly configure MFA via CLI:

    ```text
    [profile tinydevcrm-user]
    source_profile = tinydevcrm-user
    role_arn = arn:aws:iam::${RootAWSAccountID}:role/tinydevcrm-admin
    role_session_name=tinydevcrm-user
    mfa_serial = arn:aws:iam::${RootAWSAccountID}:mfa/tinydevcrm-user
    region = us-east-1
    output = json
    ```

    Finally, export `AWS_PROFILE` as `tinydevcrm-user` to avoid piping
    `--profile` into `aws` commands:

    ```bash
    export AWS_PROFILE=tinydevcrm-user
    ```

    You should now be able to lift into admin role via MFA on the CLI. Check
    using command:

    ```bash
    aws s3 ls
    ```

    Or similar. It should prompt for MFA, then give the appropriate response
    without erroring out.

## `aws-secrets`: Key and secrets setup

1.  Create an EC2 keypair.

    Using the AWS CLI, run the following command, from [this set of
    instructions](https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-keypairs.html):

    ```bash
    $ aws ec2 create-key-pair --key-name tinydevcrm-ec2-keypair --query 'KeyMaterial' --output text > tinydevcrm-ec2-keypair.pem
    ```

    Then change ownership of the .pem file so that owner only has read
    permissions:

    ```bash
    $ chmod 400 tinydevcrm-ec2-keypair.pem
    ```

    And move it into `~/.ssh`:

    ```bash
    $ mv tinydevcrm-ec2-keypair.pem ~/.ssh
    ```

2.  Deploy keys and secrets using `aws-secrets.yaml`:

    ```bash
    make create-secrets
    ```

## `aws-ec2-networking`: VPC and public subnet setup

1.  Deploy the VPC and subnets using `aws-ec2-networking.yaml`:

    ```bash
    make create-ec2-networking
    ```

    That's it!

## `aws-ec2-compute`: EC2 compute layer

1.  Copy over the VPC ID and the public subnet IDs generated in the
    CloudFormation stack defined by `aws-ec2-networking.yaml`. This is necessary
    because only a strict string can be passed as default parameters for
    CloudFormation templates,

    TODO: Replace with `!ImportValue` or StackSets.

2.  Create the compute layer using `aws-ec2-compute.yaml`:

    ```bash
    make create-ec2-compute
    ```
