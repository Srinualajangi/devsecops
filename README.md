# 🔐 DevSecOps Pipeline

End-to-end **DevSecOps pipeline** integrating security scanning, infrastructure provisioning, and automated deployments using **GitHub Actions**, **Terraform**, and **Helm**.

## 📋 Architecture

```
Code Push → GitHub Actions → Build → SAST/DAST → Docker Build → Push to Registry → Terraform Infra → Helm Deploy to K8s
```

## 📁 Project Structure

```
├── .github/workflows/     # GitHub Actions CI/CD pipeline definitions
├── helm/                  # Helm charts for Kubernetes deployments
├── source-code/           # Application source code
├── terraform/             # Infrastructure as Code (AWS provisioning)
├── consolidate.sh         # Consolidation script
└── setup_infra.sh         # Infrastructure setup automation
```

## 🛠️ Tech Stack

- **CI/CD:** GitHub Actions
- **IaC:** Terraform
- **Orchestration:** Kubernetes + Helm
- **Security:** SAST (SonarQube), DAST (OWASP ZAP), Container Scanning
- **Cloud:** AWS

## 🔒 Security Integrations

| Stage | Tool | Purpose |
|-------|------|---------|
| Code Analysis | SonarQube (SAST) | Static code analysis for vulnerabilities |
| Dependency Check | OWASP Dependency Check | Known CVE detection in dependencies |
| Container Scan | Trivy | Docker image vulnerability scanning |
| Dynamic Testing | OWASP ZAP (DAST) | Runtime security testing |

## 🚀 Pipeline Workflow

1. **Build** — Compile source code and run unit tests
2. **SAST** — Static Application Security Testing via SonarQube
3. **Docker Build** — Build and tag container image
4. **Container Scan** — Scan image for vulnerabilities
5. **Push** — Push image to container registry
6. **Infrastructure** — Provision/update AWS infra via Terraform
7. **Deploy** — Deploy to Kubernetes cluster using Helm charts
8. **DAST** — Dynamic security testing on running application

## ✅ Key Features

- Shift-left security — vulnerabilities caught early in pipeline
- Automated infrastructure provisioning with Terraform
- Helm-based Kubernetes deployments
- GitHub Actions workflows for full automation
- Infrastructure setup scripts for quick bootstrapping
