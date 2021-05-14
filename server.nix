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
        "/login".extraConfig = ''
        	add_header Content-Type text/html;
			return 200 'You should now be logged in. The browser should close shortly.';
        '';
        "/api".extraConfig = ''
          rewrite ^/api/(.*) /$1 break;
          proxy_pass http://${apiContainer}:8080;
        '';
      };
    };
  };

  containers = {
    api = {
      config = import ./api-server.nix { inherit pkgs; };
      autoStart = true;
      privateNetwork = true;
      hostAddress = containerHost;
      localAddress = apiContainer;
    };
  };
}
