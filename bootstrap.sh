#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/joebruchalski/macapps/raw/main"

PACKAGES=(
  btop
  inxi
  nmap
  mtr
  iperf3
  netcat
  arp-scan
  tree
  fzf
  iproute2mac
  fastfetch
)

if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"

brew install "${PACKAGES[@]}"

"$(brew --prefix fzf)/install" --all --no-bash --no-fish --no-update-rc

mkdir -p "$HOME/.config/fastfetch"
curl -fsSL "$REPO_URL/files/fastfetch-config.jsonc" -o "$HOME/.config/fastfetch/config.jsonc"

ZSHRC="$HOME/.zshrc"
touch "$ZSHRC"

# clean up an old ansible-managed banner block from a previous version of this script
if grep -q "BEGIN ANSIBLE MANAGED BLOCK - fastfetch banner" "$ZSHRC"; then
  sed -i '' '/# BEGIN ANSIBLE MANAGED BLOCK - fastfetch banner/,/# END ANSIBLE MANAGED BLOCK - fastfetch banner/d' "$ZSHRC"
fi

MARKER="# macapps: fastfetch banner"
if ! grep -qF "$MARKER" "$ZSHRC"; then
  cat >> "$ZSHRC" <<EOF

$MARKER
if [[ \$- == *i* ]] && command -v fastfetch >/dev/null 2>&1; then
  fastfetch
fi
EOF
fi

ALIAS_MARKER="# macapps: aliases"
if grep -qF "$ALIAS_MARKER" "$ZSHRC"; then
  sed -i '' '/^# macapps: aliases$/,/^alias ll=/d' "$ZSHRC"
fi
cat >> "$ZSHRC" <<EOF

$ALIAS_MARKER
alias cls='clear && fastfetch'
alias ll='ls -asl'
EOF

echo "Done. Open a new terminal tab to see the banner."
