{ ... }: {
  flake.nixosModules.desktop-theming = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      # Tema de cursor (lo usa niri.nix vía xcursor-theme)
      catppuccin-cursors.mochaMauve
      # Fuente con iconos, usada en kitty y en el resto del escritorio
      nerd-fonts.jetbrains-mono
    ];
  };
}
