#!/bin/bash

gcloud auth activate-service-account \
--key-file=service-account-key.json

gcloud auth configure-docker us-west1-docker.pkg.dev
