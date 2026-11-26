# Git gestionado por Home Manager → genera ~/.config/git/config
# (sustituye a ~/.gitconfig, que se aparta a ~/.gitconfig.old)
{ ... }: {
  flake.nixosModules.home-eko = { ... }: {
    home-manager.users.eko = { ... }: {
      programs.git = {
        enable = true;
        settings = {
          user.name = "Eneko Tirador";
          user.email = "enekotiradorales@gmail.com";
          # El token de GitHub sigue en ~/.git-credentials (no se toca)
          credential.helper = "store";
          pull.rebase = false;
        };
      };
    };
  };
}
