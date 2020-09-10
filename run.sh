#!/bin/bash

echo " -------- Start ----------"

mkdir -p ./creds

#  Add secret "SERVICEACCOUNT_cloud_run" to /security/secret-manager
#  Enable "Secret Manager" in cloud-build/settings
gcloud secrets versions access latest --secret=$name_secret --format='get(payload.data)' | tr '_-' '/+' | base64 -d > ./creds/serviceaccount.json

gcloud auth activate-service-account --key-file ./creds/serviceaccount.json

echo " -------- Cloud run ----------"
#https://cloud.google.com/sdk/gcloud/reference/run/deploy#--[no-]allow-unauthenticated
gcloud run deploy $SERVICE_NAME --image $img --region $region \
  --platform managed \
  --allow-unauthenticated \
  --port 80 || exit 1

echo " -------- Clean up ----------"

## Clean up
gcloud container images delete $img || exit 1
##  "|| exit 1" ===> Exit if exists error

echo " COMMIT sha ==> $COMMITsha"

############ To delete the Cloud Run service, use this command:
####gcloud run services delete $SERVICE_NAME \
####   --platform managed \
####   --region $region --quiet || exit 1


echo " -------- End ----------"
