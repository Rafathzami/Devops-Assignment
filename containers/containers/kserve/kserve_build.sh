#!/bin/bash

docker build -t kserve-model-server .

docker run -d -p 8080:8080 --name kserve-model-server kserve-model-server


curl http://localhost:8080/v1/models/your_model_name
