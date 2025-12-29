#  Voiceowl DevSecOps Assessment

**Full end-to-end DevSecOps pipeline: Docker → CI/CD → Kubernetes → Monitoring**

##  Assessment Deliverables (All Tasks Complete)

###  **Task 1: Docker Hardening**
- Multi-stage `node:20-alpine` base image
- Non-root user (`USER node`)
- `npm ci --only=production`
- Trivy scan: `trivy.txt` [0 app vulnerabilities]

###  **Task 2: CI/CD Security**
- GitHub Actions: `.github/workflows/ci.yml`
- Semgrep SAST (OWASP Top 10)
- Trivy container scan **fails on HIGH/CRITICAL**

###  **Task 4: Kubernetes Hardening**

k8s/namespace.yaml
k8s/deployment.yaml (runAsNonRoot, resource limits, no privilege escalation)
k8s/service.yaml
k8s/networkpolicy.yaml (deny-all ingress)
k8s-validation.txt


###  **Task 5: Monitoring**

monitoring/prometheus.yaml (pod restarts + CPU alerts)


###  **Task 6: Report**
`Report.md` - Risks, hardening, production gaps

---

##  Quick Start (Local)

App
npm install
npm start # http://localhost:3000

Docker + Security
docker build -t devsecops-app .
trivy image devsecops-app # See trivy.txt

Kubernetes (Minikube)
minikube start --driver=docker
& minikube docker-env | Invoke-Expression
docker build -t devsecops-app .
kubectl apply -f k8s/ -R
kubectl get pods -n devsecops
minikube service app-service -n devsecops --url

##  CI/CD Pipeline Flow

git push → GitHub Actions → Semgrep → Docker Build → Trivy Scan → [FAIL on HIGH]
↓ (if clean)
Kubernetes Deploy


**Security Gate**: Trivy `exit-code: 1` blocks deployment on vulnerabilities

---

##  Security Hardening Summary

| Component | Hardening Applied |
|-----------|-------------------|
| **Docker** | Multi-stage, non-root, production deps only |
| **CI/CD** | Semgrep + Trivy (fail-fast on HIGH/CRITICAL) |
| **Kubernetes** | `runAsNonRoot: true`, resource limits, NetworkPolicy deny-all |
| **Monitoring** | Prometheus alerts (restarts, CPU) |

---

##  Verification Commands

Security scans
npm audit # 0 vulnerabilities
docker build -t devsecops-app . 
trivy image devsecops-app 
kubectl apply --dry-run=client -f k8s/ -R

Demo
kubectl get all -n devsecops # All resources healthy
minikube service app-service -n devsecops --url # App accessible



