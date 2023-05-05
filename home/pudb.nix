{ config, lib, ... }:
with lib;
let
  cfg = config.programs.pudb;
in
{
  options.programs.pudb = {
    theme = mkOption {
      type = types.str;
      description = "Theme to use with pudb";
    };
  };
  config = {
    xdg.configFile."pudb/pudb.cfg".text = generators.toINI { } {
      pudb = {
        breakpoints_weight = "1";
        current_stack_frame = "top";
        custom_shell = "";
        custom_stringifier = "";
        custom_theme = "";
        default_variables_access_level = "public";
        display = "auto";
        hide_cmdline_win = "False";
        hotkeys_breakpoints = "B";
        hotkeys_code = "C";
        hotkeys_stack = "S";
        hotkeys_variables = "V";
        line_numbers = "True";
        prompt_on_quit = "True";
        seen_welcome = "e044";
        shell = "ipython";
        sidebar_width = "0.5";
        stack_weight = "1";
        stringifier = "default";
        theme = cfg.theme;
        variables_weight = "1";
        wrap_variables = "True";
      };
    };
  };
}
