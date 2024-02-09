#!/bin/sh

# Run this BEFORE running ApexDox so all your files are set up properly.

printf '<link href="assets/styling.css" rel="stylesheet" />' > "doc-assets/main.html"
echo >> "doc-assets/main.html"
echo "\n" >> "doc-assets/main.html"


npx marked -i README.md --gfm >> "doc-assets/main.html"
csplit -s  "doc-assets/main.html" "/<h2>Most Common Methods</h2>/"
mv xx00 "doc-assets/main.html"
cat doc-assets/methodstable.html >> "doc-assets/main.html"
rm xx*

printf '<link href="assets/styling.css" rel="stylesheet" />' > "doc-assets/changelog.html"
#echo >> "doc-assets/changelog.html"
npx marked -i CHANGELOG.md --gfm >> "doc-assets/changelog.html"
sed -i "" "s|CHANGELOG.md|changelog.html|" "doc-assets/main.html"
sed -i "" "s|media/|assets/|" "doc-assets/main.html"

npm run updateHighlight