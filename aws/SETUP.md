# Setup

I don't feel comfortable with just self-documenting YAML templates, considering
`cfn-format` limitations. This document describes the setup process.

## `aws-iam`: IAM layer setup.

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
    tinydevcrm-user`. Finally, export `AWS_PROFILE` as `tinydevcrm-user`.
