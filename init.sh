#!/bin/bash

## Check aws cli

if ! [ -x "$(command -v aws)" ]; then
  echo 'Error: aws cli is not installed.' >&2
  exit 1
fi

## Check terraform

if ! [ -x "$(command -v terraform)" ]; then
  echo 'Error: terraform is not installed.' >&2
  exit 1
fi

## Check aws profile you set
AWS_PROFILE=$(aws configure list | grep profile | awk '{print $2}')
AWS_REGION=$(aws configure list | grep region | awk '{print $2}')

if [ -z $AWS_PROFILE ]; then
  echo 'Error: AWS_PROFILE is not set.' >&2
  exit 1
fi

## Print aws region

echo "Will deploy to AWS with user $AWS_PROFILE && Region: $AWS_REGION"

## Start the deployment
terraform init
terraform apply -auto-approve
cd resource-management
terraform init
helm repo update
terraform apply -auto-approve
