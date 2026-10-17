{ self, ... }: {
  flake.nixosModules.sobremesaConfiguration = { pkgs, lib, ... }: {
    imports = [
      # Hardware de esta máquina
      self.nixosModules.sobremesaHardware
      self.nixosModules.hardware-nvidia

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
      self.nixosModules.service-virtualisation

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
      self.nixosModules.apps-gaming
    ];

    # Kernel estable: el último puede ir por delante del driver de Nvidia
    boot.kernelPackages = lib.mkForce pkgs.linuxPackages;

    networking.hostName = "EkoSobremesa";
    fileSystems."/mnt/juegos" = {
      device = "/dev/disk/by-uuid/d00b3179-d9ea-435b-8d2b-5a0dccddeb0f";
      fsType = "btrfs";
      options = [ "nofail" ];
    };
    fileSystems."/mnt/vms" = {
      device = "/dev/disk/by-uuid/e3c9415c-b5aa-43a9-971f-2a4615489fcc";
      fsType = "ext4";
      options = [ "nofail" ];
    };
    system.stateVersion = "26.05";
  };
}
