#!/bin/bash


mkdir -p ./creds 

#  Add secret "SERVICEACCOUNT_bigquery" to /security/secret-manager
#  Enable "Secret Manager" in cloud-build/settings
gcloud secrets versions access latest --secret=$name_secret --format='get(payload.data)' | tr '_-' '/+' | base64 -d > ./creds/serviceaccount.json

gcloud auth activate-service-account --key-file ./creds/serviceaccount.json

gcloud run deploy $SERVICE_NAME --image gcr.io/$PROJECTid/$SERVICE_NAME:$COMMITsha --region $region --platform managed


ls

echo " -------- Hello ----------"
