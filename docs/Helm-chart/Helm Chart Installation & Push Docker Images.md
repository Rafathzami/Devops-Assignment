Helm Chart 

1.Run these to install the charts 

helm install kserve-model helm-charts/kserve-model  
helm install fastapi-gateway helm-charts/fastapi-gateway

2.verify the deployments 

kubectl get pods  
kubectl get services

3\. Get service URL 

minikube service kserve-model \--url  
minikube service fastapi-gateway \--url

4\.  Push Docker Images 

docker build \-t zamirafath/kserve-model:latest \-f Dockerfile.model .  
docker build \-t zamirafath/fastapi-gateway:latest \-f Dockerfile.gateway .  
docker push zamirafath/kserve-model:latest  
docker push zamirafath/fastapi-gateway:latest

