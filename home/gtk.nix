{ pkgs, ... }:
{
  gtk = {
    enable = true;

    theme = {
      name = "palenight";
      package = pkgs.palenight-theme;
    };

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  home.sessionVariables.GTK_THEME = "palenight";
}
