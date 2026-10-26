{ self, inputs, ... }: {
  flake.nixosConfigurations.sobremesa = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.sobremesaConfiguration
    ];
  };
}
