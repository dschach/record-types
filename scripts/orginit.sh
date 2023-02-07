#!/bin/bash

echo "Cleaning previous scratch org..."
sfdx force:org:delete -p -u RecordTypes

echo "Creating new scratch org"
sfdx force:org:create -f config/project-scratch-def.json --durationdays 10 -a RecordTypes -s

echo "Pushing metadata"
sfdx force:source:push

echo "Assigning permission set"
sfdx force:user:permset:assign -n unpackaged/main/default/permissionsets/RecordTypes_DefaultRT_for_Testing

echo "Running Apex tests"
sfdx force:apex:test:run --codecoverage --resultformat human -l RunLocalTests --wait 20

echo "Opening org"
sfdx force:org:open

echo "Org is set up"