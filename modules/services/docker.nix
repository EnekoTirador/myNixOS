{ ... }: {
  flake.nixosModules.service-docker = { pkgs, ... }: {
    virtualisation.docker.enable = true;

    environment.systemPackages = with pkgs; [
      docker
    ];
  };
}
