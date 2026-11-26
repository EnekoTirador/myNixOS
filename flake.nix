{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";

    # Home Manager: gestiona la configuración del usuario (~/.config, dotfiles...)
    # Rama master = la que va con nixos-unstable.
    home-manager = {
      url = "github:nix-community/home-manager";
      # Usa el MISMO nixpkgs que el sistema (no descarga otro distinto)
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake
    {inherit inputs;}
    (inputs.import-tree ./modules);
}
