{ ... }: {
  flake.nixosModules.apps-terminal = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      # Terminal (niri lo lanza con Mod+Return)
      kitty
    ];
  };
}
