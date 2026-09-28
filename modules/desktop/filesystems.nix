{ ... }: {
  flake.nixosModules.desktop-filesystems = { pkgs, ... }: {
    # Necesario para que Nautilus vea los dispositivos montados
    services.gvfs.enable = true;
    services.upower.enable = true;

    environment.systemPackages = with pkgs; [
      # Gestor de archivos
      nautilus
      # Automontar pendrives
      udiskie
    ];
  };
}
