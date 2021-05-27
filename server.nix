let
  pkgs = import ./nixpkgs.nix { };
  apiPort = 3000;
  cacheDir = "/var/nginx-cache";
in
{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  systemd.services.mkcachedir = {
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      Group = "root";
      ExecStart = "/bin/sh -c 'rm -rf ${cacheDir} && mkdir ${cacheDir} && chown -R nginx:nginx ${cacheDir} && chmod +w ${cacheDir}'";
    };
    before = [ "nginx.service" ];
    wantedBy = [ "default.target" ];
  };

  systemd.services.nginx.serviceConfig.ReadWritePaths = [ "${cacheDir}" ];
  services.nginx = {
    enable = true;

    virtualHosts."maptogether.sebba.dk" = {
      default = true;
      forceSSL = true;
      enableACME = true;

      locations = {
        "/".return = "200 'Welcome to MapTogether\n'";
        "/login".extraConfig = ''
          default_type text/html;
          return 200 'You should now be logged in. The browser should close shortly.';
        '';
        "/api".extraConfig = ''
          rewrite ^/api/(.*) /$1 break;
          proxy_cache api_cache;
          proxy_ignore_headers Cache-Control;
          proxy_cache_valid any 30s;
          proxy_pass http://localhost:${builtins.toString apiPort};
        '';
      };
    };

    appendHttpConfig = ''
		proxy_cache_path ${cacheDir} levels=1:2 keys_zone=api_cache:2m max_size=1g inactive=60m use_temp_path=off;
    '';

    eventsConfig = ''
		worker_connections 50000;
    '';
  };

  containers.api = {
    config = import ./api-server.nix { port = apiPort; inherit pkgs; };
    autoStart = true;
    ephemeral = true;
  };
}
