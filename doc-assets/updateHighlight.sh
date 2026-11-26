#!/bin/sh

# Rebuild doc-assets/highlight.js from the highlight.js core and the Apex grammar.
# Run it from the repository root, for example with `npm run updateHighlight`.

# Stop at the first failure, and build in a temporary file so a failed download never replaces the real bundle
set -eu

TARGET="doc-assets/highlight.js"
TMP="$TARGET.tmp"
trap 'rm -f "$TMP"' EXIT

FILE=node_modules/@highlightjs/cdn-assets/highlight.min.js
if test -f "$FILE"; then
  cat node_modules/@highlightjs/cdn-assets/highlight.min.js > "$TMP"
  printf '\n\n' >> "$TMP"
  cat node_modules/highlightjs-apex/dist/apex.min.js >> "$TMP"
else
  # -f makes curl fail on an HTTP error instead of saving the error page as JavaScript
  curl -fL "https://cdn.jsdelivr.net/gh/highlightjs/cdn-release/build/highlight.min.js" -o "$TMP"
  printf '\n' >> "$TMP"
  curl -fL "https://cdn.jsdelivr.net/npm/highlightjs-apex/dist/apex.min.js" >> "$TMP"
fi

mv "$TMP" "$TARGET"
