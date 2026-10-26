{ ... }: {
  flake.nixosModules.apps-gaming = { pkgs, ... }: {
    programs.steam.enable = true;

    # Optimiza CPU/GPU mientras juegas (se activa por juego)
    programs.gamemode.enable = true;

    # Compositor anidado, útil para aislar un juego en un monitor
    programs.gamescope.enable = true;

    environment.systemPackages = with pkgs; [
      # Necesario para que niri ejecute apps X11 (Steam, Proton)
      xwayland-satellite
      # Overlay con FPS, temperaturas y uso de GPU
      mangohud
      # Audio
      pulseaudio
    ];
  };
}
