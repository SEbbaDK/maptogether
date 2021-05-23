let
  pkgs = import ./nixpkgs.nix { };
  apiPort = 3000;
in
{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

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
          proxy_pass http://localhost:${builtins.toString apiPort};
        '';
      };
    };
  };

  containers.api = {
    config = import ./api-server.nix { port = apiPort; inherit pkgs; };
    autoStart = true;
    ephemeral = true;
  };
}
