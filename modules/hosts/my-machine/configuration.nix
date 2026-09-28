{ self, ... }: {
  flake.nixosModules.myMachineConfiguration = { ... }: {
    imports = [
      # Hardware de esta máquina
      self.nixosModules.myMachineHardware

      # Núcleo del sistema
      self.nixosModules.core-nix
      self.nixosModules.core-boot
      self.nixosModules.core-locale
      self.nixosModules.core-network

      # Escritorio
      self.nixosModules.niri
      self.nixosModules.desktop-sddm
      self.nixosModules.desktop-theming
      self.nixosModules.desktop-filesystems

      # Servicios
      self.nixosModules.service-docker

      # Usuario
      self.nixosModules.user-eko

      # Apps, por categoría
      self.nixosModules.apps-browsers
      self.nixosModules.apps-terminal
      self.nixosModules.apps-dev
      self.nixosModules.apps-media
      self.nixosModules.apps-productivity
      self.nixosModules.apps-communication
      self.nixosModules.apps-network
      self.nixosModules.apps-system-tools
      self.nixosModules.apps-cli-tools
    ];

    # Lo único realmente específico de este portátil
    networking.hostName = "EkoPortatil";
    system.stateVersion = "26.05";
  };
}
