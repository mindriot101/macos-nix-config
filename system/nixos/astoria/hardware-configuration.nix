# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  # enable nested virtualisation
  boot.extraModprobeConfig = "options kvm_intel nested=1";

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/9839d4de-00b0-4010-acb4-c506e97e9403";
      fsType = "ext4";
    };

  fileSystems."/boot/efi" =
    {
      device = "/dev/disk/by-uuid/DC84-18FB";
      fsType = "vfat";
    };
  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/893193eb-7680-48e9-a459-7af16e918548";
    fsType = "ext4";
    options = [ "rw" "user" "defaults" "noatime" ];
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/780f83aa-7f7c-4f77-bc7c-b0c173fc57d1"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };
    bluetooth.enable = true;
  };
}
