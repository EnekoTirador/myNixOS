{ ... }: {
  flake.nixosModules.apps-media = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      # Reproductor multimedia
      celluloid
      # Visor de imágenes
      imv
      # Grabar pantalla
      obs-studio
      # Sonidos ambientales
      blanket
    ];
  };
}
