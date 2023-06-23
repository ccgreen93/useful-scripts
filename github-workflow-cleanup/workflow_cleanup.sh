#!/usr/bin/env bash

echo "starting workflow_cleanup.sh"

list_workflows() {
  # list workflows
  gh api -X GET /repos/$OWNER/$REPO/actions/workflows | jq '.workflows[] | .name,.id'
}

delete_workflows() {
  WORKFLOW_ID="$1"

  # list runs
  gh api -X GET /repos/$OWNER/$REPO/actions/workflows/$WORKFLOW_ID/runs | jq '.workflow_runs[] | .id'

  # delete runs
  while true; do
    delete_run=$(gh api -X GET /repos/$OWNER/$REPO/actions/workflows/$WORKFLOW_ID/runs | jq '.workflow_runs[] | .id' | xargs -I{} gh api -X DELETE /repos/$OWNER/$REPO/actions/runs/{})
    if [[ "${delete_run}" = *"Not Found"* ]]; then
      break
    else
      echo ...
    fi
    sleep 1
  done
}

delete_disabled_workflows() {
  # Get workflow IDs with status "disabled_manually"
  workflow_ids=($(gh api repos/$OWNER/$REPO/actions/workflows | jq '.workflows[] | select(.["state"] | contains("disabled_manually")) | .id'))

  for workflow_id in "${workflow_ids[@]}"
  do
    run_ids=( $(gh api repos/$OWNER/$REPO/actions/workflows/$workflow_id/runs --paginate | jq '.workflow_runs[].id') )
    for run_id in "${run_ids[@]}"
    do
      echo "Deleting Run ID $run_id"
      gh api repos/$OWNER/$REPO/actions/runs/$run_id -X DELETE >/dev/null
    done
  done
}

if [[ -z $1 ]]; then
  echo "Enter Repository Owner"
  read -r OWNER
else
  OWNER=$1
fi

if [[ -z $2 ]]; then
  echo "Enter Repository Name"
  read -r REPO
else
  REPO=$2
fi

if [[ -z $3 ]] ; then
  echo "No Workflow ID provided, listing Workflows..."
  list_workflows
elif [[ $3 == "disabled" ]]; then
  echo "Deleting Disabled Workflows..."
  delete_disabled_workflows
elif [[ $3 == "delete" ]]; then
  if [[ -z $4 ]]; then
    echo "No Workflow ID provided to delete. To delete all disabled workflows provide \"disabled\""
  else
    echo "Workflow ID '$4' to be deleted"
    delete_workflows "$4"
  fi
fi
