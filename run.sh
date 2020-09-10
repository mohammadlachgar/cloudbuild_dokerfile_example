#!/bin/bash


mkdir -p ./creds 

#  Add secret "SERVICEACCOUNT_bigquery" to /security/secret-manager
#  Enable "Secret Manager" in cloud-build/settings
gcloud secrets versions access latest --secret=$name_secret --format='get(payload.data)' | tr '_-' '/+' | base64 -d > ./creds/serviceaccount.json

gcloud auth activate-service-account --key-file ./creds/serviceaccount.json

#https://cloud.google.com/sdk/gcloud/reference/run/deploy#--[no-]allow-unauthenticated
gcloud run deploy $SERVICE_NAME --image $img --region $region \
  --platform managed \
  --allow-unauthenticated \
  --port 80

# Clean up
gcloud container images delete $img

## To delete the Cloud Run service, use this command:
# gcloud run services delete $SERVICE_NAME \
#   --platform managed \
#   --region $region

ls

echo " -------- Hello ----------"
