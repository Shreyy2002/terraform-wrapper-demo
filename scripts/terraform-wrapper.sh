#!/bin/bash
set -e

ACTION=$1
cd terraform

case "$ACTION" in
  init)
    terraform init
    ;;
  validate)
    terraform validate
    ;;
  plan)
    terraform plan -var-file="terraform.tfvars"
    ;;
  apply)
    terraform apply -auto-approve -var-file="terraform.tfvars"
    ;;
  destroy)
    terraform destroy -auto-approve -var-file="terraform.tfvars"
    ;;
  *)
    echo "❌ Invalid action: $ACTION"
    exit 1
    ;;
esac
