{ ... }: {
  flake.nixosModules.apps-dev = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      # Texto
      vim
      # Programar
      vscode
      # Compilador C/C++
      gcc
      # Git
      git
      # Menú git en la terminal
      lazygit
    ];
  };
}
