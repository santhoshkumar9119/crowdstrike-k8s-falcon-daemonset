# Troubleshooting Guide

# ImagePullBackOff / ErrImagePull

## Validate

* Artifact Registry permissions
* Service Account authentication
* Docker authentication
* Sensor image tag exists
* Node outbound connectivity

---

# Unauthorized Errors

## Verify

* QA API credentials
* Artifact Registry IAM permissions
* Service Account access roles

---

# Architecture Mismatch

## Ensure

* Platform architecture is x86_64
* Kubernetes nodes match sensor image architecture

---

# EKS AutoMode Issues

If Falcon Sensor pods are not running on system nodes in EKS AutoMode clusters, deploy using additional tolerations.

```bash id="c2a2px"
helm install falcon-sensor crowdstrike/falcon-sensor \
-n falcon-system \
--set falcon.cid=<CID> \
--set node.image.repository=us-west1-docker.pkg.dev/grp-cyber-sky-cloudsec-test/crowdstrike-test/falcon-sensor \
--set node.image.tag=latest \
--set node.image.registryConfigJSON=$FALCON_IMAGE_PULL_TOKEN \
--set 'node.daemonset.tolerations[0].key=node-role.kubernetes.io/master' \
--set 'node.daemonset.tolerations[0].operator=Exists' \
--set 'node.daemonset.tolerations[0].effect=NoSchedule' \
--set 'node.daemonset.tolerations[1].key=node-role.kubernetes.io/control-plane' \
--set 'node.daemonset.tolerations[1].operator=Exists' \
--set 'node.daemonset.tolerations[1].effect=NoSchedule' \
--set 'node.daemonset.tolerations[2].key=kubernetes.azure.com/scalesetpriority' \
--set 'node.daemonset.tolerations[2].operator=Equal' \
--set 'node.daemonset.tolerations[2].value=spot' \
--set 'node.daemonset.tolerations[2].effect=NoSchedule' \
--set 'node.daemonset.tolerations[3].key=CriticalAddonsOnly' \
--set 'node.daemonset.tolerations[3].operator=Exists' \
--set 'node.daemonset.tolerations[3].effect=NoSchedule'
```

---

# Pod Security Errors

## Verify Namespace Labels

```bash id="v4z4y2"
kubectl get ns falcon-system --show-labels
```

Expected labels:

```text id="yxdyqe"
pod-security.kubernetes.io/enforce=privileged
pod-security.kubernetes.io/audit=privileged
pod-security.kubernetes.io/warn=privileged
```
