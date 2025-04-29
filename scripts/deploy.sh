#!/bin/bash

set -e
# Variables
AWS_REGION=""
AWS_ACCOUNT_ID=""
ECR_NAME=""
CONTAINER_NAME=""
SECRET_NAME=""

ECR_REPO="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_NAME"
IMAGE_TAG=$(cat /home/ubuntu/app/image_tag.txt)

# Login to ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO

# Pull latest image
docker pull $ECR_REPO:$IMAGE_TAG

# Fetch DB credentials from Secrets Manager
SECRET_JSON=$(aws secretsmanager get-secret-value --secret-id $SECRET_NAME --region $AWS_REGION --query SecretString --output text)

# Parse JSON (if jq is available)
DB_USER=$(echo $SECRET_JSON | jq -r .DB_USER)
DB_PASS=$(echo $SECRET_JSON | jq -r .DB_PASS)
DB_HOST=$(echo $SECRET_JSON | jq -r .DB_HOST)
DB_NAME=$(echo $SECRET_JSON | jq -r .DB_NAME)

# Stop old container
docker stop $CONTAINER_NAME || true
docker rm $CONTAINER_NAME || true

# Run new container with environment variables
docker run -d \
  --name $CONTAINER_NAME \
  -p 80:3000 \
  -e DB_USER=$DB_USER \
  -e DB_PASS=$DB_PASS \
  -e DB_HOST=$DB_HOST \
  -e DB_NAME=$DB_NAME \
  $ECR_REPO:$IMAGE_TAG
