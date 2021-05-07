let
  pkgs = import ./nixpkgs.nix { };
  containerHost = "10.0.0.1";
  apiContainer = "10.0.0.2";
in
{
  networking.firewall.enable = false;

  services.nginx = {
    enable = true;

    virtualHosts."maptogether.sebba.dk" = {
      default = true;
      forceSSL = true;
      enableACME = true;

      locations = {
        "/".return = "200 'Welcome to MapTogether\n'";
        "/api".extraConfig = ''
          rewrite ^/api/(.*) /$1 break;
          proxy_pass http://${apiContainer}:8080;
        '';
      };
    };
  };

  containers = {
    apiServer = {
      config = import ./api-server.nix { testing = true; } { inherit pkgs; };
      autoStart = true;
      privateNetwork = true;
      hostAddress = containerHost;
      localAddress = apiContainer;
    };
  };
}
