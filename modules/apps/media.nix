{ ... }: {
  flake.nixosModules.apps-media = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      # Reproductor multimedia
      mpv
      # Visor de imágenes
      imv
      # Grabar pantalla
      obs-studio
      # Sonidos ambientales
      blanket
    ];
  };
}
