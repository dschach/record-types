# BLANK scratch org

echo "Delete old blank org"
sf org delete scratch --no-prompt --target-org BlankOrg

echo "Creating new scratch org"
sf org create scratch --definition-file config/no-rt-scratch-def.json --alias BlankOrg --no-namespace --duration-days 7 --no-ancestors --wait 20

echo "opening org"
sf org open --target-org BlankOrg

# extra commands

#sf package install  --target-org BlankOrg --wait 90 --package ###
#sf project deploy start --manifest sfdx-source/unpackaged-managed/manifest.xml --target-org BlankOrg --wait 90 --post-destructive-changes sfdx-source/unpackaged-managed/destructiveChangesPost.xml
#sf project deploy start --source-dir sfdx-source/unpackaged --target-org BlankOrg --wait 90 --ignore-errors --ignore-warnings
#sf org assign permset --name QuoteSyncTester