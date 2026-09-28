{ ... }: {
  flake.nixosModules.core-nix = { pkgs, ... }: {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    # Permite ejecutar binarios dinámicos genéricos (Mason, npm, etc.)
    programs.nix-ld.enable = true;

    nixpkgs.config.allowUnfree = true;
  };
}
