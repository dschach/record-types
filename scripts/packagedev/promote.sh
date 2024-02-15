#!/bin/bash

listPackageJson=$(sf package version list --json --released --packages "Record Types" --order-by createddate)
#echo $listPackageJson
#$promotePackageJson = sf package version promote --package "Record Types" --json # | jq --raw-output '.result.SubscriberPackageVersionId' create.json
#$promotePackageJson = create.json # | jq --raw-output '.result.SubscriberPackageVersionId' create.json
#echo $listPackageJson | jq '.result[-1].SubscriberPackageVersionId' --raw-output

currentPackageVersionId=$(echo $listPackageJson | jq '.result[-1].SubscriberPackageVersionId' --raw-output)
#echo $currentPackageVersionId
echo "New SubscriberPackageVersionId = $currentPackageVersionId"
#sed -i  "" "s|installPackage.apexp\?p0=.{0,18}|installPackage.apexp?p0=$currentPackageVersionId|g" "README.md"
sed -E -i "" "s|installPackage\.apexp\?p0=.{0,18}|installPackage.apexp?p0=$currentPackageVersionId|g" README.md 
