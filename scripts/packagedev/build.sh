#!/bin/bash

versionCreateJson=$(sf package version create --code-coverage --installation-key-bypass --wait 90 --verbose --definition-file config/no-rt-scratch-def.json --package "Record Types" --target-dev-hub x2od --json)

# json result
# .result.SubscriberPackageVersionId
# .result.Status = "Success"
# .result.Error = [] (array of errors)

versionCreateStatus=$(echo "$versionCreateJson" | jq -r '.result.Status')
echo "$versionCreateStatus"
if [ "$versionCreateStatus" == "Success" ]; then
  # TODO: add the steps that run after a successful package version create
  :
fi
