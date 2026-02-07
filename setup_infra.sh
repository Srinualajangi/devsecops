#!/bin/bash
set -e

# CONFIGURATION
ECR_URI="718307299298.dkr.ecr.us-east-1.amazonaws.com"
ENV=$1

if [ -z "$ENV" ]; then
    echo "Usage: ./setup_infra.sh <env>"
    exit 1
fi

VALUES_FILE="helm/values-$ENV.yaml"
NAMESPACE="roboshop-$ENV"

echo "Setting up Infrastructure for: $ENV (Namespace: $NAMESPACE)"

# 1. Create Namespace
kubectl create namespace $NAMESPACE 2>/dev/null || true

# 2. Deploy Databases
echo "[Infra] Deploying MongoDB (mongo:5.0)..."
helm upgrade --install mongodb helm/common -f $VALUES_FILE --set component=mongodb \
    --set image.repository=$ECR_URI/mongo --set image.tag=5.0 -n $NAMESPACE

echo "[Infra] Deploying Redis (redis:6.2)..."
helm upgrade --install redis helm/common -f $VALUES_FILE --set component=redis \
    --set image.repository=$ECR_URI/redis --set image.tag=6.2 -n $NAMESPACE

echo "[Infra] Deploying MySQL (mysql:5.7)..."
# MySQL requires a root password to start
helm upgrade --install mysql helm/common -f $VALUES_FILE --set component=mysql \
    --set image.repository=$ECR_URI/mysql --set image.tag=5.7 \
    --set env.MYSQL_ROOT_PASSWORD=roboshop \
    -n $NAMESPACE

echo "[Infra] Deploying RabbitMQ (rabbitmq:3.9)..."
# RabbitMQ needs default credentials
helm upgrade --install rabbitmq helm/common -f $VALUES_FILE --set component=rabbitmq \
    --set image.repository=$ECR_URI/rabbitmq --set image.tag=3.9-management \
    --set env.RABBITMQ_DEFAULT_USER=roboshop \
    --set env.RABBITMQ_DEFAULT_PASS=roboshop123 \
    -n $NAMESPACE

echo "✅ Infrastructure Ready! Apps are not installed yet."
