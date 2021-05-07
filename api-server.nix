{ testing ? false }
{ pkgs ? import ./nixpkgs.nix { }
, ...
}:
let
  maptogether-server = import ./server { inherit pkgs; };
  mockData = ''
    ${builtins.readFile ./server/database/mock-users.sql}
    ${builtins.readFile ./server/database/mock-contributions.sql}
    ${builtins.readFile ./server/database/mock-achievements.sql}
    ${builtins.readFile ./server/database/mock-follows.sql}
  '';
  setupScript = pkgs.writeText "setup.sql" ''
    ${builtins.readFile ./server/database/create-tables.sql}
    ${if testing then mockData else ""}
  '';
in
{
  networking.firewall.allowedTCPPorts = [ 8080 ];
    
  services.postgresql = {
    enable = true;
    # ensureUsers = [{
    #   name = "maptogether";
    #   ensurePermissions = { "DATABASE maptogether" = "ALL PRIVILEGES"; };
    # }];
    initialScript = ./server/database/create-role-and-database.sql;
  };

  users.groups.maptogether = { };

  systemd.services.database-setup = {
    serviceConfig = {
      Type = "oneshot";
      User = "maptogether";
      Group = "maptogether";
      ExecStart = "${pkgs.postgresql}/bin/psql -d maptogether -f ${setupScript}";
    };
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };

  systemd.services.maptogether-server = {
    description = "MapTogether Server";
    serviceConfig = {
      ExecStart = "${maptogether-server}/bin/maptogether-server";
      User = "maptogether";
      Group = "maptogether";
    };
    requires = [ "database-setup.service" "postgresql.service" ];
    after = [ "database-setup.service" "postgresql.service" ];
    wantedBy = [ "default.target" ];
  };
  users.users.maptogether = {
      isSystemUser = true;
      extraGroups = [ "maptogether" ];
  };

  environment.systemPackages = with pkgs; [
    coreutils
    bash
  ];
  users.mutableUsers = false;
  users.users.test = {
    password = "test";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}

