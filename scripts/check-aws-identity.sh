#!/usr/bin/env bash
set -euo pipefail

echo "AWS_PROFILE=${AWS_PROFILE:-not set}"
echo "AWS_REGION=${AWS_REGION:-not set}"
echo
aws sts get-caller-identity
