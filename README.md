# NixOS Flake

Forked from ozwaldorf's flake and mostly the same.

## Usage

Install the system and reboot (x86_64-linux):

```sh
git clone https://github.com/qti3e/flake && cd flake

# copy your hardware config in
cp /etc/nixos/hardware-configuration.nix system

# build and reboot
sudo nixos-rebuild switch --upgrade-all --flake . && reboot
```

Run standalone neovim:

```sh
nix run github:qti3e/flake\#neovim
```

Dev environment:

```sh
nix run github:qti3e/flake
```

## Cache

Binary caches are provided via https://garnix.io
