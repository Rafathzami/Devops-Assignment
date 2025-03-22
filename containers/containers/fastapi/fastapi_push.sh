#!/bin/bash


docker login -u zamirafath 
docker tag fastapi-gateway zamirafath/fastapi-gateway:latest


docker push zamirafath/fastapi-gateway:latest
