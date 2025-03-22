#!/bin/bash

MODEL_CONTAINER="kserve-model"
GATEWAY_CONTAINER="fastapi-gateway"
MODEL_PORT=8080
GATEWAY_PORT=8001
REPO="myrepo" 
MODEL_IMAGE="$REPO/kserve-model:latest"
GATEWAY_IMAGE="$REPO/fastapi-gateway:latest"

echo "Starting Docker containers..."
docker run -d --rm --name $MODEL_CONTAINER -p $MODEL_PORT:8080 $MODEL_IMAGE

docker run -d --rm --name $GATEWAY_CONTAINER -p $GATEWAY_PORT:8001 $GATEWAY_IMAGE

echo "Containers started successfully!"
sleep 5


echo "Testing API Gateway..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST http://localhost:8001/gateway/ocr -F "image_file=@test_image.png")

if [ "$RESPONSE" -eq 200 ]; then
  echo "Test passed! API is working."
else
  echo "Test failed! API response code: $RESPONSE"
fi

echo "Stopping containers..."
docker stop $MODEL_CONTAINER $GATEWAY_CONTAINER

echo "Containers stopped successfully!"
