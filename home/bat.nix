{ config, ... }:
{
  programs.bat = {
    enable = true;

    config = {
      theme = if config.me.dark-mode then "Monokai Extended" else "GitHub";
      style = "plain";
    };
  };
}
