#!/usr/bin/env bash
# Pull the AIMD bootcamp modules into static/learn/bootcamp/ so `hugo server`
# serves them locally. CI also calls this script (see .github/workflows/hugo.yaml).
set -euo pipefail

REPO_URL="${BOOTCAMP_REPO_URL:-https://github.com/NeuroTechHub/AIMD_bootcamp.git}"
DEST="static/learn/bootcamp"
TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

git clone --depth 1 "$REPO_URL" "$TMPDIR/aimd-bootcamp"
rm -rf "$DEST"
mkdir -p "$DEST"
cp -R "$TMPDIR/aimd-bootcamp/modules/." "$DEST/"

# The bootcamp modules are standalone HTML served from static/, so they bypass
# Hugo templating and never see the site nav. Inject a small "← NeuroTechHub /
# Learn" breadcrumb at the top of every page so visitors have an obvious way
# out. Fallback hex colors mirror _shared.css so the strip also looks right if
# upstream ever drops those CSS variables.
SNIPPET="$TMPDIR/breadcrumb.html"
cat > "$SNIPPET" <<'HTML'
<nav class="nth-breadcrumb" aria-label="Site navigation"><a href="/">← NeuroTechHub</a><span aria-hidden="true">/</span><a href="/learn/">Learn</a></nav>
<style>
.nth-breadcrumb{padding:10px 24px;background:var(--paper-2,#f8f8f6);border-bottom:1px solid var(--rule,#d8d6cf);font-family:ui-monospace,SFMono-Regular,Menlo,Monaco,Consolas,monospace;font-size:12px;text-transform:uppercase;letter-spacing:0.05em}
.nth-breadcrumb a{color:var(--ink-2,#3a3a36);text-decoration:none;border-bottom:1px solid transparent}
.nth-breadcrumb a:hover{color:var(--accent-2,#a83f63);border-bottom-color:var(--accent-2,#a83f63)}
.nth-breadcrumb span{margin:0 8px;color:var(--muted-2,#9a9a93)}
</style>
HTML

for f in "$DEST"/*.html; do
  awk -v snippet_file="$SNIPPET" '
    BEGIN { while ((getline line < snippet_file) > 0) snippet = snippet line "\n" }
    /<body>/ && !inserted { print; printf "%s", snippet; inserted = 1; next }
    { print }
  ' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
done

echo "Synced bootcamp modules to $DEST"
