{ ... }:{
    flake.nixosModules.service-virtualisation = { ... }: {
        programs.virt-manager.enable = true;
        virtualisation.libvirtd = {
            enable = true;
            qemu.swtpm.enable = true;
        };
        virtualisation.spiceUSBRedirection.enable = true;
        users.users.eko.extraGroups = [ "libvirtd" ];
    };
}
