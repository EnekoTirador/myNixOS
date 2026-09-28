{ ... }: {
  flake.nixosModules.apps-communication = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      # Discord
      vesktop
      # Compartir archivos en red local
      localsend
    ];
  };
}
