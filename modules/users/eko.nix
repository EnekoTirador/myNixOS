{ ... }: {
  flake.nixosModules.user-eko = { pkgs, ... }: {
    users.users."eko" = {
      isNormalUser = true;
      description = "Eneko Tirador";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
      ];
      packages = with pkgs; [ ];
    };
  };
}
