#!/bin/sh

# Run this BEFORE running ApexDox so all your files are set up properly.
# Run it from the repository root, for example with `npm run docs:setup`.

# Stop at the first failure instead of leaving a half-written page behind
set -eu

MAIN="doc-assets/main.html"
CHANGELOG="doc-assets/changelog.html"

printf '<link href="assets/styling.css" rel="stylesheet" />\n\n\n' > "$MAIN"

npx marked -i README.md --gfm >> "$MAIN"

# `sed -i.bak` works with both BSD (macOS) and GNU (Linux) sed. Only the links and images ApexDox needs are rewritten.
sed -i.bak \
  -e 's|<table>|<table class="methodtable">|g' \
  -e 's|src="\(\./\)\{0,1\}media/|src="\1assets/|g' \
  -e 's|href="\(\./\)\{0,1\}media/|href="\1assets/|g' \
  -e 's|href="\(\./\)\{0,1\}CHANGELOG\.md\([#"]\)|href="\1changelog.html\2|g' \
  "$MAIN"
rm -f "$MAIN.bak"

#csplit -s  "doc-assets/main.html" "/<h2>Most Common Methods</h2>/"
#mv xx00 "doc-assets/main.html"
#cat doc-assets/methodstable.html >> "doc-assets/main.html"
#rm xx*

printf '<link href="assets/styling.css" rel="stylesheet" />' > "$CHANGELOG"
npx marked -i CHANGELOG.md --gfm >> "$CHANGELOG"

npm run updateHighlight
