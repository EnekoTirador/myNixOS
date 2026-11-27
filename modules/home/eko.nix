# Configuración de Home Manager para el usuario eko.
# Aquí va todo lo que vive en /home/eko: programas de usuario y sus dotfiles.
{ ... }: {
  flake.nixosModules.home-eko = { ... }: {
    home-manager.users.eko = { pkgs, ... }: {
      # Versión de Home Manager con la que se creó esta config.
      # Igual que system.stateVersion: NO la cambies aunque actualices.
      home.stateVersion = "26.05";

      # Paquetes solo para tu usuario (de momento vacío; los de sistema
      # siguen en modules/apps/*.nix como hasta ahora)
      home.packages = with pkgs; [
        (pkgs.callPackage ./_pkgs/helium.nix {  })
      ];

      # ───────────────────────────────────────────────────────────────
      # Ejemplos para más adelante (están comentados a propósito).
      # Antes de activar uno, lee la guía: si ya tienes ese archivo en tu
      # home, Home Manager lo moverá a <archivo>.hm-backup y lo sustituirá.
      # ───────────────────────────────────────────────────────────────

      # Git → crea ~/.config/git/config
      # programs.git = {
      #   enable = true;
      #   settings.user.name = "Eneko Tirador";
      #   settings.user.email = "tu@email.com";
      # };

      # Starship → lo engancha a las shells que gestione Home Manager
      # (útil junto con programs.zsh.enable)
      # programs.starship.enable = true;

      # Zsh → REEMPLAZA tu ~/.zshrc (pasa antes lo que tengas en él aquí)
      # programs.zsh.enable = true;
    };
  };
}
