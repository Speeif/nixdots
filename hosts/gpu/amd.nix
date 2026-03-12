{ ... }:
{
  flake.nixosModules."gpu-amd" =
    { pkgs, ... }:
    {
      boot.kernelParams = [
        "amdgpu.dc=1"
        "video=HDMI-A-1:1920x1080@60"
      ];
      # fix 2
      systemd.services.display-manager.serviceConfig.ExecStartPre = [
        "${pkgs.coreutils}/bin/sleep 2"
      ];

      # fix #3
      boot.initrd.kernelModules = [ "amdgpu" ];
      services.xserver.videoDrivers = [ "amdgpu" ];

      # fix #4
      # boot.kernelParams = [
      #   "amdgpu.audio=0"
      # ];
    };
}
