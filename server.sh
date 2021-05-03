#!/bin/sh
nixos-container destroy mts 
nixos-container create mts --config-file=server.nix
nixos-container start mts

