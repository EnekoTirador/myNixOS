{ ... }: {
  flake.nixosModules.apps-system-tools = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      # Control de brillo
      brightnessctl
      # Portapapeles Wayland
      wl-clipboard
      # Captura de pantalla
      grim
      # Selección de área
      slurp
      # Anotar capturas
      swappy
      # Bloqueo de pantalla
      swaylock-effects
      # Monitor de sistema
      btop
      # Info del sistema
      fastfetch
      # Compresión de archivos
      p7zip
    ];
  };
}
