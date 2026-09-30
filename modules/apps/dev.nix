{ ... }: {
  flake.nixosModules.apps-dev = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      # Texto
      vim
      # LSP para vim
      python3
      pyright
      bash-language-server
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
