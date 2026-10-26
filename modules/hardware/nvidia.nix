{ ... }: {
  flake.nixosModules.hardware-nvidia = { config, ... }: {
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;
    hardware.nvidia = {
      modesetting.enable = true;
      open = true;  # false si la gráfica es anterior a la serie GTX 16xx / RTX 20xx
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
