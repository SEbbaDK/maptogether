let
  nixospkgs = builtins.tryEval <nixpkgs>;
  gitpkgs = fetchTarball "https://github.com/nixos/nixpkgs/archive/d9448c95c5d557d0b2e8bfe13e8865e4b1e3943f.tar.gz";
in
  import (if nixospkgs.success then nixospkgs.value else gitpkgs)

