{ pkgs ? import ./nixpkgs.nix { }
, port ? 3000
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
  databaseSetup = ./server/database/create-role-and-database.sql;
  tableSetup = pkgs.writeText "setup.sql" ''
    ${builtins.readFile ./server/database/create-tables.sql}
    ${builtins.readFile ./server/database/create-materialized-views.sql}
    ${mockData}
  '';
in
{
  networking.hostName = "maptogether-api-server";
  networking.firewall.allowedTCPPorts = [ port ];

  services.postgresql = {
    enable = true;
    # ensureUsers = [{
    #   name = "maptogether";
    #   ensurePermissions = { "DATABASE maptogether" = "ALL PRIVILEGES"; };
    # }];
    # initialScript = ./server/database/create-role-and-database.sql;
  };

  systemd.services.maptogether-database-setup = {
    serviceConfig = {
      Type = "oneshot";
      User = "postgres";
      Group = "postgres";
      ExecStart = "${pkgs.postgresql}/bin/psql -f ${databaseSetup}";
    };
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };

  systemd.services.maptogether-table-setup = {
    serviceConfig = {
      Type = "oneshot";
      User = "maptogether";
      Group = "maptogether";
      ExecStart = "${pkgs.postgresql}/bin/psql -d maptogether -f ${tableSetup}";
    };
    requires = [ "maptogether-database-setup.service" "postgresql.service" ];
    after = [ "maptogether-database-setup.service" "postgresql.service" ];
  };

  systemd.services.maptogether-server = {
    description = "MapTogether Server";
    serviceConfig = {
      ExecStart = "${maptogether-server}/bin/maptogether-server ${builtins.toString port}";
      User = "maptogether";
      Group = "maptogether";
    };
    requires = [ "maptogether-database-setup.service" "maptogether-table-setup.service" "postgresql.service" ];
    after = [ "maptogether-database-setup.service" "maptogether-table-setup.service" "postgresql.service" ];
    wantedBy = [ "default.target" ];
  };

  systemd.services.maptogether-refresh-views = {
    description = "Refresh the MapTogether views";
    serviceConfig = {
      Type = "oneshot";
      User = "maptogether";
      Group = "maptogether";
      ExecStart = "${pkgs.postgresql}/bin/psql -d maptogether -f ${./server/database/refresh-materialized-views.sql}";
    };
    requires = [ "maptogether-database-setup.service" "postgresql.service" ];
    after = [ "maptogether-database-setup.service" "postgresql.service" ];
    wantedBy = [ "default.target" ];
  };

  systemd.timers.maptogether-refresh-views = {
	description = "Timer to trigger refresh";
	timerConfig.OnCalendar = "*:*:0"; # once a minute
	wantedBy = [ "timers.target" ];
  };

  users.groups.maptogether.gid = 1005;
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

