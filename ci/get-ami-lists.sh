#!/bin/bash -e

shopt -s extglob

for tc_worker_type in gecko-1-b-win2012 gecko-1-b-win2012-beta gecko-2-b-win2012 gecko-3-b-win2012 gecko-t-win7-32 gecko-t-win7-32-beta gecko-t-win7-32-gpu gecko-t-win7-32-gpu-b gecko-t-win10-64 gecko-t-win10-64-beta gecko-t-win10-64-gpu gecko-t-win10-64-gpu-b; do
  mkdir -p ami/${tc_worker_type}
  for region in eu-central-1 us-east-1 us-east-2 us-west-1 us-west-2; do
    aws ec2 describe-images --profile taskcluster --region ${region} --owners self --filters "Name=name,Values=${tc_worker_type} version*" | jq '[ .Images[] | { ImageId, CreationDate, GitSha: (.Name | split(" "))[2] } ] | sort_by(.CreationDate)' > ami/${tc_worker_type}/${region}.json
  done
done