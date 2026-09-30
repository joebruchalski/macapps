# mac-base-tools

A bootstrap script for setting up a base set of CLI tools on a new Mac.

## Run it

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/joebruchalski/macapps/main/bootstrap.sh)"
```

## What it does

`bootstrap.sh` gets a fresh Mac to a usable terminal setup in one shot, without needing Ansible or any other config management installed first:

- Installs Homebrew if it isn't already present.
- Installs a base set of CLI tools via `brew`: `btop`, `inxi`, `nmap`, `mtr`, `iperf3`, `netcat`, `arp-scan`, `tree`, `fzf`, `iproute2mac`, and `fastfetch`.
- Sets up `fzf` key bindings and fuzzy completion.
- Downloads a preconfigured `fastfetch` config (`files/fastfetch-config.jsonc`) to `~/.config/fastfetch/`, which shows OS/host info plus custom modules for pending Homebrew upgrades, running Docker containers, and running Multipass VMs.
- Adds a block to `~/.zshrc` so `fastfetch` prints automatically as a startup banner in new interactive shell sessions.
- Adds a couple of convenience aliases to `~/.zshrc`: `cls` (clear the screen and re-run the fastfetch banner) and `ll` (`ls -asl`).

The script is idempotent — it can be re-run safely. It marks the blocks it writes into `~/.zshrc` (`# macapps: fastfetch banner`, `# macapps: aliases`) and replaces them in place on subsequent runs instead of duplicating them, and it also cleans up a leftover Ansible-managed banner block from an older version of this setup.
