#!/usr/bin/env bash
# Pull the AIMD bootcamp modules into static/learn/bootcamp/ so `hugo server`
# serves them locally. CI does the same step in .github/workflows/hugo.yaml.
set -euo pipefail

REPO_URL="${BOOTCAMP_REPO_URL:-https://github.com/NeuroTechHub/AIMD_bootcamp.git}"
DEST="static/learn/bootcamp"
TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

git clone --depth 1 "$REPO_URL" "$TMPDIR/aimd-bootcamp"
rm -rf "$DEST"
mkdir -p "$DEST"
cp -R "$TMPDIR/aimd-bootcamp/modules/." "$DEST/"

echo "Synced bootcamp modules to $DEST"
