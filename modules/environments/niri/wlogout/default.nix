{self, ...}: let
  moduleName = "wlogout";
in {
  perSystem = {pkgs, ...}: {
    packages."${moduleName}" =
      (self.wrapperModules."${moduleName}".apply {
        inherit pkgs;
        margin = 100;
      }).wrapper;
  };
}
