#!/usr/bin/env bash
# Copies the code examples that the docsrc topics coderef from the HTML and specialization plug-in samples.
set -euo pipefail

cd "$(dirname "$0")"
HTML_DIR="${HTML_DIR:-../dita-bootstrap.html}"
SPEC_DIR="${SPEC_DIR:-../dita-bootstrap.dtd}"

for pair in "html:$HTML_DIR" "specialization:$SPEC_DIR"; do
  name="${pair%%:*}"
  src="${pair#*:}/sample/code"
  [ -d "$src" ] || { echo "Missing $src (set HTML_DIR / SPEC_DIR)" >&2; exit 1; }
  rm -rf "docsrc/code/$name"
  mkdir -p docsrc/code
  cp -R "$src" "docsrc/code/$name"
done
