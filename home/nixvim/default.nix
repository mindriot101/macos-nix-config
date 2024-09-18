{
  imports = [
    ./base.nix
    ./cody.nix
    ./completion.nix
    ./context.nix
    ./dap.nix
    ./diffview.nix
    ./gitsigns.nix
    ./hardtime.nix
    ./lsp-format.nix
    ./lsp.nix
    ./markdown-preview.nix
    ./mini.nix
    ./neotest.nix
    ./notifications.nix
    ./octo-nvim.nix
    ./oil.nix
    ./render-markdown.nix
    ./statusbar.nix
    ./telescope.nix
    ./trouble.nix
    ./vim-test.nix
    ./which-key.nix
    ./zen-mode.nix
  ];
  config = {
    # custom overrides
    me.nixvim = {
      lsp = {
        enable = true;
        inlay-hints = false;
      };
      zen-mode.enable = true;
      completion = {
        enable = true;
        require-trigger = true;
        emoji = true;
      };
      context = {
        enable = true;
        method = "treesitter-context";
      };
      octo-nvim.enable = true;
      oil.enable = true;
      vim-test.enable = true;
      neotest.enable = false;
      notifications.enable = false;
      statusbar.enable = false;
      mini.enable = true;
      which-key.enable = true;
      diffview.enable = true;
      render-markdown.enable = true;
    };
  };
}
