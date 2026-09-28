{ ... }: {
  flake.nixosModules.apps-productivity = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      # Suite ofimática
      libreoffice
      # Gestor de tareas
      planify
      # Gestor de contraseñas
      keepassxc
      # Lector de PDF
      zathura
    ];
  };
}
