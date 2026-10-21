{ ... }: {
  flake.nixosModules.apps-terminal = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      # Terminal (niri lo lanza con Mod+Return)
      kitty
      # Diseño de prompt
      starship
    ];

    # Zsh
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };
  };
}
