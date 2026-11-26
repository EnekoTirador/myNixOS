# Scripts propios en ~/.local/bin (niri los llama con Shift+Print y Mod+Ctrl+S)
{ ... }: {
  flake.nixosModules.home-eko = { ... }: {
    home-manager.users.eko = { ... }: {
      home.file.".local/bin/screenshot-clipboard.sh" = {
        source = ./files/screenshot-clipboard.sh;
        executable = true;
      };
    };
  };
}
