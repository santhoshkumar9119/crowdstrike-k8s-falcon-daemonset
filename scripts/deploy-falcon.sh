#!/bin/bash

kubectl create namespace falcon-system

kubectl label ns --overwrite falcon-system \
pod-security.kubernetes.io/enforce=privileged

kubectl label ns --overwrite falcon-system \
pod-security.kubernetes.io/audit=privileged

kubectl label ns --overwrite falcon-system \
pod-security.kubernetes.io/warn=privileged

helm install falcon-sensor crowdstrike/falcon-sensor \
-n falcon-system \
--set falcon.cid=${FALCON_CID} \
--set node.image.repository=us-west1-docker.pkg.dev/grp-cyber-sky-cloudsec-test/crowdstrike-test/falcon-sensor \
--set node.image.tag=latest \
--set node.image.registryConfigJSON=$FALCON_IMAGE_PULL_TOKEN
