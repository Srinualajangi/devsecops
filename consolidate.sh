#!/bin/bash
set -e

# --- CONFIGURATION ---
DH_USER="srinualajangi"
TAG="v2"
# ---------------------

echo "=================================================="
echo "   ROBOSHOP PROJECT CONSOLIDATION SCRIPT"
echo "=================================================="

# 1. FIX GIT ISSUES
# The 'shipping' folder has an inner .git repo which confuses the main repo.
echo "[1/4] Fixing Git Submodule Warnings..."
if [ -d "source-code/shipping/.git" ]; then
    rm -rf source-code/shipping/.git
    git rm --cached source-code/shipping 2>/dev/null || true
    echo "Removed inner .git from shipping."
else
    echo "Shipping .git not found (already clean)."
fi

# Add all changes
git add .
git commit -m "fix: consolidate shipping code and latest fixes" || echo "Nothing to commit"

# 2. GET ECR INFO
# We extract the ECR Repository URI from a running service (e.g., cart)
echo "[2/4] Detecting ECR URI..."
ECR_URI=$(kubectl get deployment cart -n roboshop -o jsonpath='{.spec.template.spec.containers[0].image}' | cut -d'/' -f1)
echo "Detected ECR: $ECR_URI"

if [ -z "$ECR_URI" ]; then
    echo "Error: Could not detect ECR URI from running pods. Make sure 'cart' deployment is running."
    exit 1
fi

# Authenticate Docker to ECR
echo "Logging in to ECR..."
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_URI

# 3. BACKUP TO DOCKER HUB (v2)
echo "[3/4] Backing up Running Images to Docker Hub ($DH_USER)..."

# List of services to backup
SERVICES="cart payment shipping user catalogue dispatch frontend mongodb mysql rabbitmq redis"

for SVC in $SERVICES; do
    # Get current image from K8s
    CURRENT_IMG=$(kubectl get deployment $SVC -n roboshop -o jsonpath='{.spec.template.spec.containers[0].image}')
    
    TARGET_IMG="$DH_USER/$SVC:$TAG"
    
    echo "Backing up $SVC ($CURRENT_IMG) -> $TARGET_IMG"
    docker tag $CURRENT_IMG $TARGET_IMG
    docker push $TARGET_IMG
done

# 4. PROMOTE PUBLIC IMAGES TO ECR
echo "[4/4] Promoting Public Images to ECR..."

# Public images used in the project
PUBLIC_APPS="redis mysql rabbitmq mongodb"

for APP in $PUBLIC_APPS; do
    # Get the image currently running
    CURRENT_IMG=$(kubectl get deployment $APP -n roboshop -o jsonpath='{.spec.template.spec.containers[0].image}')
    
    # Target: ECR/name:tag
    # We strip the registry if present, or just use the name
    IMG_NAME=$(echo $CURRENT_IMG | awk -F/ '{print $NF}')
    TARGET_ECR="$ECR_URI/$IMG_NAME"
    
    # Create Repo if it doesn't exist (optional, but safe)
    aws ecr create-repository --repository-name $IMG_NAME --region us-east-1 2>/dev/null || true
    
    echo "Promoting $APP ($CURRENT_IMG) -> $TARGET_ECR"
    docker tag $CURRENT_IMG $TARGET_ECR
    docker push $TARGET_ECR
done

echo "=================================================="
echo "   CONSOLIDATION COMPLETE"
echo "   - Code Committed"
echo "   - Images backed up to Docker Hub: $DH_USER/*:$TAG"
echo "   - Public images promoted to ECR: $ECR_URI/*"
echo "=================================================="
