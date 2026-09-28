{ ... }: {
  flake.nixosModules.desktop-sddm = { pkgs, ... }: {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "catppuccin-mocha-mauve";
      package = pkgs.kdePackages.sddm;
    };

    environment.systemPackages = with pkgs; [
      (catppuccin-sddm.override {
        flavor = "mocha";
        font = "JetBrainsMono Nerd Font";
        fontSize = "10";
      })
    ];
  };
}
