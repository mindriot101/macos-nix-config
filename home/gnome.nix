{ ... }:
{
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Alt><Super>s";
      command = "sh -c 'wmctrl -x -a slack || slack'";
      name = "Slack";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Alt><Super>t";
      command = "sh -c 'wmctrl -x -a kitty || kitty'";
      name = "Terminal";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      binding = "<Alt><Super>c";
      command = "sh -c 'wmctrl -x -a chromium || chromium'";
      name = "Browser";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      binding = "<Alt><Super>e";
      command = "sh -c 'wmctrl -x -a obsidian || obsidian'";
      name = "Notes";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
      binding = "<Alt><Super>r";
      command = "sh -c 'wmctrl -x -a zeal || zeal'";
      name = "Documentation";
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
      ];
    };
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
      ];
      disabled-extensions = [ ];
    };
  };
}

