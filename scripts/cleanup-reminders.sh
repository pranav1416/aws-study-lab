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
