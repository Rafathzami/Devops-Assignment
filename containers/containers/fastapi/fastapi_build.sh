#!/bin/bash

docker build -t fastapi-gateway .
docker run -d -p 8000:8000 --name fastapi-gateway fastapi-gateway
curl http://localhost:8000/health
