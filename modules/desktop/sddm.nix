{ ... }: {
  flake.nixosModules.desktop-sddm = { pkgs, ... }: {
    services.xserver.enable = true;

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = false;
      theme = "sddm-astronaut-theme";
      package = pkgs.kdePackages.sddm;
      extraPackages = [
        (pkgs.sddm-astronaut.override {
          embeddedTheme = "black_hole";
        })
      ];
    };

    environment.systemPackages = with pkgs; [
      (sddm-astronaut.override {
        embeddedTheme = "black_hole";
      })
    ];
  };
}
