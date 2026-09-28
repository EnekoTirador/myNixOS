{ ... }: {
  flake.nixosModules.apps-network = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      # Cliente torrent
      qbittorrent
    ];
  };
}
