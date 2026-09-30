{ ... }: {
  flake.nixosModules.apps-cli-tools = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      # Ver files en formato tree
      tree
      # Descargar archivos
      wget
      curl
      # Visualizar archivos de programación
      bat
      # Unzip
      unzip
      # Búsqueda de texto en archivos
      ripgrep
      # Búsqueda de archivos
      fd
      # Buscador difuso
      fzf
    ];
  };
}
