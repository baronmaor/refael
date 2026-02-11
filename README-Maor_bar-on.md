# HEY! DevOps Assignment – What I Built

## About the Project


The app itself is very simple (just a small Node.js / Express server).  
The main goal here wasn't the app — it was building a full CI/CD + Kubernetes workflow around it.

This was my first time setting up something like this end to end, so most of the learning happened while building and debugging it.

i used Deployment the reason behind as ai understand is due to app nature, 
the nodejs app only serves http requests , no static storage , db or any kind of static content to be served .

## What I Set Up

### Docker

- Multi-stage Docker build (to keep the image small)
- Non-root container
- Multi-arch build (amd64 + arm64)
- Fixed npm vulnerabilities that were flagged by Trivy

The multi-arch part was especially important because my cluster runs on ARM, and the image initially failed to start.

### CI Pipeline (GitHub Actions)

On every push to `master`:

1. Helm charts are validated
2. Code is scanned with Semgrep
3. Docker image is built (multi-arch)
4. Image is pushed to DockerHub
5. Trivy scans the image (fails on HIGH/CRITICAL)
6. SBOM is generated
7. `values.yaml` is updated with the new image SHA
8. Change is committed back to Git

### Kubernetes + Helm

I created a Helm chart that deploys:

- Deployment (2 replicas)
- Resource limits
- Security context (non-root, read-only filesystem)
- Health checks
- Service + Ingress

The image tag comes from `values.yaml`, not hardcoded.

### ArgoCD (GitOps)

Instead of deploying directly from CI, the pipeline updates Git.

ArgoCD watches the repo and automatically syncs the cluster when `values.yaml` changes.

**So the flow is:**

Push → CI builds + scans → Git updated → ArgoCD deploys → Rolling update in Kubernetes

## Screenshots Included

- Successful GitHub Actions run
- Trivy scan results
- ArgoCD synced and healthy
- Running pods in Kubernetes