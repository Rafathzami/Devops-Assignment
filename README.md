# Devops-Assignment
![WhatsApp Image 2025-03-22 at 19 12 42](https://github.com/user-attachments/assets/a6ca9ed3-d011-4956-8930-1cfbfec7e2f9)
In this repo we have these components . 
✅ FastAPI Gateway: Accepts image uploads & proxies to KServe.
✅ KServe Model Service: Uses Tesseract OCR for inference.
✅ Dockerized & Deployed on Kubernetes using Helm.
✅ GitOps with ArgoCD for automated deployments.
✅ Monitoring: Prometheus for metrics, Grafana for dashboards.


🛠️ Tech Stack
Python (FastAPI, Poetry, Tesseract)
Docker
Kubernetes (Minikube)
Helm
ArgoCD
Prometheus & Grafana


🚀 Step-by-Step Deployment
For the steps you can refer the txt files in these paths

1️⃣ Local Setup & Testing
:-docs/Local-Setup

2️⃣ Build & Push Docker Images
;-docs/Containerazation

3️⃣ Kubernetes Deployment
:-docs/Helm-chart

4️⃣ ArgoCD for GitOps
:-docs/Argocd

5️⃣ Monitoring Setup (Prometheus & Grafana)
:-docs/Prometheus


      REQUEST_COUNT = Counter("inference_requests", "Total Inference Requests")
      def process_request():
          REQUEST_COUNT.inc()
 📊 Grafana Dashboard Metrics
Metric                 PromQL Query
Total Requestssum : (inference_requests)
Latency : (95th percentile)
histogram_quantile(0.95, rate(inference_latency_seconds_bucket[5m]))
Error Rate : rate(inference_errors_total[5m])

