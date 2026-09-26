#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://raw.githubusercontent.com/joebruchalski/macapps/main"

if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"

if ! command -v ansible-playbook >/dev/null 2>&1; then
  brew install ansible
fi

WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT

mkdir -p "$WORKDIR/files"
curl -fsSL "$REPO_URL/ansible.cfg" -o "$WORKDIR/ansible.cfg"
curl -fsSL "$REPO_URL/playbook.yml" -o "$WORKDIR/playbook.yml"
curl -fsSL "$REPO_URL/requirements.yml" -o "$WORKDIR/requirements.yml"
curl -fsSL "$REPO_URL/files/fastfetch-config.jsonc" -o "$WORKDIR/files/fastfetch-config.jsonc"

cd "$WORKDIR"
ansible-galaxy collection install -r requirements.yml
ansible-playbook playbook.yml
