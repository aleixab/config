#!/bin/bash
# Pull the resident SSH key handles off the plugged-in YubiKey into ~/.ssh
# as id_yk_<name>, matching the Match blocks in ~/.ssh/config.
# Run once per key (plug in one at a time). Asks for the FIDO2 PIN.

set -euo pipefail

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
cd "$tmp"

# Writes id_ed25519_sk_rk_<application without "ssh:"> (+ .pub)
ssh-keygen -K

for f in id_ed25519_sk_rk_*; do
  dest="$HOME/.ssh/id_yk_${f#id_ed25519_sk_rk_}"
  install -m 600 "$f" "$dest"
  echo "wrote $dest"
done
chmod 644 "$HOME"/.ssh/id_yk_*.pub
