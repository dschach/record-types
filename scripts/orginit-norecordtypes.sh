#!/bin/bash

echo "Cleaning previous scratch org..."
sf org delete scratch --no-prompt --target-org RecordTypes

echo "Creating new scratch org"
sf org create scratch --definition-file config/no-rt-scratch-def.json --duration-days 10 --alias RecordTypes --set-default

echo "Pushing metadata"
sf project deploy start

echo "Running Apex tests"
sf apex run test --code-coverage --result-format human --test-level RunLocalTests --wait 20

echo "Opening org"
sf org open

echo "Org is set up"