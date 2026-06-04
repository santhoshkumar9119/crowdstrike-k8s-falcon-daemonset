#!/bin/bash

VERSION=$1

./falcon-container-sensor-pull.sh \
  --client-id ${FALCON_CLIENT_ID} \
  --client-secret ${FALCON_CLIENT_SECRET} \
  --type falcon-sensor \
  --version ${VERSION} \
  --copy us-west1-docker.pkg.dev/project-name/crowdstrike-test/falcon-sensor \
  --runtime docker \
  --platform x86_64
