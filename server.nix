{ pkgs ? import <nixpkgs> { }
, mockData ? false
, ...
}:
let
  maptogether-server = import ./server { inherit pkgs; };
  setup-script = pkgs.writeText "setup.sql" ''
  	${builtins.readFile ./server/database/create-tables.sql}
  	${builtins.readFile ./server/database/mock-users.sql}
  	${builtins.readFile ./server/database/mock-contributions.sql}
  	${builtins.readFile ./server/database/mock-achievements.sql}
  	${builtins.readFile ./server/database/mock-follows.sql}
  '';
in
{
  services.postgresql = {
    enable = true;
    # ensureUsers = [{
    #   name = "maptogether";
    #   ensurePermissions = { "DATABASE maptogether" = "ALL PRIVILEGES"; };
    # }];
    initialScript = ./server/database/create-role-and-database.sql;
  };

  users.groups.maptogether.gid = 1001;

  systemd.services.database-setup = {
    serviceConfig = {
      Type = "oneshot";
      User = "maptogether";
      Group = "maptogether";
      ExecStart = "${pkgs.postgresql}/bin/psql -d maptogether -f ${setup-script}";
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
  users.users.maptogether.extraGroups = [ "maptogether" ];

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

