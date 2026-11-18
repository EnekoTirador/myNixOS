{ self, inputs, ... }: {

  perSystem = { pkgs, ... }: {

    packages.myNoctalia = inputs.wrapper-modules.wrappers.noctalia.wrap {
      inherit pkgs;
      settings = { };
    };
  };
}
