{ ... }: {
  flake.nixosModules.apps-browsers = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      firefox
    ];
  };
}
