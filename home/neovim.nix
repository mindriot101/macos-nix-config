{ pkgs }:
{
  enable = true;
  viAlias = true;
  vimAlias = true;
  vimdiffAlias = true;
  withPython3 = true;
  extraPython3Packages = (ps: with ps; [
    pynvim
  ]);
  extraConfig = ''
    source ~/.config/nvim/nixinit.vim
  '';
  plugins = with pkgs.vimPlugins; [
    vim-nix
    # pkgs.vimPlugins.skim
    # skim-vim
    vim-surround
    vim-unimpaired
    vim-commentary
    vim-eunuch
    vim-fugitive
    vim-rhubarb
    vim-repeat
    # vim-tmux-runner
    # vim-conflicted
    vim-test
    vim-easy-align
    fugitive-gitlab-vim
    markdown-preview-nvim
    vim-gitgutter
    telescope-nvim
    telescope-ui-select-nvim
    telescope-fzf-native-nvim
    vim-gutentags
    editorconfig-nvim
    vim-toml
    vim-svelte
    vim-terraform
    rust-vim
    lualine-nvim
    which-key-nvim

    # lsps
    nvim-lspconfig
    lsp_extensions-nvim
    lsp-status-nvim
    lsp-format-nvim

    # completion
    cmp-nvim-lsp
    cmp-buffer
    nvim-cmp
    cmp-vsnip
    cmp-emoji
    vim-vsnip
    lspkind-nvim

    # treesitter
    (nvim-treesitter.withPlugins
      (p: [
        p.tree-sitter-bash
        p.tree-sitter-c
        p.tree-sitter-cmake
        p.tree-sitter-cpp
        p.tree-sitter-dot
        p.tree-sitter-elm
        p.tree-sitter-fish
        p.tree-sitter-gitignore
        p.tree-sitter-git_rebase
        p.tree-sitter-go
        p.tree-sitter-graphql
        p.tree-sitter-html
        p.tree-sitter-http
        p.tree-sitter-javascript
        p.tree-sitter-json
        p.tree-sitter-lua
        p.tree-sitter-make
        p.tree-sitter-markdown
        p.tree-sitter-nix
        p.tree-sitter-python
        p.tree-sitter-rust
        p.tree-sitter-sql
        p.tree-sitter-toml
        p.tree-sitter-yaml
        p.tree-sitter-zig
      ]))
    nvim-treesitter-context
    playground
    plenary-nvim
  ];
}
