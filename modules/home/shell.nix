# Zsh + Starship gestionados por Home Manager.
# Genera ~/.zshrc y ~/.zshenv (tu ~/.zshrc anterior queda como ~/.zshrc.hm-backup).
# Autosugerencias, resaltado de sintaxis y autocompletado siguen viniendo del
# sistema (modules/apps/terminal.nix), igual que antes.
{ ... }: {
  flake.nixosModules.home-eko = { ... }: {
    home-manager.users.eko = { config, ... }: {
      programs.zsh = {
        enable = true;

        # Archivos en ~ (no en ~/.config/zsh) y el MISMO historial de siempre
        dotDir = config.home.homeDirectory;
        history.path = "${config.home.homeDirectory}/.zsh_history";

        # El sistema ya hace compinit; así no se repite
        enableCompletion = false;

        shellAliases = {
          l = "ls -l";
        };

        # Permite pegar comandos con comentarios (# ...)
        setOptions = [ "INTERACTIVE_COMMENTS" ];

        initContent = ''
          # rebuild: aplica la config del host en el que estés
          rebuild() {
            local h
            case "$(hostname)" in
              EkoSobremesa) h=sobremesa ;;
              EkoPortatil)  h=myMachine ;;
              *) echo "Host desconocido: $(hostname)"; return 1 ;;
            esac
            sudo nixos-rebuild switch --flake ~/myNixOS#"$h"
          }

          # Fastfetch al abrir la terminal (no dentro de nix-shell)
          [[ -z $IN_NIX_SHELL ]] && fastfetch

          # Saltos de palabras y borrado
          bindkey '^[[1;5D' backward-word      # Ctrl+←
          bindkey '^[[1;5C' forward-word       # Ctrl+→
          bindkey '^H' backward-kill-word      # Ctrl+Backspace
          bindkey '^[[3;5~' kill-word          # Ctrl+Supr
          WORDCHARS=''${WORDCHARS//[\/.-]/}
        '';
      };

      # Starship: Home Manager añade el "eval $(starship init zsh)" solo.
      # Tu archivo de siempre, copiado tal cual a modules/home/files/starship.toml
      programs.starship.enable = true;
      xdg.configFile."starship.toml".source = ./files/starship.toml;
    };
  };
}
