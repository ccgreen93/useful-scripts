#!/bin/bash

## check GKE Node Shielded status
for project in $(gcloud projects list --format="value(project_id)"); do
  gcloud container clusters list --project "$project" --region us-central1 --format="table(name,shieldedNodes)"
done