# YubiKey setup

Two YubiKey 5C NFC keys, set up identically. Either one alone must be able to do everything.

| Name      | Serial        | Where it lives        |
|-----------|---------------|-----------------------|
| `keyring` | `<SERIAL>`    | on my keys, daily use |
| `home`    | `<SERIAL>`    | at home, backup       |

Serials are also in `home/.chezmoidata/yubikeys.toml` (used by `~/.ssh/config`).

Rule: **every time something is enrolled, enroll both keys.**

## What lives where

The key has independent applications, each with its own secret and PIN. Resetting one doesn't touch the others.

| Application | Used for                                  | Protected by                         | Managed with                        |
|-------------|-------------------------------------------|--------------------------------------|-------------------------------------|
| FIDO2       | Passkeys, WebAuthn 2FA, SSH (`ed25519-sk`) | FIDO2 PIN                            | Yubico Authenticator → Passkeys, `ykman fido` |
| OATH        | TOTP codes ("Accounts")                    | optional OATH password               | Yubico Authenticator → Accounts     |
| PIV         | age encryption (retired slots)             | PIV PIN, PUK, management key (PIN-protected, TDES) | `ykman piv`, `age-plugin-yubikey` |

Secrets:
- **FIDO2 PIN**: memorized
- **PIV PIN**: memorized
- **PIV PUK**: Bitwarden
- **PIV management key**: random, stored on the key behind the PIV PIN (`--protect`), not stored anywhere else

## Packages

Installed by `chezmoi apply` on machines that answered yes to "Use YubiKeys"
(see `home/.chezmoiscripts/`). By hand on CachyOS / Arch:
```
sudo pacman -S yubikey-manager age age-plugin-yubikey pcsclite ccid libfido2
sudo systemctl enable --now pcscd.socket
```
On Ubuntu, `yubikey-manager pcscd libfido2-1` come from apt and `age` /
`age-plugin-yubikey` from mise.

- SSH (FIDO2) only needs `libfido2`; it talks USB HID, not PC/SC.
- age (PIV) needs `age-plugin-yubikey` + `pcscd`.
- If PIV commands can't see the key: `gpgconf --kill scdaemon`.

## SSH

Keys (resident, PIN + touch on every use, no passphrase):
```
ssh-keygen -t ed25519-sk -O resident -O verify-required -O application=ssh:keyring -C "yk-keyring" -f ~/.ssh/id_yk_keyring
ssh-keygen -t ed25519-sk -O resident -O verify-required -O application=ssh:home    -C "yk-home"    -f ~/.ssh/id_yk_home
```

`~/.ssh/id_yk_*` are handles, not secrets. The private key never leaves the
YubiKey. Because the keys are resident, the handles are not kept in this repo:
`yk-ssh-handles.sh` (in `~/.config/scripts`) pulls them off a plugged-in key.

`~/.ssh/config` is managed by chezmoi (`home/private_dot_ssh/private_config.tmpl`).
Defaults at the bottom of the file:
```
Host *
  IdentitiesOnly yes
  IdentityAgent none
  ControlMaster auto
  ControlPath ~/.ssh/cm-%C
  ControlPersist 10m

Match exec "ykman list --serials | grep -qx <KEYRING_SERIAL>"
  IdentityFile ~/.ssh/id_yk_keyring

Match exec "ykman list --serials | grep -qx <HOME_SERIAL>"
  IdentityFile ~/.ssh/id_yk_home
```

- `IdentityAgent none`: ssh-agent can't prompt for the FIDO2 PIN, so ssh does it directly.
- `Match exec`: picks the handle for whichever key is plugged in, so only one PIN prompt and one touch.
- `ControlPersist`: one touch per host per 10 min. Sessions keep working after unplugging the key until the master dies.

Useful:
```
ssh -O check <host>     # master running?
ssh -O exit <host>      # kill master (needed to test a fresh login)
for s in ~/.ssh/cm-*; do ssh -o ControlPath="$s" -O exit _ 2>/dev/null; done   # kill all
```

Jumping between hosts: use `ProxyJump` (`ssh -J jumpbox target`), not agent forwarding.

### Where the SSH keys are installed

Both public keys must be on each host.

| Host        | Address           | User    |
|-------------|-------------------|---------|
| proxmox     | 192.168.128.200   | root    |
| infra-svc   | 192.168.128.201   | root    |
| jumpbox     | 192.168.128.210   | root    |
| ops         | 192.168.129.11    | aleix   |
| GitHub      | github.com        | git     |

Install on a new host (one `-i` per call):
```
for k in keyring home; do ssh-copy-id -i ~/.ssh/id_yk_$k.pub <host>; done
```

Test each key separately:
```
ssh -O exit <host> 2>/dev/null; ssh -v <host> 2>&1 | grep -E 'Offering|Authenticated'
```

After both keys work on a host, sshd should have:
```
PasswordAuthentication no
PermitRootLogin prohibit-password
```
Break-glass access: Proxmox web console.

### My own machines (authorized_keys)

Machines that answered yes to "Accept SSH logins" get `~/.ssh/authorized_keys`
from `https://github.com/aleixab.keys`, filtered to `sk-*` keys only, on every
`chezmoi apply`. So the GitHub account is the source of truth: removing a key
there and re-applying revokes it. Hand-added keys in that file are overwritten.

### Git commit signing (optional)

```
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_yk_keyring.pub
git config --global commit.gpgsign true
```
Add both public keys on GitHub a second time as *Signing key*.

## age (file / secret encryption)

One age identity per key, in a retired PIV slot. PIN policy `once`, touch policy `always`.

Setup per key:
```
age-plugin-yubikey          # interactive: name age-yk-<name>, PIN once, touch always
```
If it complains about the management key:
```
ykman piv access change-management-key --generate --protect -a TDES
```

Files (not secret), managed by chezmoi:
```
~/.config/age/recipients.txt   # public keys, from: age-plugin-yubikey --list   (append per key)
~/.config/age/yubikeys.txt     # identity stubs, from: age-plugin-yubikey --identity (append per key)
```
`recipients.txt` must contain only `#` comments and bare `age1yubikey1...` lines.

chezmoi is configured to use these for `chezmoi add --encrypt` (every decrypt
on `apply`/`diff` needs PIN + touch, so only encrypt what really is secret).

Encrypt (no key needed, only recipients). Paste secret, Ctrl-D:
```
age -a -R ~/.config/age/recipients.txt
age -a -R ~/.config/age/recipients.txt | xclip -sel clip
```

Decrypt (needs a key, PIN, touch):
```
xclip -o -sel clip | age -d -i ~/.config/age/yubikeys.txt
age -d -i ~/.config/age/yubikeys.txt file.age
```

Flags: `-R`/`-r` encrypt to recipients, `-a` armored text output, `-d` decrypt, `-i` identity file, `-o` output file.

Avoid plaintext files on disk and `echo secret | age` (shell history).

Encrypted backup codes (except the ones below) are stored as secure notes in Bitwarden.

## Services enrolled

| Service    | How                                | keyring | home |
|------------|------------------------------------|---------|------|
| Google     | passkey                            | ✅      | ✅   |
| Bitwarden  | 2FA (FIDO2)                        | ✅      | ✅   |
| Bitwarden  | log in with passkey (needs PRF)    | ☐       | ☐    |
| GitHub     | SSH auth key                       | ☐       | ☐    |

Update this table every time something is enrolled.

Notes:
- Bitwarden "log in with passkey" fails from Chrome on Android. Do it from a desktop browser, or try the YubiKey Passkey Enabler app.
- Failed passkey registrations leave orphan credentials on the key. Check with `ykman fido credentials list`.

## Recovery

**Paper only** (anything behind the YubiKeys is unreachable if both are lost):
- Bitwarden recovery code
- Google backup codes
- printout of this section

### New machine
1. `chezmoi init aleixab/config`, answer yes to "Use YubiKeys", then `chezmoi apply`.
   This installs the packages and writes `~/.ssh/config` and `~/.config/age/*`.
2. SSH: plug in each key in turn and run `yk-ssh-handles.sh`.
3. Check: `ssh -O exit proxmox 2>/dev/null; ssh -v proxmox 2>&1 | grep -E 'Offering|Authenticated'`

### Lost one key
1. Remove its SSH public key from every host in the table above and from GitHub.
2. Remove it from every service in the "Services enrolled" table.
3. Get a replacement key, set it up from this doc, enroll it everywhere.
4. Update its serial in `home/.chezmoidata/yubikeys.toml`.
5. Update `recipients.txt` / `yubikeys.txt` and re-encrypt every age blob
   (chezmoi-encrypted files too: `chezmoi add --encrypt <file>` again once the new recipients are applied).

### Adding a third key
Same as replacing: set up, enroll everywhere, add it to `home/.chezmoidata/yubikeys.toml`,
`recipients.txt` and `yubikeys.txt`, re-encrypt every age blob.

### Lost both keys
Bitwarden recovery code → Bitwarden. Google backup codes → Google. Proxmox web console → hosts. Then start over from this doc.
