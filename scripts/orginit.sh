#!/bin/bash

sfdx force:org:create -f config/project-scratch-def.json --durationdays 10 -a RecordTypes -s

sfdx force:source:push

sfdx force:org:open

echo "Org is set up"