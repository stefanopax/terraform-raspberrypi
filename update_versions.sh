#!/usr/bin/env bash
# update_versions.sh
# Fetches the latest stable version for each Docker image and updates variables.tf
# Run from the terraform directory: ./update_versions.sh

set -euo pipefail

VARIABLES_FILE="${1:-variables.tf}"

if [[ ! -f "$VARIABLES_FILE" ]]; then
  echo "ERROR: $VARIABLES_FILE not found. Run this script from your terraform directory."
  exit 1
fi

# ── Helpers ─────────────────────────────────────────────────────────────────

# Fetch latest tag from Docker Hub matching a semver-like pattern (e.g. 1.2.3)
# Usage: dockerhub_latest <namespace/image> [tag_regex]
dockerhub_latest() {
  local image="$1"
  local regex="${2:-^[0-9]+\.[0-9]+\.[0-9]+$}"
  local url="https://hub.docker.com/v2/repositories/${image}/tags?page_size=100&ordering=last_updated"

  curl -fsSL "$url" \
    | python3 -c "
import sys, json, re
data = json.load(sys.stdin)
tags = [t['name'] for t in data.get('results', []) if re.match(r'${regex}', t['name'])]
print(tags[0] if tags else '')
"
}

# Fetch latest linuxserver image version via their GitHub releases
# Usage: linuxserver_latest <github_repo>  e.g. linuxserver/docker-plex
linuxserver_latest() {
  local repo="$1"
  local url="https://api.github.com/repos/${repo}/releases/latest"

  curl -fsSL "$url" \
    | python3 -c "
import sys, json, re
data = json.load(sys.stdin)
tag = data.get('tag_name', '')
# Strip leading 'v' or image-name prefix, keep semver part
match = re.search(r'([0-9]+\.[0-9]+\.[0-9]+)', tag)
print(match.group(1) if match else '')
"
}

# Update a variable's default value in variables.tf
# Usage: update_var <var_name> <new_version>
update_var() {
  local var_name="$1"
  local new_version="$2"

  if [[ -z "$new_version" ]]; then
    echo "  ⚠️  Could not determine version for $var_name — skipping"
    return
  fi

  # Extract current version for display
  local current
  current=$(grep -A5 "variable \"${var_name}\"" "$VARIABLES_FILE" \
    | grep 'default' | grep -oP '"[^"]+"' | tr -d '"' || echo "unknown")

  if [[ "$current" == "$new_version" ]]; then
    echo "  ✓  $var_name is already up to date ($current)"
    return
  fi

  # In-place replacement of the default value for this specific variable block
  python3 - "$VARIABLES_FILE" "$var_name" "$new_version" <<'PYEOF'
import sys, re

filepath, var_name, new_version = sys.argv[1], sys.argv[2], sys.argv[3]

with open(filepath, 'r') as f:
    content = f.read()

# Match the variable block and replace only its default value
pattern = r'(variable\s+"' + re.escape(var_name) + r'"[^}]*?default\s*=\s*)"[^"]*"'
replacement = r'\g<1>"' + new_version + '"'
new_content, count = re.subn(pattern, replacement, content, flags=re.DOTALL)

if count == 0:
    print(f"  ⚠️  Pattern not matched for {var_name}")
    sys.exit(1)

with open(filepath, 'w') as f:
    f.write(new_content)
PYEOF

  echo "  ↑  $var_name: $current → $new_version"
}

# ── Version fetches ──────────────────────────────────────────────────────────

echo "Fetching latest stable versions..."
echo ""

echo "→ Plex (linuxserver/docker-plex)"
PLEX_VERSION=$(linuxserver_latest "linuxserver/docker-plex")

echo "→ qBittorrent (linuxserver/docker-qbittorrent)"
QBIT_VERSION=$(linuxserver_latest "linuxserver/docker-qbittorrent")

echo "→ Nextcloud (linuxserver/docker-nextcloud)"
NEXTCLOUD_VERSION=$(linuxserver_latest "linuxserver/docker-nextcloud")

echo "→ MariaDB (Docker Hub: mariadb)"
# Exclude release candidates and non-patch tags; pick latest x.y.z
MARIADB_VERSION=$(dockerhub_latest "library/mariadb" "^[0-9]+\.[0-9]+\.[0-9]+$")

echo ""
echo "Updating $VARIABLES_FILE..."
echo ""

update_var "plex_version"        "$PLEX_VERSION"
update_var "qbittorrent_version" "$QBIT_VERSION"
update_var "nextcloud_version"   "$NEXTCLOUD_VERSION"
update_var "mariadb_version"     "$MARIADB_VERSION"

echo ""
echo "Done. Review changes with: git diff $VARIABLES_FILE"
echo "Then run: terraform plan"
