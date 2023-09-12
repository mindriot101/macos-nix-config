{ pkgs, lib, config, ... }:
let
  cfg = config.me.wm.hyprland;
in
{
  options.me.wm.hyprland.enable = lib.mkEnableOption (lib.mkDoc "Enable Hyprland window manager");

  config = lib.mkIf cfg.enable {
    services.xserver.displayManager.gdm.wayland = true;
    programs.hyprland = {
      enable = true;
    };
    programs.xwayland.enable = true;
    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
    };
    environment.systemPackages = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
      waybar
      dunst
      wofi
      hyprpaper
    ];
    services.xserver.displayManager.defaultSession = "hyprland";
    services.xserver.displayManager.gdm.enable = false;
    services.xserver.displayManager.sddm.enable = true;
  };
}
