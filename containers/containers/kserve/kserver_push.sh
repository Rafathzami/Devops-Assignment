#!/bin/bash


docker login -u zamirafath 

docker tag kserve-model-server zamirafath/kserve-model-server:latest


docker push zamirafath/kserve-model-server:latest
