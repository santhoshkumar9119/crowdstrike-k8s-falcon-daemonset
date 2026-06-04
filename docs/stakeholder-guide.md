# Stakeholder Deployment Guide

## Step 1 — Configure Kubernetes Cluster Access

### AWS EKS

```bash id="h92bd4"
aws eks update-kubeconfig \
--region <region> \
--name <cluster-name>
```

---

### Google GKE

```bash id="u9x4fk"
gcloud container clusters get-credentials \
<cluster_name> \
--region <region> \
--project <project>
```

---

### Azure AKS

```bash id="jlwm9i"
az aks get-credentials \
--resource-group <resource-group> \
--name <aks-cluster-name>
```

---

# Step 2 — Authenticate to Artifact Registry

## Login Using Service Account

```bash id="8q8lwi"
cat service-account-key.json | docker login \
-u _json_key \
--password-stdin \
https://us-west1-docker.pkg.dev
```

---

## Pull Falcon Sensor Image

```bash id="i2fx18"
docker pull \
us-west1-docker.pkg.dev/grp-cyber-sky-cloudsec-test/crowdstrike-test/falcon-sensor:latest
```

---

## Export Docker Registry Token

```bash id="v6qz7d"
export FALCON_IMAGE_PULL_TOKEN=$(cat ~/.docker/config.json | base64 -w 0)
```

---

# Step 3 — Create Namespace

> Namespace must be named `falcon-system`

```bash id="u3lmop"
kubectl create namespace falcon-system
```

---

# Step 4 — Configure Namespace Security Context

## Enforce Privileged Pods

```bash id="v1gc5d"
kubectl label ns --overwrite falcon-system \
pod-security.kubernetes.io/enforce=privileged
```

---

## Configure Audit and Warning Levels

```bash id="m9gqmp"
kubectl label ns --overwrite falcon-system \
pod-security.kubernetes.io/audit=privileged

kubectl label ns --overwrite falcon-system \
pod-security.kubernetes.io/warn=privileged
```

---

## Validate Namespace Labels

```bash id="nq9mk4"
kubectl get ns falcon-system --show-labels
```

---

# Step 5 — Install Falcon Sensor Using Helm

```bash id="1yywx0"
helm install falcon-sensor crowdstrike/falcon-sensor \
-n falcon-system \
--set falcon.cid=XXXXXXXXXXXXXXXXXX \
--set node.image.repository=us-west1-docker.pkg.dev/grp-cyber-sky-cloudsec-test/crowdstrike-test/falcon-sensor \
--set node.image.tag=latest \
--set node.image.registryConfigJSON=$FALCON_IMAGE_PULL_TOKEN
```

---

# Post Deployment

Each Kubernetes node will run one Falcon Sensor pod.

Restart application deployments after Falcon deployment:

```bash id="fyhgh8"
kubectl rollout restart \
-n <namespace> \
deployment <application-deployment-name>
```

> Perform rollout restart after every Falcon Sensor upgrade.

---

# Validation

## Verify Running Pods

```bash id="v5m5cs"
kubectl get pods -n falcon-system
```

---

## Verify Sensor AID

```bash id="v5z0lt"
kubectl exec -it -n falcon-system <pod-name> \
-- /opt/CrowdStrike/falconctl \
-g --aid --cid --version --backend --rfm-state --rfm-reason
```
