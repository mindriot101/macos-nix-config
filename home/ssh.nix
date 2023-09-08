{ ... }:
{
  programs.ssh = {
    enable = true;
    includes = [
      "config_local"
    ];
    matchBlocks = {
      "*" = {
        sendEnv = [ "TMUX_DISABLED" ];
      };
      "astoria" = {
        user = "simon";
        hostname = "astoria";
        setEnv = {
          LC_ALL = "C";
        };
      };
      "pi3" = {
        user = "pi";
        hostname = "pi3";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };
}
