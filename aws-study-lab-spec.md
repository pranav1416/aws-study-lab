Project Setup Spec: AWS Study Lab

Goal

Create a public GitHub repository named aws-study-lab for AWS Certified Solutions Architect – Associate preparation.

The repository should provide a local, sandboxed development environment that replaces the Gitpod setup used in the freeCodeCamp AWS course. The project should use VS Code Dev Containers and Docker so that AWS CLI tooling runs inside an isolated Linux container instead of directly on the host machine.

The repo should be safe to publish publicly. No AWS credentials, access keys, secrets, account IDs, or personal configuration should be committed.

Repository Name

aws-study-lab

Primary Use Case

This repository is for following AWS Study Lab labs locally while preparing for:

- AWS Certified Solutions Architect – Associate
- Exam code: SAA-C03

The setup should support:

- AWS CLI v2
- Named AWS CLI profiles
- Shell scripting
- Basic JSON parsing with jq
- Git-based notes and lab tracking
- Future Terraform or CDK expansion, but do not install those yet unless explicitly requested

Required File Structure

Create the following structure:

aws-study-lab/
├── .devcontainer/
│ ├── devcontainer.json
│ └── Dockerfile
├── labs/
│ └── README.md
├── notes/
│ └── README.md
├── scripts/
│ ├── check-aws-identity.sh
│ └── cleanup-reminders.sh
├── .env.example
├── .gitignore
├── README.md
└── LICENSE

Dev Container Requirements

Create a VS Code Dev Container that uses Ubuntu as the base image and installs the following tools:

- AWS CLI v2
- Git
- curl
- unzip
- jq
- less
- groff
- vim or nano
- Python 3
- pip

The container should run as the non-root vscode user.

The user’s local AWS config directory should be mounted into the container:

Host: ~/.aws
Container: /home/vscode/.aws

This allows the container to use local AWS CLI profiles without storing credentials in the repo.

.devcontainer/devcontainer.json

Create a Dev Container config with:

- Name: aws-study-lab
- Dockerfile-based build
- Remote user: vscode
- Mount for ~/.aws
- VS Code extensions:
  - AWS Toolkit
  - Docker extension
- Post-create command that prints versions for:
  - AWS CLI
  - Git
  - Python
  - jq

Suggested content:

{
"name": "aws-study-lab",
"build": {
"dockerfile": "Dockerfile"
},
"remoteUser": "vscode",
"mounts": [
"source=${localEnv:HOME}/.aws,target=/home/vscode/.aws,type=bind,consistency=cached"
],
"containerEnv": {
"AWS_PROFILE": "${localEnv:AWS_PROFILE:saa-lab}",
    "AWS_REGION": "${localEnv:AWS_REGION:us-east-1}"
},
"customizations": {
"vscode": {
"extensions": [
"amazonwebservices.aws-toolkit-vscode",
"ms-azuretools.vscode-docker"
],
"settings": {
"terminal.integrated.defaultProfile.linux": "bash"
}
}
},
"postCreateCommand": "aws --version && git --version && python3 --version && jq --version"
}

.devcontainer/Dockerfile

Create a Dockerfile based on the Microsoft Dev Containers Ubuntu image.

Suggested content:

FROM mcr.microsoft.com/devcontainers/base:ubuntu
RUN apt-get update && apt-get install -y \
 curl \
 unzip \
 groff \
 less \
 jq \
 git \
 vim \
 nano \
 python3 \
 python3-pip \
 ca-certificates \
 && rm -rf /var/lib/apt/lists/\*
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" \
 && unzip /tmp/awscliv2.zip -d /tmp \
 && /tmp/aws/install \
 && rm -rf /tmp/aws /tmp/awscliv2.zip
RUN aws --version

.env.example

Create a public-safe environment template.

Do not include real secrets.

Suggested content:

# Copy this file to .env for local-only settings.

# Never commit .env.

AWS_PROFILE=saa-lab
AWS_REGION=us-east-1
AWS_DEFAULT_REGION=us-east-1

# Optional: use this for scripts that need a default lab prefix.

LAB_NAME=aws-study-lab

.gitignore

Create a .gitignore that prevents secrets and local files from being committed.

It must include:

# Environment files

.env
.env.\*
!.env.example

# AWS credentials and local config

.aws/
awscliv2.zip

# OS/editor files

.DS_Store
.vscode/
.idea/

# Logs

\*.log

# Python

**pycache**/
\*.pyc
.venv/
venv/

# Terraform, for future use

.terraform/
_.tfstate
_.tfstate.\*
.terraform.lock.hcl

Important: .env.example must remain tracked.

Scripts

scripts/check-aws-identity.sh

Create an executable script that verifies the current AWS CLI identity.

Content:

#!/usr/bin/env bash
set -euo pipefail
echo "AWS_PROFILE=${AWS_PROFILE:-not set}"
echo "AWS_REGION=${AWS_REGION:-not set}"
echo
aws sts get-caller-identity

Make it executable:

chmod +x scripts/check-aws-identity.sh

scripts/cleanup-reminders.sh

Create an executable script that reminds the user what to clean up after AWS labs.

Content:

#!/usr/bin/env bash
set -euo pipefail
cat <<'EOF'
AWS lab cleanup reminder:
Check and delete resources you created during labs, especially:

- EC2 instances
- EBS volumes
- Elastic IPs
- NAT gateways
- Load balancers
- Target groups
- VPC endpoints
- S3 buckets
- RDS databases
- CloudWatch log groups
- IAM users, roles, and access keys created for labs
  Useful commands:
  aws sts get-caller-identity
  aws ec2 describe-instances
  aws s3 ls
  aws rds describe-db-instances
  aws elbv2 describe-load-balancers
  Always confirm in the AWS Console before assuming cleanup is complete.
  EOF

Make it executable:

chmod +x scripts/cleanup-reminders.sh

README.md

Create a clear README with the following sections:

1. Project title
2. Purpose
3. What this repo is for
4. What this repo is not for
5. Prerequisites
6. Setup steps
7. AWS credentials guidance
8. Dev Container usage
9. Common commands
10. Lab cleanup checklist
11. Security rules
12. Future additions

The README should explain:

- This repository is for AWS SAA-C03 learning.
- It replaces Gitpod with a local VS Code Dev Container.
- Docker Desktop is required on macOS unless using another Docker-compatible runtime.
- AWS credentials should never be stored in this repo.
- The user should configure AWS CLI profiles locally using aws configure --profile saa-lab.
- The container mounts ~/.aws from the host.
- The user should run scripts/check-aws-identity.sh before doing labs.
- The user should create a billing alarm in AWS.
- The user should not use the AWS root account for labs.
- The user should delete AWS resources after each lab.

Use this README draft:

# AWS Study Lab

Local AWS Study Lab environment for preparing for the AWS Certified Solutions Architect – Associate exam, SAA-C03.
This repository is designed to replace cloud-based course environments such as Gitpod with a local VS Code Dev Container.

## Purpose

This repo provides a repeatable local sandbox for AWS CLI practice, course labs, notes, and scripts.
It is intended for following AWS Study Lab material, including long-form courses that use browser-based development environments.

## What This Repo Is For

- AWS SAA-C03 exam preparation
- AWS CLI practice
- Local lab notes
- Repeatable Dev Container setup
- Safe public GitHub learning repository

## What This Repo Is Not For

- Storing AWS credentials
- Storing access keys
- Production infrastructure
- Real company workloads
- Long-running AWS resources

## Prerequisites

Install the following on your machine:

- Visual Studio Code
- VS Code Dev Containers extension
- Docker Desktop or another Docker-compatible runtime
- Git
- An AWS account for learning

## Setup

Clone the repository:

````bash
git clone https://github.com/YOUR_USERNAME/aws-study-lab.git
cd aws-study-lab

Copy the environment example:

cp .env.example .env

Edit .env if needed:

AWS_PROFILE=saa-lab
AWS_REGION=us-east-1
AWS_DEFAULT_REGION=us-east-1

Open the folder in VS Code:

code .

Then use:

Command Palette → Dev Containers: Reopen in Container

AWS Credentials

Do not commit AWS credentials to this repository.

Configure AWS credentials on your host machine, not inside the repo:

aws configure --profile saa-lab

The Dev Container mounts your local AWS config directory:

~/.aws → /home/vscode/.aws

Inside the container, verify your identity:

./scripts/check-aws-identity.sh

Expected result:

{
  "UserId": "...",
  "Account": "...",
  "Arn": "..."
}

Recommended AWS Safety Setup

Before doing labs:

* Enable MFA on the AWS root account
* Do not use the root account for labs
* Use a dedicated IAM user or IAM Identity Center user
* Create a billing alarm
* Use a single default Region while learning
* Delete resources after each lab

Common Commands

Check AWS identity:

aws sts get-caller-identity

Check configured Region:

aws configure get region --profile saa-lab

List S3 buckets:

aws s3 ls

Show EC2 instances:

aws ec2 describe-instances

Run cleanup reminder:

./scripts/cleanup-reminders.sh

Lab Organization

Use the labs/ directory for hands-on exercises.

Suggested format:

labs/
├── 001-iam-basics/
├── 002-s3-basics/
├── 003-vpc-basics/
└── README.md

Each lab should include:

* Goal
* AWS services used
* Commands run
* Screenshots if useful
* Cleanup steps
* Lessons learned

Notes Organization

Use the notes/ directory for exam notes.

Suggested topics:

notes/
├── iam.md
├── s3.md
├── ec2.md
├── vpc.md
├── rds.md
├── route53.md
├── cloudfront.md
└── well-architected.md

Security Rules

Never commit:

* .env
* AWS access keys
* AWS secret access keys
* Session tokens
* Account IDs, if you prefer to keep them private
* Downloaded credentials CSV files
* Terraform state files
* Private SSH keys

Before pushing, run:

git status

Review all staged files before committing:

git diff --cached

Future Additions

Possible future additions:

* Terraform support
* AWS CDK support
* LocalStack support
* Makefile commands
* Cost cleanup scripts
* SAA-C03 topic checklist

## `labs/README.md`
Create:
```markdown
# Labs
Use this directory for hands-on AWS labs.
Each lab should include:
- Goal
- Services used
- Commands
- Screenshots or diagrams if useful
- Cleanup steps
- Lessons learned
Suggested naming:
```text
001-iam-basics
002-s3-basics
003-vpc-basics
004-ec2-basics
## `notes/README.md`
Create:
```markdown
# Notes
Use this directory for AWS SAA-C03 study notes.
Suggested note files:
- `iam.md`
- `s3.md`
- `ec2.md`
- `vpc.md`
- `rds.md`
- `route53.md`
- `cloudfront.md`
- `well-architected.md`
- `exam-tips.md`

LICENSE

Add an MIT License unless otherwise specified.

Use the current year and the repository owner’s name.

If the owner name is unknown, use:

Copyright (c) 2026

Git Initialization

If this is a new local folder, initialize Git:

git init
git add .
git commit -m "Initial AWS Study Lab dev container setup"

Do not create the GitHub remote unless the username is known.

Leave a placeholder in the README:

https://github.com/pranav1416/aws-study-lab

Acceptance Criteria

The setup is complete when:

* The repository has the required file structure.
* VS Code can reopen the project in a Dev Container.
* aws --version works inside the container.
* jq --version works inside the container.
* python3 --version works inside the container.
* .env is ignored by Git.
* .env.example is tracked by Git.
* scripts/check-aws-identity.sh is executable.
* scripts/cleanup-reminders.sh is executable.
* No credentials or secrets are committed.
* README explains how to use the repo safely.

Important Constraints

Do not:

* Commit .env
* Commit AWS credentials
* Add real AWS account IDs
* Add real access keys
* Add Terraform yet
* Add CDK yet
* Add LocalStack yet
* Create actual AWS resources
* Assume root account usage

Keep the first version simple and focused on local AWS CLI learning.
````
