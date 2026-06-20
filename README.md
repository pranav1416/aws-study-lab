# AWS Study Lab

Local AWS Study Lab environment for preparing for the AWS Certified Solutions Architect - Associate exam, SAA-C03.

This repository is designed to replace cloud-based course environments such as Gitpod with a local VS Code Dev Container.

Repository placeholder: <https://github.com/pranav1416/aws-study-lab>

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
- Docker Desktop on macOS, or another Docker-compatible runtime
- Git
- An AWS account for learning

## Setup

Clone the repository:

```bash
git clone https://github.com/pranav1416/aws-study-lab.git
cd aws-study-lab
```

Copy the environment example:

```bash
cp .env.example .env
```

Edit `.env` if needed:

```dotenv
AWS_PROFILE=saa-lab
AWS_REGION=us-east-1
AWS_DEFAULT_REGION=us-east-1
```

Open the folder in VS Code:

```bash
code .
```

Then use:

```text
Command Palette -> Dev Containers: Reopen in Container
```

## AWS Credentials Guidance

Do not commit AWS credentials to this repository.

Configure AWS credentials on your host machine, not inside the repo:

```bash
aws configure --profile saa-lab
```

The Dev Container mounts your local AWS config directory:

```text
~/.aws -> /home/vscode/.aws
```

Inside the container, verify your identity before doing labs:

```bash
./scripts/check-aws-identity.sh
```

Expected result:

```json
{
  "UserId": "...",
  "Account": "...",
  "Arn": "..."
}
```

## Dev Container Usage

The Dev Container installs:

- AWS CLI v2
- Git
- curl
- unzip
- jq
- less
- groff
- vim
- nano
- Python 3
- pip

The container runs as the non-root `vscode` user. The post-create command prints versions for AWS CLI, Git, Python, and jq.

## Common Commands

Check AWS identity:

```bash
aws sts get-caller-identity
```

Check configured Region:

```bash
aws configure get region --profile saa-lab
```

List S3 buckets:

```bash
aws s3 ls
```

Show EC2 instances:

```bash
aws ec2 describe-instances
```

Run cleanup reminder:

```bash
./scripts/cleanup-reminders.sh
```

## Lab Cleanup Checklist

After each lab, check and delete resources you created, especially:

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

Always confirm in the AWS Console before assuming cleanup is complete.

## Recommended AWS Safety Setup

Before doing labs:

- Enable MFA on the AWS root account
- Do not use the root account for labs
- Use a dedicated IAM user or IAM Identity Center user
- Create a billing alarm
- Use a single default Region while learning
- Delete resources after each lab

## Lab Organization

Use the `labs/` directory for hands-on exercises.

Suggested format:

```text
labs/
├── 001-iam-basics/
├── 002-s3-basics/
├── 003-vpc-basics/
└── README.md
```

Each lab should include:

- Goal
- AWS services used
- Commands run
- Screenshots if useful
- Cleanup steps
- Lessons learned

## Notes Organization

Use the `notes/` directory for exam notes.

Suggested topics:

```text
notes/
├── iam.md
├── s3.md
├── ec2.md
├── vpc.md
├── rds.md
├── route53.md
├── cloudfront.md
└── well-architected.md
```

## Security Rules

Never commit:

- `.env`
- AWS access keys
- AWS secret access keys
- Session tokens
- Account IDs, if you prefer to keep them private
- Downloaded credentials CSV files
- Terraform state files
- Private SSH keys

Before pushing, run:

```bash
git status
```

Review all staged files before committing:

```bash
git diff --cached
```

## Future Additions

Possible future additions:

- Terraform support
- AWS CDK support
- LocalStack support
- Makefile commands
- Cost cleanup scripts
- SAA-C03 topic checklist
