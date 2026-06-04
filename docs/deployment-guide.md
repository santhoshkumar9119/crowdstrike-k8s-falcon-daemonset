# CrowdStrike Falcon Sensor Deployment Guide

## Overview

This guide explains how to:

* Pull the CrowdStrike Falcon Sensor image
* Push the image to centralized GCP Artifact Registry
* Deploy the sensor using Kubernetes DaemonSet
* Use QA API credentials for image retrieval
* Use PROD CID during deployment

Deployment operations are performed using Cloud Shell across AWS EKS, Azure AKS, and Google GKE environments.

---

# Prerequisites

Ensure the following tools are installed:

* Docker
* kubectl
* Helm 3.x
* Git
* Cloud SDK / Cloud Shell
* Access to GCP Artifact Registry
* Kubernetes cluster admin access

---

# Supported Platforms

* Amazon EKS
* Azure AKS (Linux nodes only)
* Google GKE

---

# Required Credentials

## QA API Credentials

Used only for pulling Falcon images.

```bash id="im7wy5"
FALCON_CLIENT_ID="XXXXXXXXX"
FALCON_CLIENT_SECRET="XXXXXXXXXXXXXXXX"
FALCON_CID="XXXXXXXXXXXXXXXXXXXXXXXXX"
```

---

## Production CID

Used during deployment.

```bash id="6tv2x4"
FALCON_CID="XXXXXXXXXXXXXXXXXXXXX"
```

---

# Important Notes

* CrowdStrike does NOT provide Production API keys.
* QA API credentials are only used for image retrieval.
* Production CID must always be used during installation.

---

# Step 1 — Validate Approved Sensor Version

Coordinate with the CrowdStrike team and confirm:

* Approved Falcon Sensor version
* Tested production version
* Security validation status

---

# Step 2 — Download CrowdStrike Pull Script

## Clone Repository

```bash id="fvv8f6"
git clone https://github.com/CrowdStrike/falcon-scripts.git

cd falcon-scripts/bash/containers/falcon-container-sensor-pull
```

## Make Script Executable

```bash id="lx7y7l"
chmod +x falcon-container-sensor-pull.sh
```

---

# Step 3 — Verify Available Sensor Versions

```bash id="4d0m45"
sudo ./falcon-container-sensor-pull.sh \
  --client-id ${FALCON_CLIENT_ID} \
  --client-secret ${FALCON_CLIENT_SECRET} \
  --list-tags \
  --type falcon-sensor
```

## Example Output

```json id="ijm81x"
{
  "name": "falcon-sensor",
  "repository": "registry.crowdstrike.com/falcon-sensor/release/falcon-sensor",
  "tags": [
    "7.31.0-18410-1",
    "7.32.0-18504-1",
    "7.33.0-18606-1",
    "7.34.0-18708-1",
    "7.35.0-18803-1"
  ]
}
```

---

# Step 4 — Pull and Push Sensor Image to Artifact Registry

## Example — Falcon Sensor Version 7.34

```bash id="0smj88"
./falcon-container-sensor-pull.sh \
  --client-id ${FALCON_CLIENT_ID} \
  --client-secret ${FALCON_CLIENT_SECRET} \
  --type falcon-sensor \
  --version 7.34.0-18708-1 \
  --copy us-west1-docker.pkg.dev/grp-cyber-sky-cloudsec-test/crowdstrike-test/falcon-sensor \
  --runtime docker \
  --platform x86_64
```

---

# Step 5 — Verify Image in Artifact Registry

```bash id="jvl3we"
gcloud artifacts docker images list \
us-west1-docker.pkg.dev/grp-cyber-sky-cloudsec-test/crowdstrike-test
```

---

# Step 6 — Configure Kubernetes Authentication

## Authenticate Using Service Account

```bash id="9egq12"
gcloud auth activate-service-account \
--key-file=<service-account-key.json>
```

## Configure Docker Authentication

```bash id="71b95e"
gcloud auth configure-docker us-west1-docker.pkg.dev
```

---

# Step 7 — Deployment Summary

| Component         | Value                 |
| ----------------- | --------------------- |
| Deployment Method | Kubernetes DaemonSet  |
| Runtime           | Docker                |
| Registry          | GCP Artifact Registry |
| Platform          | x86_64                |
| Authentication    | Service Account       |

---

# Best Practices

* Use centralized Artifact Registry for image governance
* Validate approved sensor versions before deployment
* Follow least-privilege IAM access
* Maintain version consistency across environments
* Always monitor DaemonSet health after deployment
