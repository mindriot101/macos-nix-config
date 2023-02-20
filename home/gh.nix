{ pkgs, ... }:
{
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
    extensions = [
      pkgs.gh-dash
    ];
  };

  xdg.configFile."gh-dash/config.yml".text = builtins.toJSON {
    prSections = [
      {
        title = "LS: My Pull Requests";
        filters = "is:pr is:open author:@me org:localstack";
        layout.author.hidden = true;
      }
      {
        title = "LS: Review requested";
        filters = "is:pr is:open review-requested:@me org:localstack";
      }
      {
        title = "LS: Involved";
        filters = "is:pr is:open involves:@me -author:@me org:localstack";
      }
    ];
    issuesSections = [
      {
        title = "LS: Involved";
        filters = "is:issue is:open involves:@me org:localstack";
      }
    ];
    repoPaths = {
      "localstack/*" = "~/work/localstack/*";
    };
    pager.diff = "delta";
  };
}
