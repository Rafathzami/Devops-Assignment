#!/bin/bash

REPO="TuanRafath"  
K_SERVE="$REPO/kserve-model:latest"
FAST_API="$REPO/fastapi-gateway:latest"

echo "Building Docker images..."

docker build -t $FAST_API -f containers/containers/fastapi/dockerfile/dockerfile .
docker build -t $K_SERVE -f containers/containers/kserve/dockerfile/dockerfile .

echo "Docker images built successfully!"


echo "Pushing images to Docker Hub..."
docker login
docker push $FAST_API
docker push $K_SERVE

echo "Images pushed successfully!"
